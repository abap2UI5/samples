# CLAUDE.md

## Projekt

abap2UI5 Samples - Sammlung von Demo-Apps für das abap2UI5 Framework.

## Regeln

### abaplint

- **Vor jedem Commit muss `abaplint` ausgeführt werden und 0 Fehler zeigen.**
- Konfiguration liegt in `abaplint.jsonc`.
- Installation: `npm install -g @abaplint/cli`
- Aufruf: `abaplint`

### Code-Konventionen

- Kein init-Flag als Attribut verwenden (`check_initialized`, `mv_init`, `is_initialized`, etc.). Stattdessen immer `client->check_on_init( )` nutzen.
