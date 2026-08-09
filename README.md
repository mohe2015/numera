# numera

Per-chapter figure and equation numbering, subfigure numbering, numbering functions that can render differently for references, and equate package compatibility.

## Quick start

```typst
#import "@preview/numera:0.0.1": numera

#set heading(numbering: "1.1")
#set math.equation(supplement: "Eq.")
#set figure(supplement: "Fig.")

#show: numera(level: 1)
```

This resets equation and figure counters on headings up to `level`.

## Common setups

### 1) Reset counters by chapter

See: [`tests/example-1-reset-by-heading/test.typ`](tests/example-1-reset-by-heading/test.typ)

### 2) Custom numbering for display and references

See: [`tests/example-2-custom-numbering/test.typ`](tests/example-2-custom-numbering/test.typ)

### 3) Subfigure numbering tied to outer figure

See: [`tests/example-3-subfigure/test.typ`](tests/example-3-subfigure/test.typ)

### 4) Reference-friendly numbering (display vs reference)

See: [`tests/example-4-reference-friendly-numbering/test.typ`](tests/example-4-reference-friendly-numbering/test.typ)

## Full examples

- Basic long-form example: [`tests/example/test.typ`](tests/example/test.typ)
- `equate` compatibility example: [`tests/compatibility-equate/test.typ`](tests/compatibility-equate/test.typ)

## Development

```bash
cargo install --locked typst-cli
cargo install --locked tytanic
cargo install --locked typstyle
cargo install --git https://github.com/typst/package-check.git
cargo install --git https://github.com/sjfhsjfh/typship.git

export TYPST_PACKAGE_PATH=$PWD/packages
typst-package-check check
typstyle --check .
tt run
typship publish universe
```
