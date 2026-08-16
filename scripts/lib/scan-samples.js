#!/usr/bin/env node
/*
 * The one scan of the sample tree.
 *
 * Two things are generated from the same facts - the overview app's
 * get_catalog( ) (scripts/generate-launchpad.js) and the browsable catalogue
 * SAMPLES.md (scripts/generate-samples-md.js) - and the facts are not
 * obvious: which classes count as samples, where their title and description
 * come from, which ones are hidden helpers, and what a demo kit rebuild
 * overrides. A second copy of that would drift, and drift here is silent: the
 * app and the markdown would simply disagree about what this repository
 * contains, and nothing would fail.
 *
 * So the scan lives here and the two generators only RENDER. Rendering
 * decisions stay with them - the controls-section truncation is about the
 * overview never wrapping on a phone, which is not a fact about a sample.
 *
 * The rules are AGENTS.md section 4. Edit them here, not in a generator.
 */
'use strict';

const fs = require('fs');
const path = require('path');

const ROOT = path.join(__dirname, '..', '..');
const SRC = path.join(ROOT, 'src');

// The areas (top-level packages under src) that hold samples at all. src/00/01
// is the shared helper classes - not apps, and they carry no sample prefix, so
// nothing there is picked up anyway.
const AREAS = ['00', '01'];

// The overview app lives in the src/ root package and shares the sample-app
// class-name prefix. Skip it so an overview never lists itself as a tile.
const OVERVIEW_APPS = new Set(['z2ui5_cl_smp_app_000']);

// smp is the token this repository owns (AGENTS.md section 6) - the legacy
// demo token is fully migrated. A class that does not carry it is not a sample.
const SAMPLE_PREFIX = 'z2ui5_cl_smp_app';

// Where a `" @docs` line has to point. Anything else is a typo or a link to
// somewhere that is not the documentation, and both are worth refusing rather
// than rendering.
const DOCS_SITE = 'https://abap2ui5.github.io/docs/';

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

/**
 * The category a header belongs to: the header without a trailing Roman
 * numeral. `Basics I` .. `Basics IV` are one learning path, not four topics.
 *
 * This is the ABAP `header_base( )` of the overview app, in JavaScript - the
 * two must agree, or the app and SAMPLES.md group the same samples
 * differently.
 */
function headerBase(header) {
  const words = header.split(' ');
  const last = words[words.length - 1];
  if (words.length > 1 && last && /^[IVXLCDM]+$/.test(last)) {
    return words.slice(0, -1).join(' ');
  }
  return header;
}

const ctextCache = {};
function groupOf(dir) {
  if (!(dir in ctextCache)) {
    const p = path.join(dir, 'package.devc.xml');
    ctextCache[dir] = fs.existsSync(p) ? tag(fs.readFileSync(p, 'utf8'), 'CTEXT') : '';
  }
  return ctextCache[dir];
}

/**
 * Every sample class in the tree, grouped by area and sorted the way
 * AGENTS.md section 4 rule 5 orders them.
 *
 * Hidden helper apps (DESCRIPT header `ZZZ`) are returned too, flagged rather
 * than dropped: the overview must not list them, and a catalogue that claims
 * to account for the tree has to be able to say they exist.
 *
 * @returns {{areas: Record<string, object[]>, hidden: object[]}}
 */
