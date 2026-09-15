# Repository guidance

## Project overview

Numera is a Typst package for heading-dependent equation and figure numbering, subfigure numbering, reference-specific rendering, and compatibility with the `equate` package.

- `lib.typ` is the package entry point and contains the public implementation.
- `typst.toml` is the package manifest. Keep its version aligned with the local package path when preparing a release.
- `packages/preview/numera/0.0.1` is a symlink back to the repository root. With a package-path override, it makes the tests' released-package imports resolve to the working tree.
- `tests/` contains Tytanic visual regression tests; its nested `AGENTS.md` has mandatory test instructions.
- `.github/workflows/typst-ci.yml` defines the authoritative CI checks.
- `.typstignore` excludes test references, investigative tests, and the local package link from package contents.

## Working principles

- Preserve the package's small, composable API. Prefer focused helpers and Typst-native counters, selectors, context, set rules, and show rules over duplicated rendering logic.
- Treat every top-level `#let` in `lib.typ` as public unless there is clear evidence otherwise. Preserve signatures and output behavior unless the requested change intentionally modifies the API.
- Keep `///` documentation accurate for public helpers, especially the `ref` convention used by numbering functions.
- Be careful with location-sensitive logic. `here()`, `query`, `counter.display(..., at: ...)`, show-rule ordering, element numbering, and reference rendering are central to this package and can change behavior subtly.
- Preserve compatibility for normal figures (`image`, `table`, and `raw`), `kind: "subfigure"`, built-in equations, and `equate` equations unless a change is explicitly narrower.
- Run `typstyle --inplace .` after editing Typst files; do not hand-fight formatter output.

## Use the latest Typst documentation

Before designing or implementing a Typst change, fetch the current official documentation from <https://typst.app/docs/> and open the relevant reference pages. The live documentation identifies the Typst version it describes; do not rely only on memory, old examples, or the locally installed compiler's version. Also check the current changelog and migration notes when behavior may have changed between Typst releases.

Prefer official Typst documentation and the upstream Typst source for language and runtime semantics. If current documentation cannot be fetched, state that limitation before making an assumption about version-sensitive behavior. Use `typst --version` to record the compiler actually used for local verification.

Before using or changing the Tytanic test workflow, read the current Tytanic documentation at <https://typst-community.github.io/tytanic/> and consult `tt <command> --help` for the installed version. Do not guess command syntax, test-set expressions, discovery rules, comparison defaults, reference-update behavior, or Typst compatibility based on experience with another test runner.

## Package-resolution test matrix

Tests intentionally use `#import "@preview/numera:0.0.1"`, where `0.0.1` is the latest released version. Keep the package-form import: it is the form users copy, exercises the public package boundary, and lets the same fixture select development or released code through package resolution. A relative or project-root import always selects checkout code, while `@local` tests a different namespace; either change would discard the release-comparison benefit.

Use one-shot selection so an exported variable cannot silently affect later checks:

- Current tests against current development: `tt --package-path "$PWD/packages" run` or `TYPST_PACKAGE_PATH="$PWD/packages" tt run`.
- Current tests against the published release: `env -u TYPST_PACKAGE_PATH tt run`.
- Release tests against the published release: from a worktree at the exact release tag or commit, run `env -u TYPST_PACKAGE_PATH tt run`.
- Release tests against current development: from that release worktree, run `TYPST_PACKAGE_PATH="/absolute/path/to/current/checkout/packages" tt run`.

The first mode is mandatory for ordinary development. Use the release modes for compatibility investigations and before a release. A current-suite/published-release failure can mean that new tests require unreleased behavior; inspect it rather than updating references or assuming either implementation is wrong. Tag every release commit so its own test suite can be checked reproducibly.

Tytanic's `--package-path` option is the cleanest development-only override. Do not put the development package path in permanent Tytanic configuration: being able to omit or unset the override is what makes published-release verification possible. A task-runner wrapper may provide named matrix commands later, but it must preserve all four modes and make the selected implementation obvious.

## Verification

From the repository root, use the local package tree for development tests:

```bash
typstyle --check .
tt --package-path "$PWD/packages" run
```

Tests are essential, not optional. Every behavior change or bug fix must add or update a focused regression test and its reviewed reference images. Run the most relevant test while iterating, then run the complete suite before finishing. Do not report success if the full suite was skipped; state exactly what was and was not run.

For manifest or packaging changes, also run `typst-package-check check` when the tool is available. Publishing with `typship publish universe` is a release action and must only be done when explicitly requested.

## Change discipline

- Keep edits scoped; do not modify generated reference PNGs unless the rendered change is intended and reviewed.
- Keep test imports on the latest released package form (`@preview/numera:0.0.1`) so tests can exercise both published and development package resolution.
- When releasing a new version, update the manifest version, every Numera test import, and the versioned local-package symlink together.
- Update `README.md` examples or API prose when public usage changes.
- Never replace the `packages/preview/numera/0.0.1` symlink with copied package contents.
