#!/usr/bin/env node
// Verifies that the strip list - the packages removed before the cloud and 702
// builds (AGENTS.md §2) - is spelled identically everywhere it appears, and
// that every path in it exists.
//
// The list lives in four places that nothing else keeps in sync: the two
// workflows that do the removal, the downport script, and the §2 build table
// that documents them. A path added to one and forgotten in another does not
// fail any build - it silently ships a package to a derived branch, or strips
// one the branch was supposed to carry. Hence this check.
//
// Not to be confused with the `noIssues` list in abaplint.jsonc: that one is a
// targeted suppression for the on-premise samples and is deliberately narrower
// (AGENTS.md §2, "Stripped is not unchecked").
//
// Exits non-zero on any drift. Run: node scripts/check-strip-lists.js
"use strict";

const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");

// every `rm -r`/`rm -rf` of src paths, however the file spells it: a shell
// command, a workflow step, or an inline code span in the markdown table
const RM = /rm\s+-r[a-z]*\s+((?:src\/[\d/]+[ \t]*)+)/g;

const SOURCES = [
  "package.json",
  ".github/workflows/abap-cloud.yaml",
  ".github/workflows/publish-branch.yaml",
  "AGENTS.md",
];

const found = new Map(); // file -> array of { paths: [...], text }
const errors = [];

for (const file of SOURCES) {
  const text = fs.readFileSync(path.join(root, file), "utf8");
  const occurrences = [...text.matchAll(RM)].map((m) => ({
    paths: m[1].trim().split(/\s+/),
    text: m[0].trim(),
  }));
  if (occurrences.length === 0) {
    errors.push(`${file}: no "rm -r <src paths>" found - did the strip step move or get renamed?`);
    continue;
  }
  found.set(file, occurrences);
}

const key = (paths) => [...paths].sort().join(" ");

// all occurrences, in every file, must name the same set of packages
const sets = new Map(); // sorted key -> [ "file: text", ... ]
for (const [file, occurrences] of found) {
  for (const occurrence of occurrences) {
    const k = key(occurrence.paths);
    if (!sets.has(k)) sets.set(k, []);
    sets.get(k).push(`${file}: ${occurrence.text}`);
  }
}

if (sets.size > 1) {
  errors.push("the strip list is not the same everywhere:");
  for (const [k, where] of sets) {
    errors.push(`  [${k}]`);
    for (const w of where) errors.push(`      ${w}`);
  }
}

// a stripped package that does not exist is a leftover from a rename
for (const k of sets.keys()) {
  for (const p of k.split(" ")) {
    if (!fs.existsSync(path.join(root, p))) {
      errors.push(`stripped package does not exist: ${p}`);
    }
  }
}

if (errors.length > 0) {
  console.error("The strip list has drifted apart:\n");
  for (const error of errors) console.error("  " + error);
  console.error("\nMake every place agree (see AGENTS.md §2) and re-run.");
  process.exit(1);
}

console.log(`strip list is consistent across ${found.size} files: ${[...sets.keys()][0]}`);
