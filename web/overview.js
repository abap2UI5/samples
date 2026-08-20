/*
 * The overview page - plain ES2020, no dependencies, no build step.
 *
 * Everything it knows comes from apps.json (scripts/generate-overview-index.mjs),
 * regenerated on every deploy. This file only draws the path, narrows it and
 * remembers what you have read.
 *
 * Two decisions worth knowing before changing anything here:
 *
 *   Search NARROWS the path, it does not replace it with a result list. The
 *   order is the content of this page - a sample means something different
 *   inside "Show many rows" than it does as row 41 of a table - so a query
 *   hides what does not match and leaves the stages that remain standing.
 *
 *   What you have read lives in localStorage and nowhere else. There is no
 *   account here and there should not be one; the cost is that the marks are
 *   per browser, which the rail says out loud rather than pretending otherwise.
 */

const $ = (id) => document.getElementById(id);
const STORE = 'abap2ui5-samples-path-read';

let DATA = null;
let ALL = [];                 // every sample, in path order
let read = new Set();

/* ------------------------------------------------------------------ util */

const esc = (s) => String(s == null ? '' : s)
  .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
  .replace(/"/g, '&quot;');

/** Wrap every query token found in `text`. Escapes first, so the marks stay
 *  the only markup that reaches a card. */
function highlight(text, tokens) {
  const out = esc(text);
  if (!tokens.length) return out;
  const pattern = tokens
    .map((t) => t.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'))
    .sort((a, b) => b.length - a.length)
    .join('|');
  return out.replace(new RegExp(`(${pattern})`, 'gi'), '<mark>$1</mark>');
}

/** The one string a query is matched against. The stage and category names are
 *  in it on purpose: "popup" should find the Popup samples, and so should
 *  "talk to the user". */
const haystack = (s) => [
  s.class, s.title, s.what, s.summary, s.keywords.join(' '),
  s.category, s.stageTitle, s.docs.map((d) => d.chapter).join(' '),
].join(' ').toLowerCase();

/** The playground link: the class first, then the files it needs to run - a
 *  second app it navigates to, a shared data class it reads. The playground
 *  starts whatever is in the first `src`. */
function playUrl(sample) {
  const params = [sample.file, ...sample.deps]
    .map((file) => `src=${encodeURIComponent(DATA.raw + file)}`)
    .join('&');
  return `${DATA.playground}?${params}`;
}

/* ---------------------------------------------------------------- render */

function card(sample) {
  /* The position in the topic, which is the reading order - the same marker
   * the rail puts on a stage, one level down. */
  const step = `<span class="step">${esc(sample.pos)}</span>`;
  const terms = sample.keywords.length
    ? `<p class="terms">${sample.keywords
      .map((k) => `<button type="button" data-term="${esc(k)}">${esc(k)}</button>`).join('')}</p>`
    : '';
  const chapters = sample.docs.length
    ? `<span class="chapters">docs: ${sample.docs
      .map((d) => `<a href="${esc(d.url)}" target="_blank" rel="noopener">${esc(d.chapter)}</a>`)
      .join(', ')}</span>`
    : '';
  const extra = sample.deps.length
    ? ` (with the ${sample.deps.length} class${sample.deps.length === 1 ? '' : 'es'} it calls)`
    : '';

  return `
    <article class="card" id="s-${esc(sample.class)}" data-class="${esc(sample.class)}">
      <button type="button" class="tick" aria-pressed="false" title="mark as read">✓</button>
      <h4>${step}<span class="t"></span></h4>
      ${sample.sub ? '<p class="what"></p>' : ''}
      <p class="says"></p>
      ${terms}
      <div class="actions">
        <a href="${esc(DATA.source + sample.file)}" target="_blank" rel="noopener">Source ↗</a>
        <a href="${esc(playUrl(sample))}" target="_blank" rel="noopener"
           title="Open this class in the browser playground${esc(extra)}">Playground ↗</a>
        <button type="button" class="copy" data-copy="${esc(sample.class.toUpperCase())}"
                title="the class to put behind ?app_start= in your own system">${esc(sample.class.toUpperCase())}</button>
        ${chapters}
      </div>
    </article>`;
}

function drawStages() {
  $('stages').innerHTML = DATA.stages.map((stage, i) => `
    <section class="stage" id="stage-${esc(stage.id)}" data-stage="${esc(stage.id)}">
      <div class="stage-head">
        <div class="n">${i + 1}</div>
        <div>
          <h2>${esc(stage.title)}</h2>
          <p class="blurb">${esc(stage.blurb)}</p>
          <p class="tally"></p>
        </div>
      </div>
      ${stage.categories.map((category) => `
        <div class="category" data-category="${esc(category.name)}">
          <h3>${esc(category.name)} <span>· ${category.samples.length}</span></h3>
          <div class="cards">${category.samples.map(card).join('')}</div>
        </div>`).join('')}
    </section>`).join('');

  $('stagenav').innerHTML = `<ol>${DATA.stages.map((stage, i) => `
    <li><a href="#stage-${esc(stage.id)}" data-stage="${esc(stage.id)}">
      <span class="n">${i + 1}</span>
      <span>${esc(stage.title)}<span class="small" data-count="${esc(stage.id)}"></span></span>
    </a></li>`).join('')}</ol>`;
}

/** The text of every visible card, with the query marked. Separate from
 *  drawStages because it re-runs on every keystroke while the DOM does not. */
function paint(tokens) {
  for (const sample of ALL) {
    const el = sample.el;
    if (el.hidden) continue;
    el.querySelector('h4 .t').innerHTML = highlight(sample.label, tokens);
    if (sample.sub) el.querySelector('.what').innerHTML = highlight(sample.sub, tokens);
    el.querySelector('.says').innerHTML = highlight(sample.summary, tokens);
  }
}

/* ---------------------------------------------------------------- filter */

function apply() {
  const q = $('q').value.trim().toLowerCase();
  const tokens = q ? q.split(/\s+/).filter(Boolean) : [];

  let hits = 0;
  for (const sample of ALL) {
    const match = tokens.every((t) => sample.hay.includes(t));
    sample.el.hidden = !match;
    if (match) hits++;
  }

  /* A heading over nothing is worse than no heading: a category or a stage
   * with no surviving card disappears with its cards. The ones that survive
   * say how much of themselves is left, so a narrowed path still reads as a
   * path rather than as an arbitrary handful of cards. */
  for (const el of document.querySelectorAll('.category')) {
    const cards = [...el.querySelectorAll('.card')];
    const shown = cards.filter((c) => !c.hidden).length;
    el.hidden = shown === 0;
    el.querySelector('h3 span').textContent = tokens.length && shown !== cards.length
      ? `· ${shown} of ${cards.length}`
      : `· ${cards.length}`;
  }
  for (const el of document.querySelectorAll('.stage')) {
    const cards = [...el.querySelectorAll('.card')];
    const shown = cards.filter((c) => !c.hidden).length;
    el.hidden = shown === 0;
    if (tokens.length) {
      el.querySelector('.tally').textContent =
        `${shown} of ${cards.length} sample${cards.length === 1 ? '' : 's'} match`;
    }
  }
  /* Nothing is being searched for, so the stages go back to saying how far the
   * reader has come through them. */
  if (!tokens.length && ALL.every((s) => s.el)) drawProgress();

  $('found').textContent = tokens.length
    ? `${hits} of ${ALL.length} samples`
    : `${ALL.length} samples · ${DATA.counts.categories} topics`;
  $('empty').hidden = hits > 0;
  $('clearq').hidden = !tokens.length;
  /* A search is a reader looking for one thing, not one finishing the path -
   * the arrival card would be answering a question nobody asked. drawProgress
   * puts it back when the query is cleared. */
  $('whatsnext').hidden = tokens.length > 0 || !ALL.length || read.size !== ALL.length;

  paint(tokens);
  const url = new URL(location.href);
  if (q) url.searchParams.set('q', q); else url.searchParams.delete('q');
  history.replaceState(null, '', url.pathname + url.search + url.hash);
}

/* -------------------------------------------------------------- progress */

function saveProgress() {
  try { localStorage.setItem(STORE, JSON.stringify([...read])); } catch { /* private mode */ }
}

function drawProgress() {
  const done = ALL.filter((s) => read.has(s.class)).length;
  $('donecount').textContent = String(done);
  $('barfill').style.width = `${ALL.length ? (done / ALL.length) * 100 : 0}%`;
  $('clearprogress').hidden = done === 0;

  for (const sample of ALL) {
    const on = read.has(sample.class);
    sample.el.classList.toggle('read', on);
    sample.el.querySelector('.tick').setAttribute('aria-pressed', String(on));
  }

  for (const stage of DATA.stages) {
    const samples = ALL.filter((s) => s.stage === stage.id);
    const n = samples.filter((s) => read.has(s.class)).length;
    const section = document.querySelector(`.stage[data-stage="${stage.id}"]`);
    section.classList.toggle('done', n === samples.length);
    section.querySelector('.tally').textContent =
      `${samples.length} samples in ${stage.categories.length} topic${stage.categories.length === 1 ? '' : 's'}`
      + (n ? ` · ${n} read` : '');
    document.querySelector(`[data-count="${stage.id}"]`).textContent =
      n ? `${n}/${samples.length} read` : `${samples.length} samples`;
    document.querySelector(`#stagenav a[data-stage="${stage.id}"]`)
      .classList.toggle('complete', n === samples.length && samples.length > 0);
  }

  const next = ALL.find((s) => !read.has(s.class));
  $('continue').hidden = done === 0 || !next;
  if (next) $('continue').dataset.target = next.class;

  /* The end of the path is the one moment this page knows a reader is ready
   * for the two next door, so it is the one place that says so unprompted. */
  $('whatsnext').hidden = !ALL.length || done !== ALL.length || $('q').value.trim() !== '';
}

function jumpTo(cls) {
  const el = document.getElementById(`s-${cls}`);
  if (!el) return;
  if (el.hidden) { $('q').value = ''; apply(); }
  el.scrollIntoView({ behavior: 'smooth', block: 'center' });
  el.classList.remove('flash');
  void el.offsetWidth;                         // restart the animation
  el.classList.add('flash');
}

/* ------------------------------------------------------------------ boot */

async function boot() {
  try {
    const res = await fetch('apps.json');
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    DATA = await res.json();
  } catch (err) {
    $('stages').innerHTML = `<p class="empty">The catalogue could not be loaded (${esc(err.message)}).
      It is written by the deploy build; on a local checkout run
      <code>node scripts/generate-overview-index.mjs</code> first.</p>`;
    return;
  }

  for (const stage of DATA.stages) {
    for (const category of stage.categories) {
      category.samples.forEach((sample, i) => {
        sample.stage = stage.id;
        sample.stageTitle = stage.title;
        sample.category = category.name;
        sample.pos = i + 1;
        /* A title that only repeats the heading it sits under says nothing -
         * "Table" seven times under TABLE - so where the tile header IS the
         * category, the card is titled with what the sample actually shows and
         * the second line disappears. Same rule as SAMPLES.md; a numbered
         * series keeps its header, because there the numeral is the order. */
        const repeats = sample.title === category.name;
        sample.label = repeats ? sample.what : sample.title;
        sample.sub = repeats ? '' : sample.what;
        sample.hay = haystack(sample);
        ALL.push(sample);
      });
    }
  }

  $('total').textContent = String(DATA.counts.samples);
  $('alltotal').textContent = String(DATA.counts.samples);
  $('nexttotal').textContent = String(DATA.counts.samples);
  $('stagecount').textContent = String(DATA.counts.stages);
  $('overviewapp').textContent = DATA.overviewApp.toUpperCase();

  drawStages();
  for (const sample of ALL) sample.el = document.getElementById(`s-${sample.class}`);

  try { read = new Set(JSON.parse(localStorage.getItem(STORE) || '[]')); } catch { read = new Set(); }
  /* A class that has been removed or renamed since the last visit must not
   * count towards a progress bar over samples that exist. */
  read = new Set([...read].filter((cls) => ALL.some((s) => s.class === cls)));

  $('q').value = new URLSearchParams(location.search).get('q') || '';
  apply();
  drawProgress();
  if (location.hash.startsWith('#s-')) jumpTo(location.hash.slice(3));

  /* --------------------------------------------------------- interaction */

  $('find').addEventListener('submit', (e) => e.preventDefault());
  $('q').addEventListener('input', apply);
  for (const id of ['clearq', 'clearq2']) {
    $(id).addEventListener('click', () => { $('q').value = ''; apply(); $('q').focus(); });
  }

  $('stages').addEventListener('click', (e) => {
    const tick = e.target.closest('.tick');
    if (tick) {
      const cls = tick.closest('.card').dataset.class;
      if (read.has(cls)) read.delete(cls); else read.add(cls);
      saveProgress();
      drawProgress();
      return;
    }
    const term = e.target.closest('[data-term]');
    if (term) {
      $('q').value = term.dataset.term;
      apply();
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }
    const copy = e.target.closest('[data-copy]');
    if (copy) {
      navigator.clipboard?.writeText(copy.dataset.copy);
      const was = copy.textContent;
      copy.textContent = 'copied ✓';
      setTimeout(() => { copy.textContent = was; }, 1200);
    }
  });

  $('continue').addEventListener('click', () => jumpTo($('continue').dataset.target));

  $('clearprogress').addEventListener('click', () => {
    read = new Set();
    saveProgress();
    drawProgress();
  });

  /* Which stage the reader is in, for the rail. Bottom-heavy margins so the
   * stage whose cards fill the screen is the one that lights up, not the one
   * whose heading has just scrolled past. */
  const observer = new IntersectionObserver((entries) => {
    for (const entry of entries) {
      if (!entry.isIntersecting) continue;
      for (const a of document.querySelectorAll('#stagenav a')) {
        a.classList.toggle('here', a.dataset.stage === entry.target.dataset.stage);
      }
    }
  }, { rootMargin: '-90px 0px -65% 0px' });
  for (const el of document.querySelectorAll('.stage')) observer.observe(el);

  /* `/` focuses the search box, the way a documentation site does. */
  document.addEventListener('keydown', (e) => {
    if (e.key === '/' && !/^(INPUT|TEXTAREA|SELECT)$/.test(document.activeElement.tagName)) {
      e.preventDefault();
      $('q').focus();
      $('q').select();
    }
  });
}

boot();
