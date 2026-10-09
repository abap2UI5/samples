# The browser smoke

Every sample, run as the real app in a headless browser, with no SAP system:
abap2UI5 and the samples are downported to 7.02 by abaplint, transpiled to
JavaScript and served by the framework's express shim, and Chromium starts
each class with `?app_start=<class>`.

```sh
npm ci                  # this repository, including playwright and the @openui5 sources
npm run e2e:setup       # clone abap2UI5 at A2UI5_PIN into .abap2UI5 (git-ignored), npm ci there
npm run e2e:build       # downport + transpile framework and samples (~2 min)
npm run e2e             # every sample (~10 min); exit 1 on a failure
```

`npm run e2e -- --only 024,104` runs some samples, `--port 3101` moves the
backend off port 3000, `--max-press 0` only boots. A sample edited after
the last `e2e:build` is not what the browser runs: rebuild first. To build
against a framework checkout of your own, set `A2UI5_HOME` to it.

## What a run checks

Per sample, at boot, after typing into the first input and selecting the
first row of the first table or list, and after each of up to six visible
buttons (Escape after every press):

- the framework's fatal-error overlay,
- a page error or a console error,
- a backend answer 4xx/5xx - the dump text is quoted,
- a page with (almost) no text.

A sample with a module in `e2e/flows/` runs that flow instead of the generic
steps. A flow is a regression test written against a bug the generic steps
could not reach:

| Flow | What it holds |
|---|---|
| `z2ui5_cl_smp_app_024` | the four ways to call `z2ui5_cl_smp_app_025`, its two views, `get_app_prev( )` and the way back with an event |
| `z2ui5_cl_smp_app_104` | both embedded sub-apps render when their row is selected and answer their own event |
| `z2ui5_cl_smp_app_504` | a refused quantity in the nested table is reported on Save and marked on its cell |

## What is expected to fail

`e2e/expected.mjs`, each entry with its reason: the apps that are not
standalone (they are driven by the flow of their caller), the one that fails
on purpose (`z2ui5_cl_smp_app_464` - only its own two errors are tolerated),
and the console lines the harness itself causes. Add to it only with a reason
a reader can check.

## Why the harness is built this way

UI5 comes from the `@openui5` npm packages, routed in for the CDN: sources,
no preload bundles and no themes. So the page's CSP gets `'unsafe-eval'`
and the hashes of the two inline scripts of the source bootstrap, and only in
the harness - a real system loads the CDN build. Unthemed controls can have a
zero-size box, which is why a press that Playwright refuses falls back to a
dispatched click.

The transpiler does not model `IS SUPPLIED` for a RETURNING parameter, so the
build rewrites the view-wired `v = client->follow_up_action( … )` to
`_event_client( )` in its copy; the samples themselves are correct ABAP.

The harness is a small copy of the one in
[samples-controls](https://github.com/abap2UI5/samples-controls) (`E2E.md`
there, and its e2e-debugging skill), which runs the same machinery over 600
ports and documents the traps in depth. `A2UI5_PIN` is the framework commit
it builds against; move it together with samples-controls'.
