/*
 * catalog-block — the get_catalog( ) method of the overview app, rendered.
 *
 * generate-launchpad.mjs decides WHAT the catalogue holds (the scan, the
 * learning-path groups, the gates on missing search lines); this module only
 * turns that list into ABAP and splices it into the class. Split out so the
 * splice can be tested on a string (scripts/test/generators.test.mjs) without
 * running the generator over the tree.
 *
 * Two things here were wrong once and are tested for that reason:
 *
 *   - Every value goes into a backtick literal, and a value can contain a
 *     backtick (a stage blurb in lib/learning-path.json naming `_bind( )`, a
 *     DESCRIPT quoting a method). Unescaped, that ended the literal early and
 *     the class no longer compiled. `abapLiteral( )` doubles it, the escape
 *     ABAP defines, as samples-controls' overview-emit does.
 *   - The block used to end at the first `) ).` after `result = VALUE #(` -
 *     a text search that any tile text holding `) ).` cut short, leaving the
 *     rest of the old block behind as garbage. The end is now structural: the
 *     ENDMETHOD of get_catalog( ), whose body is that one statement.
 */
import { markersLine } from './markers.mjs';

// ABAP sources are limited to 255 characters per line — longer lines break
// the abapGit import ("Literals across more than one line are not allowed")
export const MAX_LINE = 255;

/** A value as the inside of an ABAP backtick literal: a backtick doubled. */
export const abapLiteral = (value) => String(value).replace(/`/g, '``');

/**
 * Split an ESCAPED literal into chunks of at most `size` characters, never
 * between the two backticks of an escaped one - `a`` && ``b` would be two
 * literals, each holding a lone backtick that ends it.
 */
export function chunkLiteral(escaped, size) {
  const chunks = [];
  let rest = escaped;
  while (rest.length) {
    let cut = Math.min(size, rest.length);
    const run = rest.slice(0, cut).match(/`+$/);
    if (run && run[0].length % 2 === 1 && cut < rest.length) cut -= 1;
    chunks.push(rest.slice(0, cut));
    rest = rest.slice(cut);
  }
  return chunks.length ? chunks : [''];
}

/* The class is written WITHOUT its z2ui5_ prefix: the app puts the
 * installation's in front at runtime (own_prefix( )), because the namespace
 * rename (npm run rename) rewrites references and never a literal - a
 * literal z2ui5_cl_smp_app_493 would start the ORIGINAL class in a renamed
 * installation, and scripts/rename.mjs refuses it. */
const unprefixed = (app) => app.replace(/^z2ui5_/i, '');

/**
 * The class source with its catalogue block, @summary and legend rewritten.
 *
 * @param {string} text  the overview class as it is on disk
 * @param {object[]} list  the tiles, in order, with group/intro already set
 * @param {string} [file]  for the error messages
 */
