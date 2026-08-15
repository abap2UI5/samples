#!/usr/bin/env node
// Verifies that the strip list - the packages removed before the 702 build
// (AGENTS.md §2) - is spelled identically everywhere it appears, and that every
// path in it exists.
//
// The list lives in two places that nothing else keeps in sync: the downport
// script that does the removal, and the §2 build table that documents it. A
// path added to one and forgotten in the other does not fail any build - it
// silently ships a package to the 702 branch, or strips one that branch was
// supposed to carry, and the documented build table stops describing the
// build. A path that no longer exists is caught too: the `rm -rf` in the
// downport is silent about it, so a package renamed elsewhere would go on
// being "stripped" while it is really shipped. Hence this check.
//
// Only 702 strips anything. main is published as it is and is checked in full
// by both abap-standard and abap-cloud, so those two workflows carry no strip
// list to compare.
//
// Stripped is not unchecked: abap-standard and abap-cloud lint the whole tree,
// the stripped packages included, and they pass (AGENTS.md §2).
//
// Exits non-zero on any drift. Run: node scripts/check-strip-lists.js
"use strict";

const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");

// every `rm -r`/`rm -rf` of src paths, however the file spells it: a shell
// command, a workflow step, or an inline code span in the markdown table.
// The package segment is NOT restricted to digits: a `src/<name>` package
// added to one list and forgotten in the other used to be invisible here,
// because the pattern stopped at the first non-digit and both files then
// agreed on the same TRUNCATED list - a silent pass from the one check whose
// whole job is to catch that drift. Shell metacharacters (`&`, `|`, `;`, a
// quote, a closing backtick) are outside the class, so a path list still ends
// where the command does.
const RM = /rm\s+-r[a-z]*\s+((?:src\/[\w.\-/]+[ \t]*)+)/g;

const SOURCES = [
  "package.json",
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
