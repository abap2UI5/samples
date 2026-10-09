#!/usr/bin/env node
/*
 * e2e-build - the transpiled backend the browser smoke runs the samples on.
 *
 * The framework (abap2UI5 at A2UI5_PIN, see e2e-setup.mjs) and every sample
 * class are copied into the checkout's node/downport, downported to v702 by
 * abaplint (the transpiler cannot take 7.40+ syntax), transpiled to JS into
 * node/output and served by the framework's express shim. A sample is then
 * started in a browser with ?app_start=<class> (e2e-smoke.mjs). The checkout's
 * src/ is never touched - only the copy.
 *
 *   node scripts/e2e-build.mjs                        every sample
 *   E2E_ONLY='_02[45]' node scripts/e2e-build.mjs     only matching files (debugging)
 *
 * A sample edited after the last build is NOT what the browser runs: rebuild.
 */
import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { ROOT, resolveA2UI5, patchFollowUpAction } from './lib/e2e.mjs';

const A2 = resolveA2UI5();
if (!A2) {
  console.error('e2e-build: abap2UI5 checkout not found - run `npm run e2e:setup` or set A2UI5_HOME');
  process.exit(1);
}
const ONLY = process.env.E2E_ONLY ? new RegExp(process.env.E2E_ONLY) : null;
const sh = (cmd) => execSync(cmd, { cwd: A2, stdio: 'inherit' });
// abaplint --fix exits non-zero while findings remain; it is run for its edits
const fix = (cmd) => { try { execSync(cmd, { cwd: A2, stdio: 'ignore' }); } catch { /* settled over passes */ } };
const t0 = Date.now();
const downport = path.join(A2, 'node/downport');

console.log(`e2e-build: abap2UI5 at ${A2}`);
// the framework's own pins for open-abap-core, express-icf-shim and the 702
// API (node/deps) - the transpile config and abaplint read them from there
sh('node node/setup/fetch-deps.mjs');

// 1. the framework, minus src/99 (frozen history) except the superseded exit
//    interface z2ui5_cl_ui5_user_exit still implements
fs.rmSync(downport, { recursive: true, force: true });
fs.cpSync(path.join(A2, 'src'), downport, { recursive: true });
for (const f of fs.readdirSync(path.join(A2, 'src/99'))) {
  if (/^z2ui5_if_exit\.intf\./.test(f)) fs.copyFileSync(path.join(A2, 'src/99', f), path.join(downport, f));
}
fs.rmSync(path.join(downport, '99'), { recursive: true, force: true });

// 2. the samples
let samples = 0;
for (const f of fs.readdirSync(path.join(ROOT, 'src'))) {
  if (!/^z2ui5_cl_smp_app_\w+\.clas\.(abap|xml)$/.test(f) || (ONLY && !ONLY.test(f))) continue;
  fs.copyFileSync(path.join(ROOT, 'src', f), path.join(downport, f));
  if (f.endsWith('.clas.abap')) samples++;
}
console.log(`e2e-build: ${samples} sample(s) + framework copied into node/downport`);
console.log(`e2e-build: ${patchFollowUpAction(downport)} view-wired follow_up_action( ) call(s) rewired for the transpiler`);

// 3. downport the copy with the framework's full 702 rule set (the inline
//    declarations can only be split when the types resolve); three passes settle it
const cfg = JSON.parse(fs.readFileSync(path.join(A2, '.github/abaplint/abap_702.jsonc'), 'utf8'));
cfg.global = { files: '/node/downport/**/*.*' };
fs.writeFileSync(path.join(A2, 'e2e-downport.jsonc'), JSON.stringify(cfg, null, 2));
console.log('e2e-build: downporting to v702 ...');
for (let i = 0; i < 3; i++) fix('npx abaplint e2e-downport.jsonc --fix');
fs.rmSync(path.join(A2, 'e2e-downport.jsonc'), { force: true });
// the transpiler cannot raise cx_sy_itab_line_not_found - the framework's own fixup
for (const f of fs.readdirSync(downport)) {
  if (!f.endsWith('.abap')) continue;
  const p = path.join(downport, f);
  fs.writeFileSync(p, fs.readFileSync(p, 'utf8')
    .replace(/ RAISE EXCEPTION TYPE cx_sy_itab_line_not_found/g, ' ASSERT 1 = 0')
    .replace(/[ \t]+$/gm, ''));
}

// 4. transpile with the framework's own config (it folds node/srv in first);
//    an older pin still ships the runtime ASSIGN shim and needs it applied
const shim = path.join(A2, 'node/setup/patch-abaplint-runtime-assign.mjs');
if (fs.existsSync(shim)) sh(`node ${shim}`);
console.log('e2e-build: transpiling into node/output ...');
sh('node node/setup/downport-fix.mjs prepare-transpile');
sh('npx abap_transpile ./node/setup/abap_transpile.json');

const built = fs.readdirSync(path.join(A2, 'node/output')).filter((f) => /^z2ui5_cl_smp_app_\w+\.clas\.mjs$/.test(f)).length;
console.log(`e2e-build: done - ${built} sample(s) transpiled in ${Math.round((Date.now() - t0) / 1000)} s`);
if (built !== samples) {
  console.error(`e2e-build: ${samples - built} sample(s) copied but not transpiled`);
  process.exit(1);
}
