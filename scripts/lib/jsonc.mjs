/* JSONC: strip comments, keeping anything inside a string. A naive strip eats
 * the `//` of the dependency URLs the abaplint configs carry. Trailing commas
 * go too.
 *
 * Every abaplint config this repository reads from abap2UI5 is a `.jsonc`, and
 * a comment can land in any of them at any time: abap2UI5#2950 (2026-10-26)
 * put one into `.github/abaplint/abap_702.jsonc`, and `e2e-build.mjs`, which
 * read that file with a bare JSON.parse, died before the downport. Read them
 * through this. */
export function parseJsonc(text) {
  let out = '';
  let inString = false;
  let quote = '';
  for (let i = 0; i < text.length; i += 1) {
    const c = text[i];
    const next = text[i + 1];
    if (inString) {
      out += c;
      if (c === '\\') { out += next; i += 1; continue; }
      if (c === quote) inString = false;
      continue;
    }
    if (c === '"' || c === "'") { inString = true; quote = c; out += c; continue; }
    if (c === '/' && next === '/') { while (i < text.length && text[i] !== '\n') i += 1; out += '\n'; continue; }
    if (c === '/' && next === '*') { i += 2; while (i < text.length && !(text[i] === '*' && text[i + 1] === '/')) i += 1; i += 1; continue; }
    out += c;
  }
  return JSON.parse(out.replace(/,(\s*[}\]])/g, '$1'));
}
