#!/usr/bin/env node
/*
 * e2e-smoke - every sample as the real app, in a headless browser.
 *
 * The static gates (abaplint, the abap2UI5 linter and its headless render)
 * judge the ABAP and a reconstructed view. This runs the app: the transpiled
 * backend from e2e-build.mjs answers the roundtrips, the real UI5 component
 * boots and renders, and buttons are pressed. Per app it fails on
 *
 *   - a fatal-error overlay (the framework renders a crash instead of throwing),
 *   - a page error or a console error,
 *   - a backend answer 4xx/5xx (the dump text is quoted),
 *   - a near-empty page,
 *
 * at boot, after typing into the first input and selecting the first row of
 * the first table or list, and after each of up to --max-press visible
 * buttons (Escape after every press closes what it opened). An app with a
 * module in e2e/flows/ runs that flow instead of the generic steps. What is expected to fail,
 * and the harness noise, is in e2e/expected.mjs - each with its reason.
 *
 *   node scripts/e2e-smoke.mjs                  every sample, exit 1 on a failure
 *   node scripts/e2e-smoke.mjs --only 024,104   class-name suffixes
 *   node scripts/e2e-smoke.mjs --port 3101      the backend's port (default 3000)
 *   node scripts/e2e-smoke.mjs --max-press 0    boot only
 *   node scripts/e2e-smoke.mjs --no-fill        press buttons on the untouched view
 */
import fs from 'fs';
import path from 'path';
import { spawn } from 'child_process';
import { pathToFileURL } from 'url';
import { chromium } from 'playwright';
import { ROOT, resolveA2UI5, benign, allowEvalForSourceUi5, waitForIdle } from './lib/e2e.mjs';
import { APPS, NOISE } from '../e2e/expected.mjs';

const arg = (k, d) => { const i = process.argv.indexOf(k); return i === -1 ? d : process.argv[i + 1]; };
const PORT = Number(arg('--port', '3000'));
const ORIGIN = `http://localhost:${PORT}`;
const ONLY = arg('--only', '')?.split(',').filter(Boolean);
const MAX_PRESS = Number(arg('--max-press', '6'));
const FILL = !process.argv.includes('--no-fill');
if (!(PORT > 0 && PORT < 65536) || !(MAX_PRESS >= 0)) {
  console.error('e2e-smoke: --port wants a TCP port, --max-press a number');
  process.exit(2);
}

const A2 = resolveA2UI5();
if (!A2) { console.error('e2e-smoke: abap2UI5 checkout not found - run `npm run e2e:setup`'); process.exit(1); }
const OUTPUT = path.join(A2, 'node/output');
let classes = fs.existsSync(OUTPUT) ? fs.readdirSync(OUTPUT).filter((f) => /^z2ui5_cl_smp_app_\w+\.clas\.mjs$/.test(f)).map((f) => f.slice(0, -9)).sort() : [];
if (!classes.length) { console.error('e2e-smoke: no transpiled sample - run `npm run e2e:build`'); process.exit(1); }
if (ONLY.length) classes = classes.filter((c) => ONLY.some((o) => c.endsWith(o)));

const FLOWS = {};
const FLOW_DIR = path.join(ROOT, 'e2e/flows');
for (const f of fs.readdirSync(FLOW_DIR).filter((x) => x.endsWith('.mjs'))) {
  FLOWS[f.slice(0, -4)] = (await import(pathToFileURL(path.join(FLOW_DIR, f)).href)).default;
}

