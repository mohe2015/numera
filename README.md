# numera

Per-chapter figure and equation numbering, subfigure numbering, numbering functions that can render differently for references, equate package compatibility.

Requires Typst 0.15.0 or newer.

## Quick start

Import `numera`, apply it as a show rule, and use `heading-dependent` for the elements whose counters should include the current heading:

```typst
#import "@preview/numera:0.0.1": heading-dependent, normal-figure, numera

#let level = 1
#show: numera(level: level)

#set heading(numbering: "1.1")
#set math.equation(numbering: heading-dependent(level, "1"))
#show normal-figure: set figure(numbering: heading-dependent(level, "1"))

= Introduction

$ E = m c^2 $ <energy>

#figure([A result], caption: [A numbered figure]) <result>

See @energy and @result.
```

With `level: 1`, the equation and figure counters reset independently at each level-one heading and use heading-prefixed numbers such as `1.1` and `1.2`. Use `level: 0` for document-wide counters without a heading prefix.

## API overview

Numera numbering functions accept a named `ref` argument internally. It is `false` while rendering the numbered element and `true` while rendering a reference, which makes inline and reference forms independently composable.

| Function | Purpose |
| --- | --- |
| `numera(level: 0)` | Installs the counter resets, subfigure handling, and reference rendering. Apply it with `#show: numera(level: ...)`. |
| `heading-dependent(max-level, numbering, separator: ".")` | Prefixes a numbering with the current heading counter, truncated to `max-level`. |
| `ref-dependent(inline-numbering, ref-numbering)` | Uses one numbering on the element and another in references. |
| `subfigure-dependent(subfigure-numbering, figure-numbering: none)` | Selects numbering for subfigures and, optionally, normal figures. It does not add the parent figure number. |
| `subfigure-counter-dependent(subfigure-numbering, figure-numbering: none)` | Selects figure or subfigure numbering and prepends the parent figure counter to subfigures. Pass `figure-numbering: auto` to reuse the subfigure pattern for normal figures. |
| `concat(..numberings)` | Concatenates multiple Numera numbering functions into one numbering. |
| `non-ref(text)` | Emits `text` on the numbered element and nothing in references. Useful for inline-only punctuation. |
| `ref-only(text)` | Emits `text` only in references. |

For example, this renders equation numbers with parentheses on the equation but without them in references:

```typst
#import "@preview/numera:0.0.1": concat, heading-dependent, non-ref, numera

#show: numera(level: 1)
#set heading(numbering: "1")
#set math.equation(numbering: concat(
  non-ref("("),
  heading-dependent(1, "1"),
  non-ref(")"),
))
```

## Examples

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
