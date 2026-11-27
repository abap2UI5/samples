/*
 * Self-test of the generators and of the plain-node gates that are not
 * source scanners (checks.test.mjs holds those).
 *
 * Run:  npm run check:selftest   (node --test scripts/test/)
 */
import { test } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { abapLiteral, chunkLiteral, rewriteCatalog, MAX_LINE } from '../lib/catalog-block.mjs';

const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');

/* A bare localeCompare( ) collates in the locale of whoever runs the
 * generator, so the committed order of a generated file would depend on the
 * machine that wrote it. Every generator sorts with Intl.Collator('en')
 * instead. check-prose-names.mjs is a pulled copy whose source is abap2UI5
 * (shared-file-gate), so it is not this repository's to change. */
test('no generator sorts with a bare localeCompare( )', () => {
  const offenders = [];
  const walk = (dir) => {
    for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, e.name);
      if (e.isDirectory()) { if (e.name !== 'test') walk(p); continue; }
      if (!e.name.endsWith('.mjs') || e.name === 'check-prose-names.mjs') continue;
      fs.readFileSync(p, 'utf8').split('\n').forEach((l, i) => {
        if (/\.localeCompare\(/.test(l)) offenders.push(`${path.relative(ROOT, p)}:${i + 1}`);
      });
    }
  };
  walk(path.join(ROOT, 'scripts'));
  assert.deepEqual(offenders, []);
});

/* ------------------------------------------- lib/catalog-block.mjs */

const CLASS = [
  '" @summary old',
  'CLASS z2ui5_cl_smp_app_000 DEFINITION.',
  '    CONSTANTS c_legend TYPE string VALUE `old`.',
  'ENDCLASS.',
  'CLASS z2ui5_cl_smp_app_000 IMPLEMENTATION.',
  '  METHOD get_catalog.',
  '',
  '    result = VALUE #(',
  '      ( group = `g` header = `h` sub = `s` keywords = `` intro = `` path = `src` app = `cl_old` ) ).',
  '',
  '  ENDMETHOD.',
  '',
  '  METHOD after.',
  '    result = VALUE #( ( a = 1 ) ).',
  '  ENDMETHOD.',
  'ENDCLASS.',
  '',
].join('\n');

const tile = (over) => ({ group: 'G', header: 'H', sub: 'S', keywords: 'k', intro: '', path: 'src', app: 'z2ui5_cl_smp_app_001', ...over });

/* Every backtick literal on a line, read the way ABAP reads it: `` inside is
 * one backtick, a lone one ends the literal. Returns the decoded values and
 * whether anything outside the literals is left that is not ABAP syntax. */
const literals = (line) => {
  const out = [];
  for (let i = line.indexOf('`'); i !== -1; i = line.indexOf('`', i + 1)) {
    let v = '';
    let j = i + 1;
    for (; j < line.length; j++) {
      if (line[j] === '`' && line[j + 1] === '`') { v += '`'; j++; continue; }
      if (line[j] === '`') break;
      v += line[j];
    }
    assert.ok(j < line.length, `unterminated literal in: ${line}`);
    out.push(v);
    i = j;
  }
  return out;
};

test('catalog-block: a backtick in a value is doubled, so the literal still ends where it should', () => {
  assert.equal(abapLiteral('use `_bind( )`'), 'use ``_bind( )``');
  const out = rewriteCatalog(CLASS, [
    tile({ group: 'Stage `one`', intro: 'Read `_bind( )` first.', sub: 'a ` b' }),
  ]);
  const block = out.slice(out.indexOf('result = VALUE #('), out.indexOf('  ENDMETHOD.'));
  const values = block.split('\n').flatMap(literals);
  assert.ok(values.includes('Stage `one`'), values.join(' | '));
  assert.ok(values.includes('Read `_bind( )` first.'));
  assert.ok(values.includes('a ` b'));
});

