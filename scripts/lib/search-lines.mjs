/*
 * search-lines — the rules on the two `"` comment lines every sample opens
 * with, `@keywords` and `@summary` (AGENTS.md section 4), decided in ONE place.
 *
 * Two gates hold them: generate-launchpad.mjs refuses to write a catalogue
 * whose tile lacks a line, and check-keywords.mjs refuses the pull request
 * (and reads the source file itself, for the three things a tile cannot show:
 * that the line is FIRST, lowercase, and long enough). Each used to carry the
 * decisions of its own, and two copies of "which sample is missing what" can
 * only drift apart silently - the generator would refuse a tile the gate had
 * passed, or the other way round. The decisions are here; each caller renders
 * its own message, so what a run prints has not changed.
 */

/* Loose enough to survive reformatting, strict enough to mean it: the
 * `@keywords` line has to be FIRST. A keyword line further down is one a
 * reader scrolls past and one a scanner reading the head of a file would
 * miss. `@summary` sits directly under it and must say something. */
export const KEYWORDS = /^" @keywords (.+?)\r?$/;
export const SUMMARY = /^" @summary (\S.*?)\r?$/;

/* Below three terms the line is not doing its job: two words are the class
 * header again, and the header is already searched. Four to eight is the
 * point. */
export const MIN_TERMS = 3;

/** Tiles nobody can FIND: no `@keywords` line. */
export const unsearchable = (tiles) => tiles.filter((t) => !t.keywords);

/** Tiles nobody can CHOOSE: no `@summary` line. */
export const unrecognisable = (tiles) => tiles.filter((t) => !t.summary);

/** Entries carrying one of the two lines without the other - the state nobody
 *  chose: an author added a sample the way the last one looked and stopped
 *  halfway. Both or neither; they answer the two halves of one question. */
export const halfDone = (entries) => entries.filter((t) => Boolean(t.keywords) !== Boolean(t.summary));
