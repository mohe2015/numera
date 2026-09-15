# numera

Per-chapter figure and equation numbering, subfigure numbering, numbering functions that can render differently for references, equate package compatibility.

See these examples for usage:

- [Equate](https://github.com/mohe2015/numera/blob/main/tests/example-equate/test.typ)
- [Equate with sub-numbering](https://github.com/mohe2015/numera/blob/main/tests/example-equate-sub-numbering/test.typ)
- [Per-heading numbering](https://github.com/mohe2015/numera/blob/main/tests/example-per-heading-level-1-numbering/test.typ)
- [Per-heading subfigures](https://github.com/mohe2015/numera/blob/main/tests/example-per-heading-subfigures/test.typ)
- [Involved Equate compatibility](https://github.com/mohe2015/numera/blob/main/tests/involved-example-compatibility-equate/test.typ)

## Development

Install the development tools:

```bash
cargo install --locked --version 0.15.1 typst-cli
cargo install --locked --version 0.4.1 tytanic
cargo install --locked --version 0.15.1 typstyle
cargo install --git https://github.com/typst/package-check.git
cargo install --git https://github.com/sjfhsjfh/typship.git
```

### Package imports and test modes

The examples and tests deliberately import the latest released package with the same package specification users write:

```typst
#import "@preview/numera:0.0.1"
```

This is more useful than importing `lib.typ` by a relative or project-root path. The fixture remains a copyable user example and, without changing its source, package resolution can select either the published release or the current working tree. An `@local` import would similarly test a different namespace from the one users install.

The `packages/preview/numera/0.0.1` symlink exposes the current checkout under that package specification. Select it with a one-command override when testing development code:

```bash
TYPST_PACKAGE_PATH="$PWD/packages" tt run
```

Tytanic's explicit package-path option is an equivalent and slightly cleaner one-shot form because it cannot leak into later shell commands:

```bash
tt --package-path "$PWD/packages" run
```

Explicitly remove any inherited override to run the current test suite against the published `0.0.1` release. This verifies whether the release still passes today's tests:

```bash
env -u TYPST_PACKAGE_PATH tt run
```

For a reproducible release check, create a worktree at the exact release tag or commit. Running that worktree's tests without an override verifies the published release against its own test suite. Pointing the override at the current checkout instead runs the release-era tests against current development code:

```bash
development_packages="/absolute/path/to/current/numera/packages"
release_worktree="/absolute/path/to/release/worktree"

(
  cd "$release_worktree"
  env -u TYPST_PACKAGE_PATH tt run
  TYPST_PACKAGE_PATH="$development_packages" tt run
)
```

Together these modes distinguish a regression in development code, a released-package failure, and a newer test that intentionally requires unreleased behavior. Relative imports cannot provide that comparison without rewriting the fixtures. Keep release commits tagged so the reverse compatibility check is easy to reproduce.

### Checks and publishing

Format and verify development code before submitting a change:

```bash
typstyle --inplace .
typstyle --check .
tt --package-path "$PWD/packages" run
```

Publishing is a separate, intentional release step:

```bash
typst-package-check check

typship login universe # Currently Personal access tokens (classic) required
typship publish universe
```
