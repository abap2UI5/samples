#!/usr/bin/env node
// Verifies that what AGENTS.md §1 says about the tree is what is on disk.
//
// Until 2026-09-22 that was a comparison of a drawn folder tree against the
// `<CTEXT>` of every `package.devc.xml`, because there were packages to get
// wrong. `src/` is FLAT now - one package, every sample directly in it - so
// there is exactly one thing left to check and it is the one that would be
// undone first: a subfolder. A new package under `src/` is invisible to
// abapGit's FOLDER_LOGIC=PREFIX in no way at all (it would become a real
// subpackage on the system), and it is invisible to every catalogue here
// (scan-samples.mjs reads the flat root), so it must not appear by accident.
//
// The CTEXT of the root package is still compared, against the quoted name in
// the §1 fence, so the file and the tree cannot drift apart on it either.
//
// Exits non-zero on any drift.
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), "..");
const src = path.join(root, "src");

/** Every package.devc.xml under src/, as "src/..." -> CTEXT. */
function actualPackages() {
  const map = new Map();
  const walk = (dir) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(p);
      } else if (entry.name === "package.devc.xml") {
        const rel = path.relative(root, dir).split(path.sep).join("/");
        const match = fs.readFileSync(p, "utf8").match(/<CTEXT>([^<]*)<\/CTEXT>/);
        map.set(rel, match ? match[1].trim() : "");
      }
    }
  };
  walk(src);
  return map;
}

/** The single line of the §1 fence: `src/   "<CTEXT>"   <prose>`. */
function documentedRoot() {
  const md = fs.readFileSync(path.join(root, "AGENTS.md"), "utf8");
  const section = md.split(/^## 1\. Repository layout$/m)[1];
  if (!section) throw new Error("AGENTS.md: section '## 1. Repository layout' not found");
  const fence = section.match(/```\n([\s\S]*?)```/);
  if (!fence) throw new Error("AGENTS.md: no fenced tree block in section 1");
  const line = fence[1].split("\n").find((l) => l.trim().startsWith("src/"));
  if (!line) throw new Error("AGENTS.md: the §1 tree block names no `src/` package");
  const quoted = line.match(/"([^"]*)"/);
  if (!quoted) throw new Error("AGENTS.md: the `src/` line in §1 carries no quoted package name");
  return quoted[1];
}

const actual = actualPackages();
const documented = documentedRoot();
const errors = [];

for (const [pkg, ctext] of actual) {
  if (pkg === "src") continue;
  errors.push(`subpackage on disk: ${pkg} ("${ctext}") — src/ is flat (AGENTS.md §1)`);
}

const folders = fs
  .readdirSync(src, { withFileTypes: true })
  .filter((e) => e.isDirectory())
  .map((e) => `src/${e.name}`);
for (const folder of folders) {
  if (!actual.has(folder)) errors.push(`folder on disk: ${folder} — src/ holds classes, not folders`);
}

if (!actual.has("src")) {
  errors.push("src/package.devc.xml is missing — the sample package has no descriptor");
} else if (actual.get("src") !== documented) {
  errors.push(
    `CTEXT mismatch for src: AGENTS.md says "${documented}", package.devc.xml says "${actual.get("src")}"`,
  );
}

if (errors.length > 0) {
  console.error("AGENTS.md §1 and the src/ tree have drifted apart:\n");
  for (const error of errors) console.error("  - " + error);
  console.error(
    "\nsrc/ is one flat package. A sample goes into it directly; a new package "
    + "needs\nAGENTS.md §1, scan-samples.mjs and this gate changed in the same commit.",
  );
  process.exit(1);
}

console.log(`AGENTS.md §1 matches the tree: one flat package src/ ("${documented}"), no subfolders.`);
