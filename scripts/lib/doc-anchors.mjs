/*
 * doc-anchors — the heading ids VitePress gives a page of abap2UI5/docs, so
 * check-docs-links can tell whether the `#anchor` of a `" @docs` URL exists.
 *
 * It used to be "lower case, drop non-word characters, spaces to hyphens" -
 * GitHub's shape, which is not VitePress'. They disagree exactly where a
 * heading has punctuation in it: "A & B" is `a-b` on the site and was `a--b`
 * here, "a_b" is `a-b` on the site and stayed `a_b` here, and a heading with
 * an explicit `{#id}` was not recognised by its id at all. Each of those
 * either failed a correct link or passed a broken one.
 *
 * What VitePress does (vitepress 1.x, markdown-it-anchor with the slugify of
 * @mdit-vue/shared):
 *   - the id is `{#id}` at the end of the heading when there is one (the
 *     attrs plugin), verbatim;
 *   - otherwise the heading's TEXT - its text and inline-code content, so a
 *     link contributes its label and an HTML tag nothing - through slugify( )
 *     below, ported character for character;
 *   - a slug already taken on the page gets `-1`, `-2`, ... appended.
 * Headings inside fenced code and the frontmatter are not headings.
 */

// @mdit-vue/shared, slugify( ) - keep in step with it
// eslint-disable-next-line no-control-regex
const rControl = /[\u0000-\u001f]/g;
const rSpecial = /[\s~`!@#$%^&*()\-_+=[\]{}|\\;:"'“”‘’<>,.?/]+/g;
const rCombining = /[̀-ͯ]/g;

export const slugify = (str) => str
  .normalize('NFKD')
  .replace(rCombining, '')          // accents
  .replace(rControl, '')            // control characters
  .replace(rSpecial, '-')           // special characters
  .replace(/-{2,}/g, '-')           // continuous separators
  .replace(/^-+|-+$/g, '')          // leading and trailing separators
  .replace(/^(\d)/, '_$1')          // never start with a digit
  .toLowerCase();

/** The text markdown-it-anchor hands to slugify: text and inline code, no
 *  link target, no image, no HTML tag - outside a code span. Inside one,
 *  `<n>` is text and stays. */
const headingText = (title) => {
  const prose = (t) => t
    .replace(/!\[[^\]]*\]\([^)]*\)/g, '')       // an image is not text
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')    // a link is its label
    .replace(/<[^>]+>/g, '');                   // an HTML tag is not text
  let out = '';
  let rest = title;
  for (let m = /(`+)([\s\S]*?[^`])\1(?!`)/.exec(rest); m; m = /(`+)([\s\S]*?[^`])\1(?!`)/.exec(rest)) {
    out += prose(rest.slice(0, m.index)) + m[2];
    rest = rest.slice(m.index + m[0].length);
  }
  return out + prose(rest);
};

/** Every id a heading of `text` (a page's markdown) gets on the site. */
export function anchors(text) {
  const ids = new Set();
  const take = (slug) => {
    let id = slug;
    for (let i = 1; ids.has(id); i++) id = `${slug}-${i}`;
    ids.add(id);
  };
  let fence = null;
  const lines = text.split(/\r?\n/);
  let start = 0;
  if (lines[0] === '---') {
    const end = lines.indexOf('---', 1);
    if (end !== -1) start = end + 1;
  }
  for (const line of lines.slice(start)) {
    const f = /^ {0,3}(`{3,}|~{3,})/.exec(line);
    if (f) {
      if (!fence) fence = f[1];
      else if (f[1][0] === fence[0] && f[1].length >= fence.length && line.trim() === f[1]) fence = null;
      continue;
    }
    if (fence) continue;
    const h = /^ {0,3}#{1,6}[ \t]+(.*?)(?:[ \t]+#+)?[ \t]*$/.exec(line);
    if (!h) continue;
    const attrs = /\s*\{([^{}]*)\}\s*$/.exec(h[1]);
    const id = attrs && /(?:^|\s)#([^\s}]+)/.exec(attrs[1]);
    if (id) {
      ids.add(id[1]);
      continue;
    }
    take(slugify(headingText(attrs ? h[1].slice(0, attrs.index) : h[1])));
  }
  return ids;
}