// UI5 from the local @openui5 packages - the shell asks the CDN, which the
// harness answers from node_modules (no network, and the version is pinned)
const UI5 = path.join(ROOT, 'node_modules/@openui5');
const LIB_ROOTS = fs.readdirSync(UI5).map((p) => path.join(UI5, p, 'src')).filter((p) => fs.existsSync(p));
const MIME = { '.js': 'text/javascript', '.css': 'text/css', '.json': 'application/json', '.xml': 'application/xml', '.properties': 'text/plain', '.png': 'image/png', '.svg': 'image/svg+xml', '.ttf': 'font/ttf', '.woff2': 'font/woff2' };
function resolveLocal(pathname) {
  const i = pathname.indexOf('/resources/');
  if (i < 0) return null;
  const rel = pathname.slice(i + 11).replace(/^sap-ui-cachebuster\//, '');
  for (const root of LIB_ROOTS) {
    const full = path.join(root, rel);
    if (full.startsWith(root) && fs.existsSync(full) && fs.statSync(full).isFile()) return { body: fs.readFileSync(full), type: MIME[path.extname(full)] || 'application/octet-stream' };
  }
  return null;
}

const noise = (cls, text) => benign(text) || NOISE.some((n) => (!n.apps || n.apps.includes(cls)) && n.re.test(text));

function startBackend() {
  return new Promise((resolve, reject) => {
    // --stack-size: a view-builder chain transpiles to ONE nested expression, and
    // the overview app's is long enough to overflow V8's default parser stack
    const srv = spawn('node', ['--stack-size=10000', path.join(A2, 'node/srv/express.mjs')], { env: { ...process.env, PORT: String(PORT) } });
    let out = '';
    const onData = (d) => { out += d; if (/Listening on/.test(out)) { srv.stdout.off('data', onData); resolve(srv); } };
    srv.stdout.on('data', onData);
    srv.stderr.on('data', (d) => { out += d; });
    srv.on('exit', (c) => reject(new Error(`backend exited (${c}) before listening - is port ${PORT} taken?\n${out.slice(-500)}`)));
    setTimeout(() => reject(new Error(`backend did not listen within 60 s:\n${out.slice(-500)}`)), 60000);
  });
}

const FATAL = () => {
  const m = (document.body.innerText || '').match(/(Unexpected Error Occurred[^]{0,400})/);
  return m ? m[1].replace(/\s+/g, ' ').slice(0, 240) : null;
};

/* The visible, enabled buttons of the main view - not in a popup, not the
 * nav-back button, not a control's internal button. */
const BUTTONS = () => {
  const El = sap.ui.require('sap/ui/core/Element');
  const inPopup = (c) => { for (let p = c.getParent(); p; p = p.getParent()) if (/Dialog|Popover|ShellBar/.test(p.getMetadata().getName())) return true; return false; };
  return Object.values(El.registry.all())
    .filter((c) => !c.bIsDestroyed && /^sap\.m\.(Button|ToggleButton)$/.test(c.getMetadata().getName())
      && c.getDomRef() && document.body.contains(c.getDomRef()) && c.getDomRef().offsetParent !== null
      && c.getEnabled() && c.getVisible() && !inPopup(c)
      && !/navButton|-internalBtn|-overflowButton|-collapseBtn|-expandBtn/.test(c.getId()))
    .map((c) => ({ id: c.getId(), label: c.getText() || c.getTooltip_AsString() || c.getIcon() || c.getId() }));
};

/* The fill step: the first editable Input/TextArea of the main view, and the
 * first selectable row of the first table or list - as DOM ids to drive with
 * real gestures. A row is "selectable" when the control has a selection mode
 * or the item is pressable. */
const FILL_TARGETS = () => {
  const El = sap.ui.require('sap/ui/core/Element');
  const live = (c) => !c.bIsDestroyed && c.getDomRef() && document.body.contains(c.getDomRef()) && c.getDomRef().offsetParent !== null;
  const inPopup = (c) => { for (let p = c.getParent(); p; p = p.getParent()) if (/Dialog|Popover/.test(p.getMetadata().getName())) return true; return false; };
  const all = Object.values(El.registry.all()).filter((c) => live(c) && !inPopup(c));
  const name = (c) => c.getMetadata().getName();
  const input = all.find((c) => /^sap\.m\.(Input|TextArea)$/.test(name(c)) && c.getEnabled() && c.getEditable() && c.getVisible());
  let row = null;
  for (const t of all) {
    if (t.isA('sap.m.ListBase') && !/Select|Combo|Suggestion/.test(t.getParent()?.getMetadata().getName() || '')) {
      const item = t.getItems().find(live);
      if (!item) continue;
      const mode = t.getMode();
      const ctl = item.getModeControl && item.getModeControl();
      if (/^(SingleSelect|SingleSelectLeft|MultiSelect)$/.test(mode) && ctl && ctl.getDomRef()) row = { id: ctl.getDomRef().id, how: 'click' };
      else if (mode === 'SingleSelectMaster' || /Active|Navigation/.test(item.getType())) row = { id: item.getDomRef().id, how: 'click' };
    } else if (t.isA('sap.ui.table.Table') && t.getSelectionMode() !== 'None') {
      const sel = document.getElementById(`${t.getId()}-rowsel0`) || document.getElementById(`${t.getId()}-rows-row0-col0`);
      if (sel) row = { id: sel.id, how: 'mouse' };
    }
    if (row) break;
  }
  return {
    input: input ? { id: (input.getFocusDomRef() || input.getDomRef()).id, numeric: input.getType && input.getType() === 'Number' } : null,
    row,
  };
};

async function settle(page) {
  await page.waitForTimeout(250);
  await waitForIdle(page, { quiet: 400, timeout: 20000 });
}

async function checkApp(browser, cls) {
  const errs = [];
  let phase = 'boot';
  const ctx = await browser.newContext({ viewport: { width: 1280, height: 900 }, locale: 'en-US' });
  const page = await ctx.newPage();
  // A press that sends the whole page to another origin (URLHELPER REDIRECT,
  // a link) ends the app on purpose. From the moment that navigation starts,
  // what the page reports is the departing or the foreign document, not the
  // app - in CI's headless shell the old page throws "sap is not defined" on
  // the way out (app 316). The press loop stops there too.
  let left = false;
  page.on('request', (r) => {
    // http(s) only: a mailto:, tel: or sms: link hands off to the device and
    // the page stays where it is
    const u = new URL(r.url());
    if (r.isNavigationRequest() && r.frame() === page.mainFrame() && /^https?:$/.test(u.protocol) && u.origin !== ORIGIN) left = true;
  });
  page.on('pageerror', (e) => { if (!left && !noise(cls, e.message)) errs.push(`[${phase}] pageerror: ${e.message.slice(0, 200)}`); });
  page.on('console', (m) => {
    if (!left && m.type() === 'error' && !noise(cls, m.text())) errs.push(`[${phase}] console: ${m.text().replace(/\s+/g, ' ').slice(0, 240)}`);
  });
  // the body is read asynchronously - awaited before the context closes, so a
  // failure on the last step is not lost
  const pending = [];
  page.on('response', (r) => {
    const u = new URL(r.url());
    if (u.origin !== ORIGIN || r.status() < 400) return;
    const ph = phase;
    pending.push(r.text().then((b) => errs.push(`[${ph}] backend HTTP ${r.status()}: ${b.replace(/<[^>]+>/g, ' ').replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ').trim().slice(0, 300)}`))
      .catch(() => errs.push(`[${ph}] backend HTTP ${r.status()}`)));
  });
  // the GET page's CSP gets what a source-only UI5 needs (lib/e2e.mjs says why)
  await page.route((url) => url.origin === ORIGIN, async (route) => {
    if (route.request().resourceType() !== 'document') return route.fallback();
    let response;
    try { response = await route.fetch({ timeout: 120000 }); } catch { return route.abort().catch(() => {}); }
    if (!(response.headers()['content-type'] || '').includes('text/html')) return route.fulfill({ response });
    return route.fulfill({ response, body: allowEvalForSourceUi5(await response.text()) });
  });
  // UI5 from the local packages; anything else external (images, fonts) is answered empty
  await page.route((url) => url.origin !== ORIGIN, (route) => {
    const u = new URL(route.request().url());
    const hit = /openui5/.test(u.hostname) ? resolveLocal(u.pathname) : null;
    return hit ? route.fulfill({ status: 200, contentType: hit.type, body: hit.body }) : route.fulfill({ status: 404, body: '' });
  });

  const fatal = async () => {
    const f = await page.evaluate(FATAL).catch(() => null);
    if (f) errs.push(`[${phase}] fatal overlay: ${f}`);
    return !!f;
  };
  const closePopups = async () => {
    for (let i = 0; i < 2; i++) await page.keyboard.press('Escape').catch(() => {});
    await page.waitForTimeout(200);
  };
  const res = { cls, pressed: [], filled: [] };
  try {
    await page.goto(`${ORIGIN}/?app_start=${cls}`, { waitUntil: 'domcontentloaded', timeout: 30000 });
    await page.waitForFunction(() => window.sap && window.sap.ui && document.querySelectorAll('[data-sap-ui]').length > 3, undefined, { timeout: 90000 });
    await settle(page).catch(() => {});
    await page.waitForTimeout(400);
    if (await fatal()) throw new Error('stop');
    const chars = await page.evaluate(() => (document.body.innerText || '').trim().length);
    if (chars < 20) errs.push(`[boot] near-empty page (${chars} characters of text)`);

    if (FLOWS[cls]) {
      phase = 'flow';
      await FLOWS[cls](page, helpers(page, closePopups));
      await fatal();
    } else {
      if (FILL) {
        const t = await page.evaluate(FILL_TARGETS);
        if (t.input) {
          phase = 'fill input';
          const loc = page.locator(`[id="${t.input.id}"]`);
          await loc.click({ timeout: 4000 }).catch(() => loc.focus());
          await page.keyboard.press('ControlOrMeta+a');
          await page.keyboard.type(t.input.numeric ? '42' : 'e2e');
          await page.keyboard.press('Enter');
          res.filled.push('input');
          await settle(page).catch((e) => errs.push(`[${phase}] ${e.message}`));
          await closePopups();
          if (await fatal()) throw new Error('stop');
        }
        if (t.row) {
          phase = 'select row';
          const loc = page.locator(`[id="${t.row.id}"]`);
          if (t.row.how === 'click') await loc.click({ timeout: 4000 }).catch(() => loc.dispatchEvent('click'));
          else for (const type of ['mousedown', 'mouseup', 'click']) await loc.dispatchEvent(type, { button: 0 });
          res.filled.push('row');
          await settle(page).catch((e) => errs.push(`[${phase}] ${e.message}`));
          await closePopups();
          if (await fatal()) throw new Error('stop');
        }
      }
      const buttons = MAX_PRESS ? await page.evaluate(BUTTONS) : [];
      for (const b of buttons.slice(0, MAX_PRESS)) {
        phase = `press "${b.label}"`;
        const loc = page.locator(`[id="${b.id}"]`);
        if (!(await loc.count())) continue;
        try { await loc.click({ timeout: 4000 }); } catch { try { await loc.dispatchEvent('click'); } catch { continue; } }
        res.pressed.push(b.label);
        await settle(page).catch((e) => { if (!left) errs.push(`[${phase}] ${e.message}`); });
        if (left || !page.url().startsWith(ORIGIN)) { res.left = b.label; break; }
        if (await fatal()) break;
        await closePopups();
      }
    }
  } catch (e) {
    if (e.message !== 'stop') errs.push(`[${phase}] ${String(e.message).split('\n')[0].slice(0, 200)}`);
  }
  await Promise.allSettled(pending);
  await ctx.close().catch(() => {});
  res.errs = errs;
  return res;
}

/* What a flow module gets besides the page. Each throws with a sentence
 * that names what did not happen. */
function helpers(page, closePopups) {
  const settleOrThrow = (what) => settle(page).catch(() => { throw new Error(`${what}: the app never went quiet`); });
  return {
    waitForIdle: (o) => waitForIdle(page, o),
    closePopups,
    async press(text) {
      const exact = new RegExp(`^\\s*${text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`);
      const b = page.locator('button:visible').filter({ hasText: exact }).first();
      await b.click({ timeout: 8000 }).catch(() => { throw new Error(`no visible button "${text}"`); });
      await settleOrThrow(`after pressing "${text}"`);
    },
    async pressItem(text) {
      await page.getByText(text, { exact: true }).first().click({ timeout: 8000 }).catch(() => { throw new Error(`no item "${text}"`); });
      await settleOrThrow(`after selecting "${text}"`);
    },
    async expectText(text, what = `the page shows "${text}"`) {
      await page.getByText(text).first().waitFor({ state: 'visible', timeout: 10000 }).catch(() => { throw new Error(`expected: ${what}`); });
    },
  };
}

const LOCAL_CHROMIUM = process.env.PW_CHROMIUM || '/opt/pw-browsers/chromium';
const launch = () => chromium.launch({ headless: true, args: ['--disable-dev-shm-usage'], ...(fs.existsSync(LOCAL_CHROMIUM) ? { executablePath: LOCAL_CHROMIUM } : {}) });

const t0 = Date.now();
console.log(`e2e-smoke: ${classes.length} sample(s), backend on ${ORIGIN}${FILL ? '' : ', --no-fill'}, up to ${MAX_PRESS} press(es) each`);
const backend = await startBackend();
// a run that dies half-way must not leave its backend listening: the next run
// would talk to the OLD build and look healthy
process.on('exit', () => backend.kill());
for (const sig of ['SIGINT', 'SIGTERM']) process.on(sig, () => process.exit(130));
let browser = await launch();
let failed = 0;
let tolerated = 0;
for (const cls of classes) {
  const no = cls.replace('z2ui5_cl_smp_app_', '');
  const exp = APPS[cls] || {};
  if (exp.skip) { console.log(`skip  ${no}  ${exp.skip.split(' - ')[0]}`); continue; }
  let r;
  try { r = await checkApp(browser, cls); } catch (e) {
    // a dead browser fails the app, not the run
    await browser.close().catch(() => {});
    browser = await launch();
    r = { cls, pressed: [], filled: [], errs: [`the browser died: ${String(e.message).slice(0, 120)}`] };
  }
  const unexpected = exp.expect ? r.errs.filter((e) => !exp.expect.test(e)) : r.errs;
  const extra = `${FLOWS[cls] ? '  (+flow)' : `  pressed ${r.pressed.length}`}${r.filled.length ? ` filled ${r.filled.join('+')}` : ''}${r.left ? ` (left the app on "${r.left}")` : ''}`;
  if (unexpected.length) { failed++; console.log(`FAIL  ${no}${extra}\n      ${unexpected.join('\n      ')}`); }
  else if (r.errs.length) { tolerated++; console.log(`pass  ${no}${extra}  (expected failure: ${exp.why})`); }
  else console.log(`pass  ${no}${extra}`);
}
await browser.close();
backend.kill();
console.log(`\ne2e-smoke: ${classes.length} sample(s), ${failed} failing, ${tolerated} failing as expected, ${Math.round((Date.now() - t0) / 1000)} s`);
process.exit(failed ? 1 : 0);
