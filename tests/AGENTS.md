# Test guidance

Most tests are persistent Tytanic visual regressions: each `tests/<name>/test.typ` source with a `ref/` directory is compiled and compared page-by-page with its PNGs. Tests without `ref/`, such as `api`, are compile-only semantic tests.

## Tests are mandatory

- Add a focused regression test for every bug fix and observable behavior change. A code change in `lib.typ` without relevant test coverage is incomplete.
- Prefer the smallest fixture that demonstrates the behavior. Include both the numbered element and references to it when reference output is involved.
- Cover boundaries that matter to Numera: heading reset levels (including level 0), numbering-pattern changes, custom supplements, normal figures, subfigures, and both ordinary and `equate` equations as applicable.
- Use a descriptive directory name. Reserve `reasoning-*` for isolated investigations of Typst semantics and `issue-*` for minimal upstream or compatibility reproductions; user-facing package behavior belongs in an `example-*` or other clearly named regression fixture.
- Keep imports through `@preview/numera:0.1.0`, where the pin is the latest released version. This is intentional: the fixtures use the same public import users copy, can test the published release with no package-path override, and can test development code through the local package symlink when an override is set. Do not replace these imports with relative, project-root, or `@local` imports; those approaches lose this two-way package-resolution test.

Before creating, filtering, running, or updating tests, read the relevant current Tytanic documentation at <https://typst-community.github.io/tytanic/> and check `tt <command> --help` for the installed CLI. Never guess how Tytanic discovers tests, selects test sets, compares output, or updates references.

## Running tests

Run from the repository root:

```bash
tt --package-path "$PWD/packages" run <test-name>
tt --package-path "$PWD/packages" run
```

Always run the focused test during iteration and the entire suite before finishing. CI runs `tt run`, so a targeted pass alone is insufficient.

To verify the published release against the current suite, explicitly remove a possibly inherited override:

```bash
env -u TYPST_PACKAGE_PATH tt run
```

To verify that a release passes its own tests, run the same command from a worktree at that release's exact tag or commit. From the release worktree, setting `TYPST_PACKAGE_PATH` to the absolute `packages` directory of the current development checkout instead tests current development code against the release-era suite. Treat failures between suite/package versions as compatibility evidence to investigate, not as references to accept automatically.

## Updating references

When an intentional rendering change causes a comparison failure:

```bash
tt --package-path "$PWD/packages" update <test-name>
tt --package-path "$PWD/packages" run <test-name>
tt --package-path "$PWD/packages" run
```

Never use a blanket reference update merely to make failures disappear. Inspect every changed `ref/*.png`, confirm that page count, numbering, supplements, links, and surrounding layout are expected, and commit the source fixture with its reference images. Unrelated PNG changes are regressions until explained.

Before authoring or changing fixtures, fetch the latest official Typst documentation at <https://typst.app/docs/> and the relevant reference pages. Tests that intentionally capture version-specific behavior should say so in a short source comment and be checked against the current changelog.
