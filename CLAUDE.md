# CLAUDE.md

## Project

abap2UI5 Samples - Collection of demo apps for the abap2UI5 framework.

## Language

- **This entire project is in English.** All code, comments, commit messages, PR titles, PR descriptions, and any other text must be written in English.

## Rules

### abaplint

- **Run `abaplint` before every commit. It must report 0 issues.**
- Configuration: `abaplint.jsonc`
- Install: `npm install -g @abaplint/cli`
- Run: `abaplint`

### Code Conventions

- Never use an init flag attribute (`check_initialized`, `mv_init`, `is_initialized`, etc.). Always use `client->check_on_init( )` instead.
