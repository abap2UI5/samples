#!/usr/bin/env node
/*
 * check-app-patterns — three app-code shapes that render, lint and run, and
 * are still wrong. Each was fixed by hand in a sweep and had nothing keeping
 * it fixed.
 *
 * 1. CHAIN_SIBLING - a second element chained at the level of a statement's
 *    HEAD element.
 *
 *    `page->tag( \`Title\` )->a( … )->tag( \`Text\` )` builds two siblings
 *    under `page`, but the layout rule (`chain-house-layout`) measures every
 *    segment from the statement's start plus four spaces, so the second tag
 *    is written one level DEEPER than it sits in the tree: the indent says
 *    child, the tree says sibling. The same holds for an `ele( )` head that is
 *    closed with `end( )` and followed by another element, and for an
 *    `end( )` that climbs above the receiver. Seventeen classes carried it
 *    until 2026-10-08, each fixed by starting a new statement per sibling
 *    from the container (AGENTS.md section 10, "one statement per subtree").
 *
 *    The idiom `x->end( )->ele( … )` - a statement that OPENS with `end( )`
 *    to reach the parent of a held container - is not this finding: the
 *    leading `end( )`s only choose the receiver, and the first element after
 *    them is the head.
 *
 * 2. NAV_LEAVE_GET_APP - `nav_app_leave( … get_app( … id_prev_app_stack … ) )`.
 *
 *    The previous app on the stack is exactly where a bare `nav_app_leave( )`
 *    goes by itself. Loading it by id first is not just longer: when the
 *    caller's draft has expired, `get_app( )` fails the roundtrip, while the
 *    bare call drops the leave and keeps the screen (z2ui5_if_client, the
 *    `app` parameter). Write `nav_app_leave( )`, or
 *    `nav_app_leave( event = … )` to hand an event back.
 *
 * 3. NUMERIC_INPUT_UNTRACED - an `Input` whose `value` is a plain
 *    `client->_bind( <attr> )` of a numeric public attribute (TYPE i, int8,
 *    p, decfloat16/34, f), in a class that computes with that attribute,
 *    and a class that never reads `t_model_skipped`.
 *
 *    The binding carries no UI5 type, so the browser accepts any text. Text
 *    the ABAP type refuses (`1,250`, `abc`) is skipped on the way in: the
 *    attribute keeps its old value, the handler computes with it, and the
 *    field still shows what the user typed - a result that silently does not
 *    match the input. The one trace is `client->get( )-t_model_skipped`; a
 *    class that computes with such an input has to read it. Decided from the
 *    class alone: the attribute must be declared in this class's PUBLIC
 *    SECTION, and "computes" means it stands next to an arithmetic operator
 *    in the implementation.
 *
 * The scan reads ABAP STATEMENTS with comments removed and literal contents
 * blanked, so a MessageStrip text that NAMES one of these calls is not code.
 *
 * Run:  npm run check:patterns
 */
import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const ROOT = fileURLToPath(new URL('..', import.meta.url));

/* Two readings of the source with identical offsets: `code` drops comments
 * (a `*` line, `"` to the end of the line) and keeps literals; `mask` also
 * blanks every literal's content, delimiters kept. */
function readings(source) {
  const code = [];
  const mask = [];
  for (const line of source.split('\n')) {
    if (line.startsWith('*')) {
      code.push(' '.repeat(line.length));
      mask.push(' '.repeat(line.length));
      continue;
    }
    let c = '';
    let m = '';
    // what we are inside: 'code', a literal (` or '), a template's text (|),
    // or '{' - the embedded expression of a template, which is code again
    const stack = ['code'];
    for (let i = 0; i < line.length; i++) {
      const ch = line[i];
      const top = stack[stack.length - 1];
      if (top === '`' || top === "'") {
        c += ch;
        if (ch === top) { stack.pop(); m += ch; } else m += ' ';
        continue;
      }
      if (top === '|') {
        c += ch;
        if (ch === '\\' && i + 1 < line.length) {
          c += line[i + 1];
          m += '  ';
          i++;
        } else if (ch === '{') {
          stack.push('{');
          m += ch;
        } else if (ch === '|') {
          stack.pop();
          m += ch;
        } else m += ' ';
        continue;
      }
      if (top === '{' && ch === '}') {
        stack.pop();
        c += ch;
        m += ch;
        continue;
      }
      if (ch === '"') {
        c += ' '.repeat(line.length - i);
        m += ' '.repeat(line.length - i);
        break;
      }
      if (ch === '`' || ch === "'" || ch === '|') stack.push(ch);
      c += ch;
      m += ch;
    }
    code.push(c);
    mask.push(m);
  }
  return { code: code.join('\n'), mask: mask.join('\n') };
}

