# Test guidance

These are persistent Tytanic visual regression tests. Each `tests/<name>/test.typ` source is compiled and compared page-by-page with PNGs in `tests/<name>/ref/`.

## Tests are mandatory

- Add a focused regression test for every bug fix and observable behavior change. A code change in `lib.typ` without relevant test coverage is incomplete.
- Prefer the smallest fixture that demonstrates the behavior. Include both the numbered element and references to it when reference output is involved.
- Cover boundaries that matter to Numera: heading reset levels (including level 0), numbering-pattern changes, custom supplements, normal figures, subfigures, and both ordinary and `equate` equations as applicable.
- Use a descriptive directory name. Reserve `reasoning-*` for isolated investigations of Typst semantics and `issue-*` for minimal upstream or compatibility reproductions; user-facing package behavior belongs in an `example-*` or other clearly named regression fixture.
- Keep imports through `@preview/numera:0.0.1`. The local package symlink ensures they exercise the current working tree when `TYPST_PACKAGE_PATH` is set.

Before creating, filtering, running, or updating tests, read the relevant current Tytanic documentation at <https://typst-community.github.io/tytanic/> and check `tt <command> --help` for the installed CLI. Never guess how Tytanic discovers tests, selects test sets, compares output, or updates references.

## Running tests

Run from the repository root:

```bash
export TYPST_PACKAGE_PATH="$PWD/packages"
tt run <test-name>
tt run
```

Always run the focused test during iteration and the entire suite before finishing. CI runs `tt run`, so a targeted pass alone is insufficient.

## Updating references

When an intentional rendering change causes a comparison failure:

```bash
export TYPST_PACKAGE_PATH="$PWD/packages"
tt update <test-name>
tt run <test-name>
tt run
```

Never use a blanket reference update merely to make failures disappear. Inspect every changed `ref/*.png`, confirm that page count, numbering, supplements, links, and surrounding layout are expected, and commit the source fixture with its reference images. Unrelated PNG changes are regressions until explained.

Before authoring or changing fixtures, fetch the latest official Typst documentation at <https://typst.app/docs/> and the relevant reference pages. Tests that intentionally capture version-specific behavior should say so in a short source comment and be checked against the current changelog.
