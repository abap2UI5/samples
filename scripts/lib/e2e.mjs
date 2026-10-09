/*
 * e2e — what the browser smoke (scripts/e2e-*.mjs) shares, and nothing else.
 *
 * Copied, not imported, from abap2UI5/samples-controls (scripts/lib-a2ui5.mjs,
 * lib-smoke.mjs, lib-e2e.mjs and web/ci/patch_follow_up_action.mjs), which
 * runs the same harness over its 600 ports and wrote down why each piece is
 * there. This repository must stay installable and checkable on its own, so a
 * fix to one of these belongs in both places - samples-controls' copy carries
 * the longer history.
 */
import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
import { fileURLToPath } from 'url';

export const ROOT = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
export const IN_REPO_A2UI5 = path.join(ROOT, '.abap2UI5');

/** The abap2UI5 checkout: A2UI5_HOME, else the in-repo clone `npm run e2e:setup` writes. */
export function resolveA2UI5() {
  for (const c of [process.env.A2UI5_HOME, IN_REPO_A2UI5]) {
    if (c && fs.existsSync(path.join(c, 'node/srv/express.mjs'))) return path.resolve(c);
  }
  return null;
}

/** The framework commit the harness builds against (A2UI5_PIN), or null. */
export function readPin() {
  try {
    const sha = fs.readFileSync(path.join(ROOT, 'A2UI5_PIN'), 'utf8').trim();
    return /^[0-9a-f]{40}$/.test(sha) ? sha : null;
  } catch {
    return null;
  }
}

/* Rewrite the VIEW-WIRED `v = client->follow_up_action( … )` to
 * `_event_client( )` in the build COPY. The framework tells the two roles of
 * follow_up_action( ) apart with `IF result IS SUPPLIED`, which the transpiler
 * does not model for a RETURNING parameter - so every handler written into a
 * view attribute came out empty and the control had no handler at all.
 * `_event_client( )` is the same wire with no second role. The committed
 * samples are correct ABAP and are never touched. Delete this once the
 * transpiler passes the returning slot (abap2UI5 backlog
 * transpiler-returning-is-supplied). */
export function patchFollowUpAction(root) {
  const WIRED = /(=[ \t]*)client->follow_up_action\(/g;
  const CONTINUED = /^([ \t]*)client->follow_up_action\(/;
  let calls = 0;
  for (const f of fs.readdirSync(root, { recursive: true })) {
    if (!String(f).endsWith('.abap')) continue;
    const file = path.join(root, String(f));
    const src = fs.readFileSync(file, 'utf8');
    let concatOpen = false;
    const out = src.split('\n').map((line) => {
      const trimmed = line.trimStart();
      if (trimmed.startsWith('"') || trimmed.startsWith('*')) return line;
      let patched = line.replace(WIRED, (_m, lhs) => { calls++; return `${lhs}client->_event_client(`; });
      if (concatOpen) patched = patched.replace(CONTINUED, (_m, indent) => { calls++; return `${indent}client->_event_client(`; });
      concatOpen = patched.trimEnd().endsWith('&&');
      return patched;
    }).join('\n');
    if (out !== src) fs.writeFileSync(file, out);
  }
  return calls;
}

/* Page errors that are the environment, not a sample: the harness serves UI5
 * from the @openui5 npm SOURCES - no preload bundles, no themes, no i18n. */
const BENIGN = [
  /library-preload/i, /messagebundle/i, /i18n/i, /themes?\/|library(\.css|-parameters)/i,
  /theming\.Parameters|\.properties/i, /failed to load (javascript )?resource/i,
  /Core\.applyTheme|sap\.ui\.getCore/i, /favicon/i, /deprecat/i, /sap-ui-cachebuster/i,
  /ERR_TUNNEL_CONNECTION_FAILED/i,
];
export const benign = (s) => BENIGN.some((re) => re.test(s));

/* The GET page's CSP, relaxed for a SOURCE-ONLY UI5 and only here: the
 * ui5loader evals the modules it fetches synchronously ('unsafe-eval'), and
 * the source tree's sap-ui-core.js is the DEV bootstrap, which
 * document.write()s two inline scripts (allowed by hash). A real system loads
 * the CDN build and needs neither - abap2UI5's own offline e2e fixture does
 * the same. A hash next to 'unsafe-inline' would disable it, so the hashes
 * are added only when inline script is not already open. */
const DEV_BOOTSTRAP_HASHES = [
  'sap.ui.requireSync("sap/ui/core/Core");',
  'sap.ui.getCore().boot && sap.ui.getCore().boot();',
].map((s) => `'sha256-${crypto.createHash('sha256').update(s, 'utf8').digest('base64')}'`);

export function allowEvalForSourceUi5(html) {
  return html.replace(/(script-src\s)([^;"]*)/, (m, head, rest) => {
    const inlineOpen = /'unsafe-inline'/.test(rest) && !/'(?:sha(?:256|384|512)-|nonce-)/.test(rest);
    const add = ["'unsafe-eval'", ...(inlineOpen ? [] : DEV_BOOTSTRAP_HASHES)].filter((t) => !rest.includes(t));
    return add.length ? `${head}${add.join(' ')} ${rest}` : m;
  });
}

/* The frontend state lives on the component (component.ctx.state); the
 * fallback keeps an older pin working. */
const FRONTEND_STATE = `((() => {
  const C = sap.ui.require('sap/ui/core/Component');
  const own = C && C.registry ? C.registry.filter((c) => c.ctx && c.ctx.state)[0] : null;
  if (own) return own.ctx.state;
  const legacy = sap.ui.require('z2ui5/core/AppState');
  return (legacy && legacy.state) || null;
})())`;

/* Wait until the app answers no roundtrip of its own, for `quiet` ms in a row.
 * The frontend DROPS an event fired while a roundtrip is in flight, silently,
 * so a press that lands on a busy app reads exactly like a dead wire. The
 * quiet is measured from this call - a timestamp left over from the previous
 * call would make every later call return at once. */
export async function waitForIdle(page, { quiet = 400, timeout = 30000 } = {}) {
  await page.evaluate(() => { window.__a2ui5IdleSince = 0; });
  const expr = `(() => {
    const s = ${FRONTEND_STATE};
    if (!s) return true;
    window.__a2ui5IdleSince = s.isBusy === true ? 0 : (window.__a2ui5IdleSince || Date.now());
    return window.__a2ui5IdleSince > 0 && Date.now() - window.__a2ui5IdleSince >= ${quiet};
  })()`;
  await page.waitForFunction(expr, undefined, { timeout }).catch(() => {
    throw new Error(`the app never went quiet for ${quiet}ms`);
  });
}
