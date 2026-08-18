#!/usr/bin/env node
/*
 * check-docs-links — the `" @docs` lines point at documentation that exists.
 *
 * 96 classes here carry a `" @docs` line with a live URL into
 * https://abap2ui5.github.io/docs/ (AGENTS.md section 4). It is a full URL on
 * purpose: a search engine drops somebody into a class file, and the code was
 * all they got. This repository is the only one of the three that has these
 * lines, and until now nothing checked a single one of them.
 *
 * What that costs when a page is renamed or moved: nothing fails. The class
 * still compiles, SAMPLES.md still renders the link, and the link 404s — for
 * every reader, on the one page whose whole job is to be the way back to the
 * explanation. The scan refuses a URL that is not on the documentation site
 * (scripts/lib/scan-samples.mjs), which catches a typo in the HOST and nothing
 * about the PATH.
 *
 * THE OTHER DIRECTION ALREADY EXISTS. abap2UI5/docs declares the pairing on
 * the documentation side — a cookbook page lists its samples in `samples:`
 * frontmatter — and `scripts/link-samples.mjs` there generates the block of
 * sample links and fails when a class it links to does not point back. So the
 * pairing is checked from over there and was checked from nowhere here, which
 * means a pull request in THIS repository could add a broken link and stay
 * green. This is the missing half.
 *
 * Two things are verified per URL:
 *
 *   the page exists   docs/<path>.md is a file in abap2UI5/docs (and the
 *                     `#anchor`, when there is one, is a heading in it)
 *   the page agrees   its `samples:` frontmatter names this class — the
 *                     pairing docs/link-samples.mjs generates its block from.
 *                     A line no page declares is a link the documentation will
 *                     never render back, and it turns that repository's check
 *                     red rather than this one's.
 *
 * HOW IT REACHES THE DOCUMENTATION, in the order it tries and the degradation
 * scripts/check-app-rules.mjs established:
 *
 *   1. an abap2UI5/docs checkout NEXT TO this one (or $DOCS_HOME, or .docs
 *      inside the workspace, which is where a CI checkout lands) — no network
 *      at all, so a developer with the ecosystem cloned is checked offline and
 *      in a second;
 *   2. otherwise raw.githubusercontent.com, one request per distinct page;
 *   3. otherwise it SAYS SO and passes. A repository's gates must not go red
 *      because github.com is unreachable, and must not claim to have verified
 *      what they did not.
 *
 *   node scripts/check-docs-links.mjs      (npm run check:docs-links)
 */
import fs from 'fs';
import path from 'path';
import { ROOT, DOCS_SITE, scanSamples } from './lib/scan-samples.mjs';

const RAW = 'https://raw.githubusercontent.com/abap2UI5/docs/main/docs';

/* The documentation checkout, under any of the names the repository is cloned
 * as. `.docs` first because that is where a workflow checkout lands: a runner
 * cannot check a repository out ABOVE the workspace. */
function resolveDocs() {
  const candidates = [
    process.env.DOCS_HOME,
    path.join(ROOT, '.docs'),
    path.join(ROOT, '..', 'docs'),
    path.join(ROOT, '..', 'abap2UI5-docs'),
  ].filter(Boolean);
  for (const dir of candidates) {
    if (fs.existsSync(path.join(dir, 'docs', 'index.md'))) return dir;
  }
  return null;
}

/** The `samples:` key of a page's frontmatter — block list or inline array.
 *  No YAML parser: this is the only key anything here reads, and it is read
 *  exactly the way abap2UI5/docs' link-samples.mjs writes it. */