export function rewriteCatalog(text, list, file = 'the overview class') {
  /* The block is the whole body of get_catalog( ): from its METHOD line to its
   * ENDMETHOD. A generated row never starts a line with ENDMETHOD (a row
   * starts with `(` or a continued literal), so the first ENDMETHOD after the
   * METHOD line is the method's. */
  const method = /^( *)METHOD get_catalog\.[ \t]*$/m.exec(text);
  if (!method) throw new Error(`no METHOD get_catalog. in ${file}`);
  const bodyStart = method.index + method[0].length;
  const end = new RegExp(`^${method[1]}ENDMETHOD\\.`, 'm').exec(text.slice(bodyStart));
  if (!end) throw new Error(`no ENDMETHOD for get_catalog( ) in ${file}`);
  const bodyEnd = bodyStart + end.index;
  const body = text.slice(bodyStart, bodyEnd);
  const open = body.indexOf('result = VALUE #(');
  if (open === -1) throw new Error(`no VALUE block in get_catalog( ) of ${file}`);
  if (body.slice(0, open).trim() !== '' || !/\) \)\.\s*$/.test(body)) {
    throw new Error(`get_catalog( ) in ${file} is no longer exactly one result = VALUE #( ... ) ). statement - `
      + 'it is generated, nothing else belongs in that method');
  }

  // indentation of the tiles = indent of "result" line + 2 spaces
  const indent = ' '.repeat((body.slice(0, open).match(/\n( *)$/) || [, ''])[1].length + 2);

  // one field on its own line(s), the literal split into && chunks so no line
  // exceeds the limit; continuation lines align under the opening backtick
  const chunked = (name, value, fieldIndent) => {
    const first = `${fieldIndent}${name} = `;
    const contIndent = ' '.repeat(first.length);
    const chunks = chunkLiteral(abapLiteral(value), MAX_LINE - contIndent.length - 6);
    return chunks.map((c, i) =>
      `${i === 0 ? first : contIndent}\`${c}\`${i < chunks.length - 1 ? ' &&' : ''}`);
  };
  const lit = (value) => `\`${abapLiteral(value)}\``;
  /* Every row names every component, `keywords` and `intro` included when
   * they are empty. A row that leaves one out is initial there on 7.40+, but
   * the abaplint downport builds all rows of a VALUE in one work area that it
   * never clears, so on the 702 branch the left-out `intro` kept the previous
   * tile's - the first tile's blurb repeated under every tile of its group
   * (abap2UI5 backlog: abaplint-downport-value-row-not-cleared). */
  const rows = list.map((t) => {
    const one = `${indent}( group = ${lit(t.group)} header = ${lit(t.header)} sub = ${lit(t.sub)} keywords = ${lit(t.keywords || '')} intro = \`\` path = ${lit(t.path)} app = ${lit(unprefixed(t.app))} )`;
    // the blurb is a paragraph, never on the one-line shape
    if (one.length <= MAX_LINE && !t.intro) return one;
    const fieldIndent = `${indent}  `;
    return [
      `${indent}( group = ${lit(t.group)} header = ${lit(t.header)}`,
      ...chunked('sub', t.sub, fieldIndent),
      ...chunked('keywords', t.keywords || '', fieldIndent),
      ...chunked('intro', t.intro || '', fieldIndent),
      `${fieldIndent}path = ${lit(t.path)} app = ${lit(unprefixed(t.app))} )`,
    ].join('\n');
  });
  // the last row additionally closes the constructor + statement
  rows[rows.length - 1] += ' ).';

  const block = `result = VALUE #(\n${rows.join('\n')}`;
  // what followed the statement (the blank line before ENDMETHOD) stays
  const tail = body.match(/\) \)\.(\s*)$/)[1];
  let next = text.slice(0, bodyStart) + body.slice(0, open) + block + tail + text.slice(bodyEnd);

  /* The app's own @summary line - the sentence SAMPLES.md, catalogue.json and
   * the sample catalogue page put under its title - carries the count of what
   * it lists. Written here, from the list, because a hand-written number on
   * the one class that is generated anyway is the number that goes stale. */
  const summary = `" @summary Every sample in this repository as a searchable list, grouped along the learning path - the app the other ${list.length} are reached from.`;
  if (!/^" @summary .*$/m.test(next)) throw new Error(`no @summary line in ${file}`);
  next = next.replace(/^" @summary .*$/m, summary);

  /* And the legend of the capability markers some titles end in, rendered by
   * the app under its list - one source (lib/markers.mjs) for every view of
   * the catalogue. */
  const legend = `    CONSTANTS c_legend TYPE string VALUE \`Markers on a title: ${abapLiteral(markersLine())}\`.`;
  if (legend.length > MAX_LINE) throw new Error('the marker legend no longer fits one ABAP line - shorten lib/markers.mjs');
  if (!/^ {4}CONSTANTS c_legend TYPE string VALUE `.*`\.$/m.test(next)) {
    throw new Error(`no c_legend constant to write the marker legend into in ${file}`);
  }
  next = next.replace(/^ {4}CONSTANTS c_legend TYPE string VALUE `.*`\.$/m, () => legend);

  return next;
}
