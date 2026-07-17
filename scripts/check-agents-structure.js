#!/usr/bin/env node
// Verifies that the folder tree documented in AGENTS.md §1 matches the actual
// package structure: every subpackage in the tree must exist with exactly the
// documented CTEXT (package.devc.xml), and every actual subpackage must appear
// in the tree. Exits non-zero on any drift.
"use strict";

const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");

function actualPackages() {
  const map = new Map(); // "src/00/01" -> CTEXT
  const walk = (dir) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const p = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(p);
      } else if (entry.name === "package.devc.xml") {
        const rel = path.relative(root, dir).split(path.sep).join("/");
        if (rel === "src") continue; // root package is not part of the documented tree
        const match = fs.readFileSync(p, "utf8").match(/<CTEXT>([^<]*)<\/CTEXT>/);
        map.set(rel, match ? match[1].trim() : "");
      }
    }
  };
  walk(path.join(root, "src"));
  return map;
}

function documentedPackages() {
  const md = fs.readFileSync(path.join(root, "AGENTS.md"), "utf8");
  const section = md.split(/^## 1\. Repository layout$/m)[1];
  if (!section) throw new Error("AGENTS.md: section '## 1. Repository layout' not found");
  const fence = section.match(/```\n([\s\S]*?)```/);
  if (!fence) throw new Error("AGENTS.md: no fenced tree block in section 1");

  const map = new Map(); // "src/00/01" -> CTEXT
  const stack = [];
  for (const line of fence[1].split("\n")) {
    const m = line.match(/^([│ ]*)(?:├──|└──) (\d+)\/ {2}(.*)$/);
    if (!m) continue;
    const depth = m[1].length / 4;
    if (!Number.isInteger(depth)) throw new Error(`AGENTS.md: unexpected tree indentation in line: ${line}`);
    stack[depth] = m[2];
    stack.length = depth + 1;

    // CTEXT = quoted label ("basic") or the text before the first run of 2+ spaces
    let rest = m[3].trim();
    const quoted = rest.match(/^"([^"]*)"/);
    const ctext = quoted ? quoted[1] : rest.split(/ {2,}/)[0].trim();
    map.set("src/" + stack.join("/"), ctext);
  }
  if (map.size === 0) throw new Error("AGENTS.md: no package lines found in the tree block");
  return map;
}

const actual = actualPackages();
const documented = documentedPackages();
const errors = [];

for (const [pkg, ctext] of documented) {
  if (!actual.has(pkg)) {
    errors.push(`documented in AGENTS.md but missing on disk: ${pkg} ("${ctext}")`);
  } else if (actual.get(pkg) !== ctext) {
    errors.push(`CTEXT mismatch for ${pkg}: AGENTS.md says "${ctext}", package.devc.xml says "${actual.get(pkg)}"`);
  }
}
for (const [pkg, ctext] of actual) {
  if (!documented.has(pkg)) {
    errors.push(`exists on disk but not documented in AGENTS.md §1: ${pkg} ("${ctext}")`);
  }
}

if (errors.length > 0) {
  console.error("AGENTS.md §1 tree and src/ package structure have drifted apart:\n");
  for (const error of errors) console.error("  - " + error);
  console.error("\nUpdate the tree in AGENTS.md §1 (or fix the package) so both agree.");
  process.exit(1);
}

console.log(`AGENTS.md §1 tree matches src/ package structure (${actual.size} subpackages).`);