function declaredSamples(text) {
  const fm = /^---\r?\n([\s\S]*?)\r?\n---/.exec(text);
  if (!fm) return [];
  const inline = /^samples:\s*\[(.*)\]\s*$/m.exec(fm[1]);
  if (inline) {
    return inline[1].split(',').map((s) => s.trim().replace(/^["']|["']$/g, '')).filter(Boolean);
  }
  const block = /^samples:\s*\r?\n((?:\s*-\s*.+\r?\n?)+)/m.exec(fm[1]);
  if (!block) return [];
  return block[1]
    .split(/\r?\n/)
    .map((l) => /^\s*-\s*(.+?)\s*$/.exec(l))
    .filter(Boolean)
    .map((m) => m[1].replace(/^["']|["']$/g, ''));
}

/** VitePress' heading anchors: lower case, non-word characters dropped,
 *  spaces to hyphens — the same shape GitHub uses. */
const anchors = (text) => new Set(
  [...text.matchAll(/^#{1,6}\s+(.+?)\s*$/gm)].map(([, title]) =>
    title
      .replace(/`/g, '')
      .toLowerCase()
      .replace(/[^\w\- ]/g, '')
      .replace(/ /g, '-')),
);

/* ------------------------------------------------------------------ input */

const { areas, hidden } = scanSamples();
const withDocs = [...Object.values(areas).flat(), ...hidden].filter((t) => t.docs.length);

/* page path (no suffix, no anchor) -> [ { cls, url, anchor } ] */
const pages = new Map();
for (const tile of withDocs) {
  for (const url of tile.docs) {
    const [page, anchor] = url.slice(DOCS_SITE.length).split('#');
    if (!pages.has(page)) pages.set(page, []);
    pages.get(page).push({ cls: tile.app, url, anchor });
  }
}

const home = resolveDocs();
/** The page's markdown, or null when it is not there. */
let read;
let from;
if (home) {
  from = `the abap2UI5/docs checkout at ${path.relative(ROOT, home) || home}`;
  read = async (page) => {
    const file = path.join(home, 'docs', `${page}.md`);
    return fs.existsSync(file) ? fs.readFileSync(file, 'utf8') : null;
  };
} else {
  from = 'abap2UI5/docs@main over raw.githubusercontent.com';
  read = async (page) => {
    const res = await fetch(`${RAW}/${page}.md`, { signal: AbortSignal.timeout(15000) });
    if (res.status === 404) return null;
    if (!res.ok) throw new Error(`HTTP ${res.status} for ${page}.md`);
    return res.text();
  };
}

/* ------------------------------------------------------------------ check */

const problems = [];
let checked = 0;

try {
  for (const [page, uses] of [...pages].sort()) {
    const text = await read(page);
    if (text === null) {
      const classes = [...new Set(uses.map((u) => u.cls))].sort().join(', ');
      problems.push(
        `${DOCS_SITE}${page} does not exist — linked from ${classes}\n`
        + '    the page was renamed, moved or deleted; fix the `" @docs` line or the page',
      );
      continue;
    }
    checked += 1;

    const heads = anchors(text);
    const declared = new Set(declaredSamples(text).map((s) => s.toLowerCase()));
    for (const use of uses) {
      if (use.anchor && !heads.has(use.anchor)) {
        problems.push(`${use.url} — no heading with that anchor on the page (${use.cls})`);
      }
      if (!declared.has(use.cls.toLowerCase())) {
        problems.push(
          `${use.cls} points at ${DOCS_SITE}${page}, and that page does not name it back\n`
          + `    add ${use.cls} to the page's \`samples:\` frontmatter in abap2UI5/docs,\n`
          + '    or drop the `" @docs` line — the pairing is declared there and generated here',
        );
      }
    }
  }
} catch (err) {
  console.log(`check-docs-links: documentation not reachable (${err.message}) — nothing verified, not a failure`);
  process.exit(0);
}

console.log(
  `check-docs-links: ${withDocs.length} class(es) link to ${pages.size} page(s), `
  + `read from ${from}`,
);

if (problems.length) {
  console.error(`\n${problems.length} problem(s):`);
  for (const p of problems) console.error(`  ${p}`);
  console.error(
    '\n  A `" @docs` line is the way back to the explanation, and it is a full URL'
    + '\n  because a search engine drops people straight into the class. A stale one'
    + '\n  404s for every one of them, and nothing else here notices.',
  );
  process.exit(1);
}
console.log(`every @docs link resolves and points at a page that names it back - OK (${checked} page(s))`);
