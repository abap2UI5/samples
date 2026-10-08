/*
 * Self-test of the source-scanning gates: check-atc.mjs and
 * check-app-patterns.mjs.
 *
 * A green gate proves little on its own - after the sweep that motivated a
 * rule, the tree no longer holds the shape it was written for, so a rule
 * that silently stopped matching looks exactly like a clean tree. Each rule
 * is run here against a fixture that MUST fire it (at the line asserted) and
 * one that must not, the negatives being the look-alikes each rule's header
 * names as "not this finding".
 *
 * The fixtures live outside src/, so no abapGit pull, abaplint run or
 * catalogue ever sees them.
 *
 * Run:  npm run check:selftest   (node --test scripts/test/)
 */
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { scan } from '../check-atc.mjs';
import { RULES } from '../check-app-patterns.mjs';

const fixture = (name) => readFileSync(new URL(`fixtures/${name}`, import.meta.url), 'utf8');

/* `rule@line` for every finding, sorted - one string to compare. */
const atc = (name) => scan(fixture(name)).map((f) => `${f.rule}@${f.line}`).sort();
const patterns = (name) => Object.entries(RULES)
  .flatMap(([rule, check]) => check(fixture(name)).map((f) => `${rule}@${f.line}`))
  .sort();

test('check-atc: every rule fires on its shape', () => {
  assert.deepEqual(atc('atc-findings.abap'), [
    'abapdoc_raising@3',
    'nowhere@18',
    'subrc_after_assign@20',
    'text_symbol_arg@23',
  ]);
});

test('check-atc: the look-alikes stay silent', () => {
  // #EC CI_NOWHERE, a WHERE, a multi-line ASSIGN COMPONENT, a symbol in an
  // assignment and in a template, a @raising the signature declares
  assert.deepEqual(atc('atc-clean.abap'), []);
});

test('check-app-patterns: every rule fires on its shape', () => {
  assert.deepEqual(patterns('patterns-findings.abap'), [
    'chain_sibling@30',
    'chain_sibling@36',
    'chain_sibling@39',
    'nav_leave_get_app@47',
    'nav_leave_get_app@51',
    'numeric_input_untraced@29',
    'numeric_input_untraced@31',
  ]);
});

test('check-app-patterns: the look-alikes stay silent', () => {
  // a leading x->end( ) choosing the receiver, nested ele/end inside the
  // head, prose naming the call, plain nav_app_leave( event = ), a numeric
  // Input in a class that reads t_model_skipped
  assert.deepEqual(patterns('patterns-clean.abap'), []);
});

test('check-app-patterns: no t_model_skipped read - the computed Input fires, the displayed one does not', () => {
  const src = fixture('patterns-clean.abap').replace(/t_model_skipped/g, 't_other');
  const hits = RULES.numeric_input_untraced(src).map((f) => f.line);
  assert.deepEqual(hits, [42]); // amount feeds gross_amount( ); quantity is only shown
});
