/*
 * What the browser smoke (scripts/e2e-smoke.mjs) expects to go wrong, and why.
 *
 * Every entry carries its reason. An entry without one is a failure somebody
 * stopped reading - and the point of the run is that a red line means a
 * broken sample.
 */

/* Apps the smoke does not judge on its own.
 *
 *   skip    - not a standalone app: started by itself it fails by design. Each
 *             one is driven by a flow of the app that calls it (e2e/flows/).
 *   expect  - the app fails ON PURPOSE when a button is pressed. Only errors
 *             matching the pattern are tolerated; anything else still fails. */
export const APPS = {
  z2ui5_cl_smp_app_025: {
    skip: 'called only by Z2UI5_CL_SMP_APP_024 - its read button casts get_app_prev( ) to the caller, which a standalone start does not have; e2e/flows/z2ui5_cl_smp_app_024.mjs drives it',
  },
  z2ui5_cl_smp_app_105: {
    skip: 'sub-app of the Nested View sample Z2UI5_CL_SMP_APP_104 - it builds into the view 104 hands it and has none of its own; e2e/flows/z2ui5_cl_smp_app_104.mjs drives it',
  },
  z2ui5_cl_smp_app_112: {
    skip: 'the second sub-app of Z2UI5_CL_SMP_APP_104, same reason as 105; driven by the same flow',
  },
  z2ui5_cl_smp_app_464: {
    expect: /Division by zero|ASSERTION_FAILED/,
    why: 'the sample shows what an uncaught exception and a dump look like: its two buttons divide by zero and fail an ASSERT, and the backend answers HTTP 500 on purpose',
  },
};

/* Console and page errors that are the HARNESS, not a sample: UI5 1.152 from
 * the npm sources, no CDN, no themes. `apps` scopes an entry to the classes
 * named; without it the entry applies to every app. */
export const NOISE = [
  {
    re: /sap-ui-version\.json/,
    why: 'the npm sources ship no sap-ui-version.json; UI5 asks for it and logs the 404',
  },
  {
    re: /manifest\.json could not be loaded|Failed to load resource/i,
    why: 'library manifests (sap/f, ...) a source-only UI5 does not serve; a 404 of a resource the BACKEND serves is caught by its HTTP status instead',
  },
  {
    re: /is not of type "sap\.ui\.core\.Popup\.Dock"/,
    apps: ['z2ui5_cl_smp_app_381'],
    why: 'the harness UI5 names the Popup.Dock values by their keys (CenterBottom) and logs the 1.71 form "center bottom" the sample passes - the sample targets 1.71, where that is the enum value, and the newer Popup lower-cases either form before positioning, so the toast still docks as asked',
  },
];
