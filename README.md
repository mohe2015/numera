# numera

Numera adds flexible figure and equation numbering to Typst. It supports numbering by chapter or heading, subfigures, different styles on numbered elements and in references, and compatibility with the Equate package.

Requires Typst 0.15.0 or newer.

## Quick start

Import `numera`, apply its show rule, and use `heading-dependent` wherever a counter should include the current heading:

```typst
#import "@preview/numera:0.1.0": heading-dependent, normal-figure, numera

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

Here, `level: 1` resets the equation and figure counters at every level-one heading, producing numbers such as `1.1` and `1.2`. Set `level: 0` if you prefer document-wide counters without a heading prefix.

## API overview

Numera can format a number differently on the numbered element and in a reference. Its numbering functions receive a named `ref` argument: `false` for the element itself and `true` for a reference.

For all available functions and parameters, build the API reference in [`docs.typ`](docs.typ). It is generated from the source comments with [Tidy](https://typst.app/universe/package/tidy/):

```bash
typst compile --package-path "$PWD/packages" docs.typ
```

Building the reference also runs its documentation tests and checks that every parameter is documented. CI builds it as part of the test suite. Like the examples, `docs.typ` uses the normal `@preview/numera:0.1.0` import, so you can build it against either the published release or your local checkout.

| Function | Purpose |
| --- | --- |
| `numera(level: 0)` | Installs the counter resets, subfigure handling, and reference rendering. Apply it with `#show: numera(level: ...)`. |
| `heading-dependent(max-level, numbering, separator: ".")` | Prefixes a numbering with the current heading counter, truncated to `max-level`. |
| `ref-dependent(inline-numbering, ref-numbering)` | Uses one numbering on the element and another in references. |
| `subfigure-dependent(subfigure-numbering, figure-numbering: none)` | Selects numbering for subfigures and, optionally, normal figures. It does not add the parent figure number. |
| `subfigure-counter-dependent(subfigure-numbering, figure-numbering: none)` | Selects figure or subfigure numbering and prepends the parent figure counter to subfigures. Pass `figure-numbering: auto` to reuse the subfigure pattern for normal figures. |
| `concat(..numberings)` | Concatenates multiple Numera numbering functions into one numbering. |
| `non-ref(string)` | Emits `string` on the numbered element and nothing in references. Useful for inline-only punctuation. |
| `ref-only(string)` | Emits `string` only in references. |

For example, this renders equation numbers with parentheses on the equation but without them in references:

```typst
#import "@preview/numera:0.1.0": concat, heading-dependent, non-ref, numera

#show: numera(level: 1)
#set heading(numbering: "1")
#set math.equation(numbering: concat(
  non-ref("("),
  heading-dependent(1, "1"),
  non-ref(")"),
))
```

## Examples

The examples below cover the most common setups:

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

### Testing releases and local changes

Every example and test imports Numera the same way a user does:

```typst
#import "@preview/numera:0.1.0"
```

This is intentional. The examples remain copyable, while package resolution lets the same files exercise either the published release or the current checkout. A relative import would always select the checkout, while an `@local` import would test a different namespace from the one users install.

For everyday development, point Tytanic at the local package directory:

```bash
tt --package-path "$PWD/packages" run
```

The equivalent environment-variable form is handy when several commands should use the checkout:

```bash
TYPST_PACKAGE_PATH="$PWD/packages" tt run
```

To run the current test suite against the published `0.1.0` release, make sure no local override is active:

```bash
env -u TYPST_PACKAGE_PATH tt run
```

This tells you whether the released package still passes today's tests. A failure does not always mean the release is broken: the current suite may cover an API or behavior that has not been released yet.

You can make the opposite comparison with a worktree at the release tag or commit. First run the old test suite against the published package to verify the release itself, then point those same tests at your current checkout to check backward compatibility:

```bash
development_packages="/absolute/path/to/current/numera/packages"
release_worktree="/absolute/path/to/release/worktree"

(
  cd "$release_worktree"
  env -u TYPST_PACKAGE_PATH tt run
  TYPST_PACKAGE_PATH="$development_packages" tt run
)
```

Together, these commands answer four useful questions:

- Does the current checkout pass the current tests?
- Does the published release still pass the current tests?
- Does a release pass the tests that shipped with it?
- Does the current checkout still pass an older release's tests?

Keeping release commits tagged makes the last two checks easy to reproduce.

### Checks and publishing

Format and verify development code before submitting a change:

```bash
typstyle --inplace .
typstyle --check .
tt --package-path "$PWD/packages" run
typst compile --package-path "$PWD/packages" docs.typ
```

Publishing is a separate, intentional release step:

```bash
typst-package-check check

typship login universe # A classic personal access token is currently required
typship publish universe
```
