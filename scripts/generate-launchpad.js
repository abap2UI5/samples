#!/usr/bin/env node
/*
 * Generates the two launchpad apps' catalogs from the folder tree.
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
 *      launchpad app of each area (src/01 -> sample_app_001, src/00 -> sample_app_000):
 *        - groups in folder-number order
 *        - tiles within a group sorted by header, then sub, then app
 *
 * No dependencies. Run:  node scripts/generate-launchpad.js   (or: npm run launchpad)
 * Afterwards run abaplint (must be 0 issues).
 */

const fs = require('fs');
const path = require('path');

const SRC = path.join(__dirname, '..', 'src');

// area (top-level package under src) -> launchpad app file
const TARGETS = {
  '01': path.join(SRC, '01', 'z2ui5_cl_sample_app_001.clas.abap'),
  '00': path.join(SRC, '00', 'z2ui5_cl_sample_app_000.clas.abap'),
};

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
  if (!cls.startsWith('z2ui5_cl_demo_app')) continue;

  const rel = path.relative(SRC, abap).split(path.sep); // [ area, subnum, file ]
  if (rel.length < 3) continue;
  const [area, subnum] = rel;
  if (!(area in tiles)) continue;

  const xml = fs.readFileSync(abap.replace(/\.clas\.abap$/, '.clas.xml'), 'utf8');
  const { header, sub } = splitDescript(tag(xml, 'DESCRIPT') || cls);

  if (header.trim().toUpperCase() === 'ZZZ') { hidden++; continue; }
  if ((header + sub).includes('`')) throw new Error(`backtick in DESCRIPT of ${cls}`);

  tiles[area].push({ subnum, group: groupOf(path.dirname(abap)), header, sub, app: cls });
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

  const rows = list.map(
    (t) => `${indent}( group = \`${t.group}\` header = \`${t.header}\` sub = \`${t.sub}\` app = \`${t.app}\` )`);
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
