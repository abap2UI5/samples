/*
 * Self-test of the generators and of the plain-node gates that are not
 * source scanners (checks.test.mjs holds those).
 *
 * Run:  npm run check:selftest   (node --test scripts/test/)
 */
import { test } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

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
