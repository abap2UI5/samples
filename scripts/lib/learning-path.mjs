/*
 * learning-path — the teaching order of src/01, read from the one editorial
 * file behind it (lib/learning-path.json), plus the three rules that keep that
 * order attached to the tree.
 *
 * Two generators need the same answer: generate-catalogue.mjs publishes each
 * sample's `stage` to every consumer of catalogue.json, and
 * generate-launchpad.mjs groups the rows of the overview app by it. One
 * reader, so the app in the system and the catalogue on GitHub cannot disagree
 * about which stage a sample is in.
 *
 * The rules used to live in generate-catalogue.mjs alone. All three failures
 * are silent without them - a new category simply falls off the path, a
 * renamed one leaves a stage pointing at nothing - so whichever generator runs
 * first has to refuse:
 *   - every category in src/01 belongs to EXACTLY ONE stage,
 *   - a category a stage names exists on at least one sample,
 *   - a category no stage names fails rather than being dropped.
 *
 * `fail` is the caller's: each generator prefixes its own name and exits.
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const HERE = path.dirname(fileURLToPath(import.meta.url));
export const LEARNING_PATH = path.join(HERE, 'learning-path.json');

/**
 * @param {Array<{base: string}>} tiles  the src/01 tiles of scanSamples( )
 * @param {(message: string) => never} fail
 * @returns {{ stages: Array<{id: string, title: string, blurb: string, categories: string[]}>,
 *             stageOf: (base: string) => {id: string, title: string, blurb: string} }}
 */
export function loadLearningPath(tiles, fail) {
  const { stages } = JSON.parse(fs.readFileSync(LEARNING_PATH, 'utf8'));

  const byCategory = new Set(tiles.map((tile) => tile.base));
  const stageOf = new Map();
  for (const stage of stages) {
    for (const name of stage.categories) {
      if (stageOf.has(name)) {
        fail(`category "${name}" is in two stages (${stageOf.get(name).id} and ${stage.id}) - scripts/lib/learning-path.json`);
      }
      stageOf.set(name, stage);
      if (!byCategory.has(name)) {
        fail(`stage "${stage.id}" names category "${name}", which no sample in src/01 carries.\n`
          + "Drop it from scripts/lib/learning-path.json, or put the category back on a sample's DESCRIPT.");
      }
    }
  }
  const unplaced = [...byCategory].filter((name) => !stageOf.has(name));
  if (unplaced.length) {
    fail(
      `${unplaced.length} categor${unplaced.length === 1 ? 'y belongs' : 'ies belong'} to no stage of the learning path: ${unplaced.join(', ')}\n`
      + `Add ${unplaced.length === 1 ? 'it' : 'them'} to scripts/lib/learning-path.json - a category with no stage is a sample nobody following the path can reach.`,
    );
  }

  return { stages, stageOf: (base) => stageOf.get(base) };
}
