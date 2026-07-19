#!/usr/bin/env node
/*
 * Generates the two overview apps' catalogs from the folder tree.
 * (These are the demo_app_g00 / sample_app_g01 index pages, not the Fiori
 * Launchpad samples in src/00/03.)
 *
 * Job (see AGENTS.md §4):
 *   1. Scan every demo app class under src/ and read its abapGit <DESCRIPT>
 *      short text and the CTEXT of the subpackage it lives in.
 *   2. Derive each tile from that:
 *        - group  = subpackage CTEXT
 *        - header = DESCRIPT part before the first " - "
 *        - sub    = DESCRIPT part after the first " - " (empty if none)
 *      Apps whose header is "ZZZ" are helper apps (called only by other apps)
 *      and are skipped.
 *   3. Rewrite the result = VALUE #( ... ) block of get_catalog( ) in the
 *      overview app of each area (src/01 -> demo_app_g00, src/00 -> sample_app_g01):
 *        - groups in folder-number order
 *        - tiles within a group sorted by header, then sub, then app
 *
 * No dependencies. Run:  node scripts/generate-launchpad.js   (or: npm run launchpad)
 * Afterwards run abaplint (must be 0 issues).
 */

const fs = require('fs');
const path = require('path');

const SRC = path.join(__dirname, '..', 'src');

// area (top-level package under src) -> overview app file
const TARGETS = {
  '01': path.join(SRC, '01', 'z2ui5_cl_demo_app_g00.clas.abap'),
  '00': path.join(SRC, '00', 'z2ui5_cl_sample_app_g01.clas.abap'),
};

// The overview apps live under src/ too; the src/01 one (z2ui5_cl_demo_app_g00)
// even shares the demo-app class-name prefix. Skip both so an overview never
// lists itself as a tile.
const OVERVIEW_APPS = new Set([
  'z2ui5_cl_demo_app_g00',
  'z2ui5_cl_sample_app_g01',
]);

function walk(dir, out = []) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    const st = fs.statSync(full);
    if (st.isDirectory()) walk(full, out);
    else out.push(full);
  }
  return out;
}

function tag(xml, name) {
  const m = xml.match(new RegExp(`<${name}>([\\s\\S]*?)</${name}>`));
  return m ? m[1] : '';
}

function unescapeXml(s) {
  return s
    .replace(/&lt;/g, '<')
    .replace(/&gt;/g, '>')
    .replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
    .replace(/&amp;/g, '&');
}

function splitDescript(d) {
  const t = unescapeXml(d).trim();
  const i = t.indexOf(' - ');
  return i === -1 ? { header: t, sub: '' } : { header: t.slice(0, i), sub: t.slice(i + 3) };
}

// Controls-section tiles (the 01/08 demo-kit rebuilds) are shown without their
// namespace prefix - the group heading already states it (sap.m, sap.uxap, …) -
// and with a one-line, truncated description so the overview never wraps.
const CONTROLS_SUB_MAX = 90;

// keep only the entity name after the last dot: sap.m.Switch -> Switch
function stripNamespace(header) {
  return header.replace(/^.*\./, '');
}

// cut to CONTROLS_SUB_MAX, backing off to the last word boundary, + " ..."
function truncateSub(sub) {
  if (sub.length <= CONTROLS_SUB_MAX) return sub;
  let cut = sub.slice(0, CONTROLS_SUB_MAX);
  const space = cut.lastIndexOf(' ');
  if (space > CONTROLS_SUB_MAX * 0.6) cut = cut.slice(0, space);
  return `${cut.replace(/[\s.,;:]+$/, '')} ...`;
}

// --- 1. scan --------------------------------------------------------------
const ctextCache = {};
function groupOf(dir) {
  if (!(dir in ctextCache)) {
    const p = path.join(dir, 'package.devc.xml');
    ctextCache[dir] = fs.existsSync(p) ? tag(fs.readFileSync(p, 'utf8'), 'CTEXT') : '';
  }
  return ctextCache[dir];
}

const tiles = { '00': [], '01': [] };
let hidden = 0;