/* Statements of the masked source: offset and text, split at a `.` outside
 * parentheses (literals are blank, so a `.` inside one is gone already). */
function statements(mask) {
  const out = [];
  let depth = 0;
  let start = 0;
  for (let i = 0; i < mask.length; i++) {
    const ch = mask[i];
    if (ch === '(') depth++;
    else if (ch === ')') depth--;
    else if (ch === '.' && depth === 0) {
      out.push({ offset: start, text: mask.slice(start, i) });
      start = i + 1;
    }
  }
  return out;
}

const lineAt = (source, offset) => source.slice(0, offset).split('\n').length;

/* The builder verbs and their roles. */
const ROLE = { ele: 'open', tag: 'leaf', a: 'att', end: 'shut', stringify: 'stringify', factory: 'factory' };

/* The chain segments of one statement: every `->verb(` / `=>factory(` at
 * parenthesis depth 0 - a builder call inside an argument (`stringify( )` in
 * `view_display( … )`) is not a segment of this chain. */
function segments(text) {
  const out = [];
  const re = /(->|=>)\s*(ele|tag|a|end|stringify|factory)\s*\(/gi;
  let m;
  while ((m = re.exec(text)) !== null) {
    let depth = 0;
    for (let i = 0; i < m.index; i++) {
      if (text[i] === '(') depth++;
      else if (text[i] === ')') depth--;
    }
    if (depth !== 0) continue;
    out.push({ role: ROLE[m[2].toLowerCase()], at: m.index, open: m.index + m[0].length - 1 });
  }
  return out;
}

/* The argument text of the call whose `(` stands at `open`. */
function argsAt(text, open) {
  let depth = 0;
  for (let i = open; i < text.length; i++) {
    if (text[i] === '(') depth++;
    else if (text[i] === ')') {
      depth--;
      if (depth === 0) return { from: open + 1, to: i };
    }
  }
  return { from: open + 1, to: text.length };
}

const usesBuilder = (code) => /z2ui5_cl_ui5_view_builder\s*=>\s*factory/i.test(code);

/** Rule 1: findings [{ line, message }] for one class source. */
function chainSiblings(source) {
  const { code, mask } = readings(source);
  if (!usesBuilder(code)) return [];
  const findings = [];
  for (const st of statements(mask)) {
    const segs = segments(st.text).filter((s) => s.role !== 'att' && s.role !== 'stringify' && s.role !== 'factory');
    if (segs.length < 2) continue;
    let k = 0;
    while (k < segs.length && segs[k].role === 'shut') k++; // `x->end( )->…` chooses the receiver
    if (k >= segs.length) continue;
    let depth = segs[k].role === 'open' ? 1 : 0;
    for (const s of segs.slice(k + 1)) {
      const line = lineAt(source, st.offset + s.at);
      if (s.role === 'shut') {
        depth--;
        if (depth < 0) {
          findings.push({ line, message: 'end( ) climbs above the element the statement started from - start a new statement from the container instead' });
          depth = 0;
        }
        continue;
      }
      if (depth === 0) {
        findings.push({ line, message: 'a sibling of the statement\'s head element, written one level too deep - start a new statement for it from the container (AGENTS.md section 10)' });
      }
      if (s.role === 'open') depth++;
    }
  }
  return findings;
}

/** Rule 2: findings [{ line, message }] for one class source. */
function navLeaveGetApp(source) {
  const { mask } = readings(source);
  const findings = [];
  const loadsStackApp = (t) => /\bget_app\s*\(/i.test(t) && /\bid_prev_app_stack\b/i.test(t);
  // variables of the current method holding the stack app loaded by id:
  // `DATA(app) = CAST …( client->get_app( …id_prev_app_stack ) ).` and then
  // `client->nav_app_leave( app ).` is the same detour in two statements
  let held = new Set();
  for (const st of statements(mask)) {
    const t = st.text.trim();
    if (/^(METHOD|ENDMETHOD)\b/i.test(t)) held = new Set();
    const assign = /^(?:DATA\(\s*(\w+)\s*\)|(\w+))\s*=/i.exec(t);
    if (assign && loadsStackApp(t)) held.add((assign[1] || assign[2]).toLowerCase());
    const re = /nav_app_leave\s*\(/gi;
    let m;
    while ((m = re.exec(st.text)) !== null) {
      const { from, to } = argsAt(st.text, m.index + m[0].length - 1);
      const args = st.text.slice(from, to);
      const viaVariable = [...held].some((v) => new RegExp(`^\\s*(app\\s*=\\s*)?${v}\\b`, 'i').test(args));
      if (loadsStackApp(args) || viaVariable) {
        findings.push({
          line: lineAt(source, st.offset + m.index),
          message: 'nav_app_leave( get_app( …id_prev_app_stack ) ) - the bare nav_app_leave( ) goes there by itself and survives an expired caller draft; write nav_app_leave( ) or nav_app_leave( event = … )',
        });
      }
    }
  }
  return findings;
}

const NUMERIC = /^(i|int8|p|f|decfloat16|decfloat34)$/i;

/* Scalar numeric attributes of the PUBLIC SECTION: `DATA x TYPE i.`,
 * `DATA x TYPE p LENGTH 10 DECIMALS 2.`, and the elements of a `DATA:` chain. */
function numericPublicAttributes(mask) {
  const pub = /\bPUBLIC\s+SECTION\s*\.([\s\S]*?)\b(PROTECTED\s+SECTION|PRIVATE\s+SECTION|ENDCLASS)\b/i.exec(mask);
  if (!pub) return new Set();
  const out = new Set();
  for (const st of statements(pub[1])) {
    const t = st.text.trim();
    const chained = /^DATA\s*:/i.test(t);
    if (!chained && !/^DATA\s/i.test(t)) continue;
    const body = t.replace(/^DATA\s*:?/i, '');
    for (const part of chained ? body.split(',') : [body]) {
      const m = /^\s*(\w+)\s+TYPE\s+(\w+)\b/i.exec(part);
      if (m && NUMERIC.test(m[2])) out.add(m[1].toLowerCase());
    }
  }
  return out;
}

/* Does the implementation compute with `name`? Either it stands next to an
 * arithmetic operator (`+ - * / **`, `DIV`, `MOD`, `+=` and friends), or it
 * is handed to a method as an argument (`calc( net = amount )`,
 * `calc( amount )`) - the logic living in a method of its own. As the
 * attribute itself: `ls_row-name` and `name-comp` are other things. Not
 * computing: binding it (`_bind( name )`, `_bind_path( … )`), putting it
 * into a constructor (`VALUE #( qty = name )`) or into a template. */
const NOT_COMPUTING = /^(a|message_toast_display|message_box_display|_bind|_bind_path|_bind_edit|VALUE|NEW|REF|CORRESPONDING|xsdbool|boolc|lines|condense|to_upper|to_lower)$/i;
function computesWith(impl, name) {
  const n = `(?<![\\w-])(?:me->)?${name}(?![\\w-])`;
  const op = '(?:\\*\\*|[-+*/]=?|DIV|MOD)';
  if (new RegExp(`${n}\\s+${op}\\s|\\s${op}\\s+${n}`, 'i').test(impl)) return true;
  const arg = new RegExp(`(?:\\(\\s*|\\b\\w+\\s*=\\s*)${n}\\s*(?=\\)|\\w+\\s*=)`, 'gi');
  let m;
  while ((m = arg.exec(impl)) !== null) {
    // the call whose parenthesis the argument stands in
    let depth = 0;
    let open = -1;
    for (let i = m.index; i >= 0; i--) {
      if (impl[i] === ')') depth++;
      else if (impl[i] === '(') {
        if (depth === 0) { open = i; break; }
        depth--;
      }
    }
    if (open < 0) continue;
    const callee = /([\w#]+)\s*$/.exec(impl.slice(Math.max(0, open - 60), open));
    if (!callee || callee[1] === '#') continue;
    const before = impl.slice(Math.max(0, open - 60), open - callee[1].length);
    if (/\b(VALUE|NEW|REF|CONV|CORRESPONDING|COND|SWITCH)\s*$/i.test(before)) continue;
    if (!NOT_COMPUTING.test(callee[1])) return true;
  }
  return false;
}

/** Rule 3: findings [{ line, message }] for one class source. */
function numericInputUntraced(source) {
  const { code, mask } = readings(source);
  if (!usesBuilder(code)) return [];
  if (/\bt_model_skipped\b/i.test(mask)) return [];
  const numeric = numericPublicAttributes(mask);
  if (numeric.size === 0) return [];
  const implAt = mask.search(/\bCLASS\s+\w+\s+IMPLEMENTATION\b/i);
  const impl = implAt >= 0 ? mask.slice(implAt) : '';
  const findings = [];
  for (const st of statements(mask)) {
    const segs = segments(st.text);
    let input = false;
    for (const s of segs) {
      const { from, to } = argsAt(st.text, s.open);
      const args = code.slice(st.offset + from, st.offset + to);
      if (s.role === 'open' || s.role === 'leaf') {
        input = /^\s*(n\s*=\s*)?`Input`(\s|$)/.test(args) && !/\bns\s*=/i.test(args);
        continue;
      }
      if (s.role !== 'att' || !input) {
        if (s.role === 'shut') input = false;
        continue;
      }
      if (!/\bn\s*=\s*`value`/.test(args)) continue;
      const v = /\bv\s*=\s*(?:me->)?client->_bind\(\s*(?:val\s*=\s*)?(?:me->)?(\w+)\s*\)\s*$/i.exec(args);
      if (!v) continue;
      const name = v[1].toLowerCase();
      if (!numeric.has(name) || !computesWith(impl, name)) continue;
      findings.push({
        line: lineAt(source, st.offset + s.at),
        message: `Input value bound untyped to the numeric attribute ${name}, which the class computes with, and the class never reads client->get( )-t_model_skipped - refused input leaves the old value standing behind the text the user typed`,
      });
    }
  }
  return findings;
}

const RULES = {
  chain_sibling: chainSiblings,
  nav_leave_get_app: navLeaveGetApp,
  numeric_input_untraced: numericInputUntraced,
};

export { readings, statements, chainSiblings, navLeaveGetApp, numericInputUntraced, RULES };

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  main();
}

function main() {
  const findings = [];
  for (const file of readdirSync(join(ROOT, 'src')).filter((f) => f.endsWith('.clas.abap')).sort()) {
    const source = readFileSync(join(ROOT, 'src', file), 'utf8');
    for (const [rule, check] of Object.entries(RULES)) {
      for (const f of check(source)) findings.push({ rule, at: `src/${file}:${f.line}`, message: f.message });
    }
  }
  if (findings.length > 0) {
    console.error('check-app-patterns: these build, lint and run - and are still wrong.\n');
    for (const f of findings) console.error(`  [${f.rule}] ${f.at}\n      ${f.message}`);
    console.error(
      '\nchain_sibling          - one statement per sibling, started from the container variable;\n' +
      '                         `x->end( )->ele( … )` at the START of a statement is fine.\n' +
      'nav_leave_get_app      - client->nav_app_leave( ) or nav_app_leave( event = … ).\n' +
      'numeric_input_untraced - read client->get( )-t_model_skipped and tell the user, or\n' +
      '                         give the binding a UI5 type that refuses the text in the browser.',
    );
    process.exit(1);
  }
  console.log('check-app-patterns: no sibling chained after a head element, no nav_app_leave( get_app( ) ),\n                    no untraced numeric Input a handler computes with - OK');
}
