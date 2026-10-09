#!/usr/bin/env node
/*
 * e2e-setup - clone abap2UI5 at A2UI5_PIN into .abap2UI5 (git-ignored) and
 * install its dependencies. The framework checkout supplies what runs the
 * samples without a SAP system: abaplint (the downport), the transpiler, the
 * open-abap runtime and the express shim. Re-runnable: an existing clone is
 * moved to the pin instead of cloned again.
 *
 *   node scripts/e2e-setup.mjs        then `npm run e2e:build`, `npm run e2e`
 *
 * A2UI5_HOME pointing at a checkout of your own skips this script entirely.
 */
import { execFileSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { IN_REPO_A2UI5, readPin } from './lib/e2e.mjs';

const PIN = readPin();
if (!PIN) {
  console.error('e2e-setup: A2UI5_PIN is missing or not a 40-character commit');
  process.exit(1);
}
const git = (...args) => execFileSync('git', ['-C', IN_REPO_A2UI5, ...args], { stdio: 'inherit' });

if (!fs.existsSync(path.join(IN_REPO_A2UI5, '.git'))) {
  fs.rmSync(IN_REPO_A2UI5, { recursive: true, force: true });
  fs.mkdirSync(IN_REPO_A2UI5);
  git('init', '--quiet');
  git('remote', 'add', 'origin', 'https://github.com/abap2UI5/abap2UI5');
}
console.log(`e2e-setup: abap2UI5 at ${PIN} into .abap2UI5`);
git('fetch', '--quiet', '--depth', '1', 'origin', PIN);
git('checkout', '--quiet', '--force', '--detach', 'FETCH_HEAD');
execFileSync('npm', ['ci', '--no-audit', '--no-fund'], { cwd: IN_REPO_A2UI5, stdio: 'inherit' });
console.log('e2e-setup: done - next `npm run e2e:build`');
