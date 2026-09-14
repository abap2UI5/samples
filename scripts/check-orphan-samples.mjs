#!/usr/bin/env node
/*
 * check-orphan-samples — a sample that is in the tree but in no catalogue.
 *
 * Every other gate here counts TILES: check-keywords holds each one to a
 * `@keywords` and a `@summary` line, generate-launchpad refuses a category no
 * learning-path stage names, generate-samples-md and generate-catalogue fail
 * when their output is stale. All of them read scanSamples( ), and scanSamples
 * only ever returns what it could place — so a sample the scan cannot place is
 * invisible to the lot of them, and a green `npm run check` says nothing about
 * it.
 *
 * That is not hypothetical. `Z2UI5_CL_SMP_APP_004` and thirteen others were
 * moved out of `src/00/97` and landed in the `src/` ROOT package (#843, and the
 * two hand-made commits before it). The root package has no catalogue: the
 * scan skips a class directly in `src/` because the overview app lives there
 * and must not list itself. So for two commits the repository shipped fourteen
 * samples that appeared in neither the overview app nor SAMPLES.md — among
 * them the only demonstrations of app_state_set_active, hash_back, _bind_path,
 * omit_initial, check_arg_literal and t_model_skipped, and Basics IV, which
 * left the learning path reading I, II, III, V, VI. Thirteen gates stayed
 * green the whole time.
 *
 * This is the gate for the other direction: not "is every tile complete" but
 * "is every sample a tile". A class whose name says sample
 * (`z2ui5_cl_smp_app_*`) has to sit in an area scanSamples reads — `src/00` or
 * `src/01` — or it is refused here.
 *
 * WHAT IS DELIBERATELY NOT AN ORPHAN:
 *
 *   - the overview app (`z2ui5_cl_smp_app_000`). It lives in the root package
 *     on purpose (AGENTS.md section 3) and is an index, not a sample;
 *     scanSamples drops it by name before either skip, so it never reaches
 *     the orphan list.
 *   - a ZZZ helper app. It is in an area, gets no tile by its own rule, and
 *     scanSamples returns it under `hidden` — accounted for, not lost.
 *   - a sample in `src/00/98`. No tile either, and that is the package's
 *     whole point; it is still scanned, still counted, still listed in
 *     SAMPLES.md's system section.
 *
 * The distinction this gate draws is therefore not "has a tile" but "was
 * SEEN". Being skipped by a rule is fine; being skipped by an accident of
 * where the file sits is not.
 *
 * Run: node scripts/check-orphan-samples.mjs  (npm run check:orphans)
 */
import { scanSamples, AREAS } from './lib/scan-samples.mjs';

const { areas, hidden, orphans } = scanSamples();

if (orphans.length > 0) {
  const n = orphans.length;
  console.error(
    `${n} sample class${n === 1 ? '' : 'es'} in the tree that no catalogue can reach:\n`,
  );
  for (const o of orphans) console.error(`  ${o.path}\n    sits in ${o.why}`);
  console.error(
    '\nA class named z2ui5_cl_smp_app_* has to live in a sample area '
    + `(${AREAS.map((a) => `src/${a}`).join(', ')}), in a categorised subpackage.`
    + '\nWhere it sits now it is in no overview app and in no SAMPLES.md row, '
    + 'and every\nother gate here passes it without looking: they all count '
    + 'tiles, and it is not one.'
    + '\n\nMove it into src/01 if it is a finished sample, or into src/00/98 if '
    + 'it is a test\napp (AGENTS.md sections 1 and 2), then run `npm run '
    + 'launchpad` and commit the result.',
  );
  process.exit(1);
}

const tiles = Object.values(areas).flat().length;
console.log(
  `check-orphans: ${tiles + hidden.length} sample class(es) scanned in `
  + `${AREAS.map((a) => `src/${a}`).join(' + ')}, every one of them reachable `
  + `by a catalogue (${hidden.length} ZZZ helper(s) accounted for) - OK`,
);
