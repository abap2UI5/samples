#!/usr/bin/env node
/*
 * downport-fixes — the text rewrites the downport makes after
 * `abaplint --fix`, in node instead of `sed -i`.
 *
 *   node scripts/downport-fixes.mjs syfixes <dir>    (npm run syfixes)
 *       every *.abap under <dir>: ` RAISE EXCEPTION TYPE
 *       cx_sy_itab_line_not_found` becomes ` ASSERT 1 = 0` - the downport
 *       writes the raise for a failed table expression, and the exception
 *       class is not there to raise on 7.02
 *   node scripts/downport-fixes.mjs strip-ws <dir>
 *       every *.abap under <dir>: whitespace at the end of a line removed
 *   node scripts/downport-fixes.mjs pathfix <file>   (npm run abaplintpathfix)
 *       `"/../../src/` becomes `"/src/` - the 702 lint config, copied to the
 *       root as abaplint.jsonc, points at the sources from its own folder
 *
 * Why not sed: `sed -i -e '…'` and `sed -i 's|…|'` are GNU spellings. BSD and
 * macOS sed take the argument after -i as the backup suffix, so the first
 * left a `<file>-e` copy beside every source and the second failed outright;
 * `\+` in a basic regex is GNU too, so a trailing-whitespace strip silently
 * matched nothing. On Linux the output is the same as the sed it replaces
 * (every file `find -type f` would have visited, symlinks not followed, the
 * substitution applied per line; a file without a final newline keeps it
 * that way). A file is only rewritten when it changes.
 *
 * Exit 0 done, 2 usage.
 */
import fs from 'fs';
import path from 'path';

const usage = () => {
  console.error('usage: node scripts/downport-fixes.mjs syfixes|strip-ws <dir>');
  console.error('       node scripts/downport-fixes.mjs pathfix <file>');
  process.exit(2);
};

/* Every regular file under `dir` whose name ends in .abap - `find <dir> -type
 * f -name '*.abap'`: a symlink is neither followed nor rewritten. */
function* abapFiles(dir) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) yield* abapFiles(p);
    else if (e.isFile() && e.name.endsWith('.abap')) yield p;
  }
}

const rewrite = (file, fix) => {
  const before = fs.readFileSync(file, 'latin1'); // bytes in, bytes out - no re-encoding
  const after = fix(before);
  if (after !== before) fs.writeFileSync(file, after, 'latin1');
};

const SYFIX = / RAISE EXCEPTION TYPE cx_sy_itab_line_not_found/g;
// [[:space:]] of the C locale minus the newline that ends the line: space,
// \t, \v, \f, \r (byte for byte - the file is read as latin1)
const TRAILING_WS = /[ \t\v\f\r]+$/;

const FIXES = {
  syfixes: (text) => text.replace(SYFIX, ' ASSERT 1 = 0'),
  'strip-ws': (text) => text.split('\n').map((line) => line.replace(TRAILING_WS, '')).join('\n'),
  pathfix: (text) => text.split('"/../../src/').join('"/src/'),
};

const [cmd, target] = process.argv.slice(2);
if (!FIXES[cmd] || !target) usage();
if (cmd === 'pathfix') rewrite(target, FIXES.pathfix);
else for (const file of abapFiles(target)) rewrite(file, FIXES[cmd]);
