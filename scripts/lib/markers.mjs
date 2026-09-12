/*
 * markers — what a capability marker at the end of a sample title means.
 *
 * An author appends `(A)`, `(C)` or `(A,C)` to a class's DESCRIPT (AGENTS.md
 * section 12), and the marker travels into every view of the catalogue: the
 * overview app, SAMPLES.md and catalogue.json. The legend has to travel with
 * it - a reader of any of the three should not have to open AGENTS.md to learn
 * what "(A)" on a title means - so it is written once, here, and every
 * renderer reads it. The three cannot drift.
 */
export const MARKERS = {
  '(A)': 'performs a frontend action (client->follow_up_action( ) or a client-side interaction such as drag and drop)',
  '(C)': 'uses an abap2UI5 custom control (the z2ui5.cc namespace)',
  '(A,C)': 'both',
};

/** The legend as one line of prose, for a page or an app: "(A) …; (C) …; (A,C) both". */
export const markersLine = () =>
  Object.entries(MARKERS).map(([mark, meaning]) => `${mark} ${meaning}`).join('; ');