test('catalog-block: a long escaped literal is never split between the two backticks of a pair', () => {
  for (let size = 2; size <= 9; size++) {
    const escaped = abapLiteral('ab`c``d`e'.repeat(7));
    const chunks = chunkLiteral(escaped, size);
    assert.equal(chunks.join(''), escaped);
    for (const c of chunks) {
      assert.ok(c.length <= size);
      assert.equal((c.match(/`+$/) || [''])[0].length % 2, 0, `size ${size}: chunk ${c} ends inside a pair`);
    }
  }
  const out = rewriteCatalog(CLASS, [tile({ intro: `${'x'.repeat(220)}\`${'y'.repeat(300)}` })]);
  for (const line of out.split('\n')) assert.ok(line.length <= MAX_LINE, line);
  const intro = out.split('\n').filter((l) => /^ +(intro = )?`/.test(l) && !/keywords|sub =/.test(l))
    .flatMap(literals).join('');
  assert.ok(intro.includes(`${'x'.repeat(220)}\`${'y'.repeat(300)}`));
});

test('catalog-block: the block ends at the ENDMETHOD, not at the first ") )." a tile text holds', () => {
  const list = [tile({ sub: 'call meth( x( ) ). and more' }), tile({ app: 'z2ui5_cl_smp_app_002', sub: 'end ) ).' })];
  const once = rewriteCatalog(CLASS, list);
  assert.equal(rewriteCatalog(once, list), once, 'idempotent - nothing of the old block left behind');
  assert.equal(once.match(/cl_smp_app_00[12]/g).length, 2);
  assert.ok(!once.includes('cl_old'));
  assert.ok(once.includes('  METHOD after.\n    result = VALUE #( ( a = 1 ) ).\n  ENDMETHOD.'), 'the next method is untouched');
  assert.ok(once.includes('` ) ).\n\n  ENDMETHOD.'), 'the blank line before ENDMETHOD stays');
});

test('catalog-block: anything else in get_catalog( ) is refused rather than overwritten', () => {
  assert.throws(() => rewriteCatalog(CLASS.replace('\n    result = VALUE #(', '\n    DATA x TYPE i.\n    result = VALUE #('), [tile()]),
    /exactly one result = VALUE/);
  assert.throws(() => rewriteCatalog(CLASS.replace('METHOD get_catalog.', 'METHOD get_tiles.'), [tile()]),
    /no METHOD get_catalog/);
});

/* ------------------------------------------------ downport-fixes.mjs */

/* `npm run syfixes` was `find . … -exec sed -i -e …`, which BSD and macOS
 * sed read differently (the argument after -i is a backup suffix there, so
 * every source got a `<file>-e` copy). The node version has to do what GNU
 * sed did: every *.abap under the folder, per line, nothing else touched. */
test('downport-fixes: syfixes rewrites the raise in every *.abap, and nothing else', () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'downport-fixes-'));
  const raise = ' RAISE EXCEPTION TYPE cx_sy_itab_line_not_found';
  fs.mkdirSync(path.join(root, 'src', 'sub'), { recursive: true });
  fs.writeFileSync(path.join(root, 'src', 'sub', 'a.clas.abap'), `  IF x.${raise}.${raise}\n  ENDIF.  \nlast`);
  fs.writeFileSync(path.join(root, 'src', 'note.md'), `${raise}\n`);
  const r = spawnSync(process.execPath, [path.join(ROOT, 'scripts', 'downport-fixes.mjs'), 'syfixes', '.'],
    { cwd: root, encoding: 'utf8' });
  assert.equal(r.status, 0, r.stderr);
  assert.equal(fs.readFileSync(path.join(root, 'src', 'sub', 'a.clas.abap'), 'utf8'),
    '  IF x. ASSERT 1 = 0. ASSERT 1 = 0\n  ENDIF.  \nlast');
  assert.equal(fs.readFileSync(path.join(root, 'src', 'note.md'), 'utf8'), `${raise}\n`);
  assert.equal(fs.readdirSync(path.join(root, 'src', 'sub')).length, 1, 'no backup file beside the source');
});