function scanSamples() {
  const areas = Object.fromEntries(AREAS.map((a) => [a, []]));
  const hidden = [];

  for (const abap of walk(SRC)) {
    if (!abap.endsWith('.clas.abap')) continue;
    const cls = path.basename(abap, '.clas.abap');
    if (OVERVIEW_APPS.has(cls)) continue; // an overview app is never a tile
    if (!cls.startsWith(SAMPLE_PREFIX)) continue;

    const rel = path.relative(SRC, abap).split(path.sep); // [ area, ...subfolders, file ]
    if (rel.length < 2) continue; // a class directly in src/ root is never a tile
    const area = rel[0];
    // full subfolder path ("03" or nested "03/01") so nested subpackages form
    // their own group directly after their parent slot
    const subnum = rel.slice(1, -1).join('/');
    if (!(area in areas)) continue;

    const xmlPath = abap.replace(/\.clas\.abap$/, '.clas.xml');
    if (!fs.existsSync(xmlPath)) { console.warn(`skipping ${cls}: no .clas.xml`); continue; }
    const xml = fs.readFileSync(xmlPath, 'utf8');
    const { header, sub } = splitDescript(tag(xml, 'DESCRIPT') || cls);

    const source = fs.readFileSync(abap, 'utf8');

    // extra search terms, taken from the class's " @keywords line - they widen
    // the overview's search without lengthening anything that is rendered
    // (AGENTS.md section 4). Plain comment, not ABAP Doc: an unknown "! @tag
    // is reported by the extended check.
    const keywords = (source.match(/^" @keywords (.+?)\r?$/m) || [, ''])[1].trim();

    // one sentence about what the sample SHOWS, from the class's " @summary
    // line. `@keywords` answers "which words find this sample"; this answers
    // the next question, "is this the one I want", which nothing here could:
    // the 60-character DESCRIPT carries the name of the thing and no more.
    // Unlike the two sibling repositories' summaries it is written rather than
    // fetched or derived - these apps have no upstream original to quote.
    const summary = (source.match(/^" @summary (.+?)\r?$/m) || [, ''])[1].trim();

    // the chapter of abap2UI5/docs that explains what this sample demonstrates,
    // as full URLs so the line is useful to somebody reading the class itself -
    // which is the point: a search engine drops people into a class, and until
    // now the code was all they got. The documentation declares the same pair
    // from its side (docs/scripts/link-samples.mjs) and its check fails when the
    // two disagree, so neither direction can rot on its own.
    const docs = (source.match(/^" @docs (.+?)\r?$/m) || [, ''])[1].trim().split(/\s+/).filter(Boolean);
    for (const url of docs) {
      if (!url.startsWith(DOCS_SITE)) {
        throw new Error(`@docs of ${cls} is not a documentation URL: ${url} (expected ${DOCS_SITE}...)`);
      }
    }

    // demo kit rebuilds (AGENTS.md section 1) carry the full, untruncated demo
    // kit description as ABAP Doc lines below the URL line - prefer it as sub
    // over the 60-char DESCRIPT. The Rebuild line may be preceded by marker
    // lines (e.g. the generated-port marker), hence the multiline match.
    const doc = source
      .match(/^"! Rebuild of the UI5 demo kit sample: \S+\r?\n((?:"! .*\r?\n)+)/m);
    const fullSub = doc
      ? doc[1].split(/\r?\n/).map((l) => l.replace(/^"! ?/, '').trim()).filter(Boolean).join(' ')
      : sub;

    // A backtick ends an ABAP string template and a markdown code span; both
    // generators would emit something broken, so it is refused at the source.
    if ((header + fullSub).includes('`')) throw new Error(`backtick in DESCRIPT of ${cls}`);
    if (keywords.includes('`')) throw new Error(`backtick in @keywords of ${cls}`);
    if (summary.includes('`')) throw new Error(`backtick in @summary of ${cls}`);

    const entry = {
      area,
      subnum,
      group: groupOf(path.dirname(abap)),
      header,
      base: headerBase(header),
      sub: fullSub,
      keywords,
      summary,
      docs,
      // repository-relative folder of the class, so a link to the source can
      // be built - the class name does not encode the folder
      // (FOLDER_LOGIC=PREFIX), so only the scan knows where a sample lives
      path: ['src', area, ...rel.slice(1, -1)].join('/'),
      app: cls,
    };

    if (header.trim().toUpperCase() === 'ZZZ') hidden.push(entry);
    else areas[area].push(entry);
  }

  const ci = (x) => x.toLowerCase();
  const order = (a, b) =>
    a.subnum.localeCompare(b.subnum) ||         // groups in folder-number order
    ci(a.header).localeCompare(ci(b.header)) || // then by header (keeps I/II/III together)
    ci(a.sub).localeCompare(ci(b.sub)) ||
    ci(a.app).localeCompare(ci(b.app));
  for (const list of Object.values(areas)) list.sort(order);
  hidden.sort(order);

  /* Two samples with the same short text are two catalogue entries the reader
   * cannot tell apart - and the short text is the only thing either catalogue
   * has to offer about a sample. src/00/98 carried four such pairs (two
   * `Deep Structure Sub App`, two `App in App - Subapp`, two
   * `RTTI - with many Layouts`, two `RTTI - Table with Class Data and Popup`)
   * plus a `Deep Structure Sub App` on the app that EMBEDS the sub app. Nobody
   * had a reason to notice while the classes were listed nowhere; SAMPLES.md
   * lists them, so this is refused at the source. */
  const seenText = new Map();
  for (const entry of [...Object.values(areas).flat(), ...hidden]) {
    const key = `${entry.header} - ${entry.sub}`.toLowerCase();
    const first = seenText.get(key);
    if (first) {
      throw new Error(
        `${entry.app} and ${first} carry the same short text ("${key}") - `
        + 'a catalogue entry has to say which sample it is',
      );
    }
    seenText.set(key, entry.app);
  }

  return { areas, hidden };
}

module.exports = { ROOT, SRC, AREAS, DOCS_SITE, scanSamples, headerBase };