for (const abap of walk(SRC)) {
  if (!abap.endsWith('.clas.abap')) continue;
  const cls = path.basename(abap, '.clas.abap');
  if (OVERVIEW_APPS.has(cls)) continue; // an overview app is never a tile
  if (!cls.startsWith('z2ui5_cl_demo_app')) continue;

  const rel = path.relative(SRC, abap).split(path.sep); // [ area, ...subfolders, file ]
  if (rel.length < 3) continue;
  const area = rel[0];
  // full subfolder path ("08" or nested "08/00") so nested subpackages form
  // their own group directly after their parent slot
  const subnum = rel.slice(1, -1).join('/');
  if (!(area in tiles)) continue;

  const xmlPath = abap.replace(/\.clas\.abap$/, '.clas.xml');
  if (!fs.existsSync(xmlPath)) { console.warn(`skipping ${cls}: no .clas.xml`); continue; }
  const xml = fs.readFileSync(xmlPath, 'utf8');
  let { header, sub } = splitDescript(tag(xml, 'DESCRIPT') || cls);

  // demo kit rebuilds (AGENTS.md §1) carry the full, untruncated demo kit
  // description as ABAP Doc lines below the URL line — prefer it as sub over
  // the 60-char DESCRIPT
  // the Rebuild line may be preceded by marker lines (e.g. the generated-port
  // marker), hence the multiline match
  const doc = fs.readFileSync(abap, 'utf8')
    .match(/^"! Rebuild of the UI5 demo kit sample: \S+\r?\n((?:"! .*\r?\n)+)/m);
  if (doc) {
    sub = doc[1].split(/\r?\n/)
      .map((l) => l.replace(/^"! ?/, '').trim())
      .filter(Boolean)
      .join(' ');
  }

  if (header.trim().toUpperCase() === 'ZZZ') { hidden++; continue; }

  const group = groupOf(path.dirname(abap));
  // controls section: drop the namespace prefix and truncate the description
  if (group.startsWith('controls -')) {
    header = stripNamespace(header);
    sub = truncateSub(sub);
  }

  if ((header + sub).includes('`')) throw new Error(`backtick in DESCRIPT of ${cls}`);

  tiles[area].push({ subnum, group, header, sub, app: cls });
}

// --- 2. sort --------------------------------------------------------------
const ci = (x) => x.toLowerCase();
for (const area of Object.keys(tiles)) {
  tiles[area].sort((a, b) =>
    a.subnum.localeCompare(b.subnum) ||        // groups in folder-number order
    ci(a.header).localeCompare(ci(b.header)) || // then by header (keeps I/II/III together)
    ci(a.sub).localeCompare(ci(b.sub)) ||
    ci(a.app).localeCompare(ci(b.app)));
}

// --- 3. rewrite get_catalog( ) -------------------------------------------
function rewrite(file, list) {
  let text = fs.readFileSync(file, 'utf8');

  const open = text.indexOf('result = VALUE #(');
  const close = text.indexOf(') ).', open);
  if (open === -1 || close === -1) throw new Error(`no VALUE block in ${file}`);

  // indentation of the tiles = indent of "result" line + 2 spaces
  const indent = ' '.repeat((text.slice(0, open).match(/\n( *)$/) || [, ''])[1].length + 2);

  // ABAP sources are limited to 255 characters per line — longer lines break
  // the abapGit import ("Literals across more than one line are not allowed")
  const MAX_LINE = 255;
  const rows = list.map((t) => {
    const one = `${indent}( group = \`${t.group}\` header = \`${t.header}\` sub = \`${t.sub}\` app = \`${t.app}\` )`;
    if (one.length <= MAX_LINE) return one;
    // split the sub literal into && chunks so no line exceeds the limit
    const subIndent = `${indent}  `;
    const contIndent = `${subIndent}      `; // aligns under the first chunk's opening backtick
    const chunkSize = MAX_LINE - contIndent.length - 6;
    const chunks = [];
    for (let s = t.sub; s.length; s = s.slice(chunkSize)) chunks.push(s.slice(0, chunkSize));
    const subLines = chunks.map((c, i) =>
      `${i === 0 ? `${subIndent}sub = ` : contIndent}\`${c}\`${i < chunks.length - 1 ? ' &&' : ''}`);
    return [
      `${indent}( group = \`${t.group}\` header = \`${t.header}\``,
      ...subLines,
      `${subIndent}app = \`${t.app}\` )`,
    ].join('\n');
  });
  // the last row additionally closes the constructor + statement
  rows[rows.length - 1] += ' ).';

  const block = `result = VALUE #(\n${rows.join('\n')}`;
  text = text.slice(0, open) + block + text.slice(close + ') ).'.length);
  fs.writeFileSync(file, text);
}

let total = 0;
for (const [area, file] of Object.entries(TARGETS)) {
  rewrite(file, tiles[area]);
  console.log(`${path.relative(path.join(__dirname, '..'), file)}: ${tiles[area].length} tiles`);
  total += tiles[area].length;
}
console.log(`generated ${total} tiles, ${hidden} ZZZ helper app(s) hidden`);
console.log('now run: npx abaplint  (expect 0 issues)');
