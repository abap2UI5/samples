_This project is open source and developed alongside other projects or during free time. Contributions are greatly appreciated!_

Check out the contribution guidelines [here.](https://abap2ui5.github.io/docs/resources/contribution.html)

## Working in this repository

Everything specific to it — the folder scheme, what belongs in `src/01` and
what in `src/00`, the header lines every sample carries, the generated
catalogue and the gates — is in **[AGENTS.md](AGENTS.md)**. It is written for
agents and for people; read it before changing anything under `src/` or
`scripts/`.

The short version:

```sh
npm ci
npm run check        # everything CI runs, in order: the framework pin, abaplint
                     # (Standard and Cloud), the abap2UI5 linter, the AGENTS.md
                     # structure, the keyword lines, the generated overview app,
                     # SAMPLES.md and catalogue.json, the prose, the docs links,
                     # the app rules and the rename test
npm run launchpad    # regenerate the overview app, SAMPLES.md, catalogue.json
                     # and the derived catalogue after any change to a sample
```

Adding a sample, in short (AGENTS.md sections 4 and 12 have the rules):

1. One class `z2ui5_cl_smp_app_<no>` under `src/01`, self-contained, with its
   abapGit short text (`<DESCRIPT>`) in the form `<Category> [<Roman numeral>] - <what it shows>`.
2. The three comment lines at the top of the class: `" @keywords` (the words a
   reader searches by), `" @summary` (one sentence saying what it shows), and,
   where a documentation chapter explains the pattern, `" @docs <url>`.
3. Its category belongs to one stage of the learning path
   (`scripts/lib/learning-path.json`) — a new category is added there.
4. `npm run launchpad`, then `npm run check`, and commit the regenerated files
   with the sample.

Work on `main`; the `702` branch is generated from it on every push and never
committed to directly. Bug reports and feature requests for abap2UI5 itself
belong in the [abap2UI5 repository](https://github.com/abap2UI5/abap2UI5/issues).
