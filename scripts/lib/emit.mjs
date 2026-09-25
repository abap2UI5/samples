/*
 * emit — the one `--check` tail every generator ends in.
 *
 * Four generators write a committed file (the overview app's catalogue block,
 * SAMPLES.md, catalogue.json, catalogue-derived.json), and each of them takes
 * `--check`: render exactly the same content, compare it with what is on disk
 * instead of writing it, and fail when the two differ. Same code path, one
 * branch at the end - a check that regenerated differently from the generator
 * would be worse than none. That branch was copied into all four, so a fix to
 * one (a missing file read as stale, an exit code) had to be carried into the
 * other three by hand. It lives here now; the generators pass their own
 * messages, so what a run prints has not changed.
 */
import fs from 'fs';

/** Whether this run compares instead of writing. */
export const CHECK = process.argv.includes('--check');

const say = (m) => (typeof m === 'function' ? m() : m);

/**
 * Write `content` to `outPath` - or, under `--check`, compare it with the file
 * that is there (a missing file is stale) and exit 1 when they differ.
 *
 * @param {string} outPath   the committed file
 * @param {string} content   what the generator rendered
 * @param {string} name      what the file is called in the default messages
 * @param {object} [messages]
 * @param {string[]} [messages.stale]  lines to print (stderr) before exiting 1
 * @param {string|(() => string)} [messages.fresh]  printed when the file is up to date
 * @param {string|(() => string)} [messages.wrote]  printed after the write
 */
export function writeOrCheck(outPath, content, name, messages = {}) {
  if (!CHECK) {
    fs.writeFileSync(outPath, content);
    console.log(say(messages.wrote ?? `${name}: written`));
    return;
  }
  const current = fs.existsSync(outPath) ? fs.readFileSync(outPath, 'utf8') : null;
  if (current !== content) {
    for (const line of messages.stale ?? [`${name} is stale - regenerate it and commit the result.`]) {
      console.error(line);
    }
    process.exit(1);
  }
  console.log(say(messages.fresh ?? `${name}: up to date`));
}
