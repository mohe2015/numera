# numera

Per-chapter figure and equation numbering, subfigure numbering, numbering functions that can render differently for references, equate package compatibility.

See these examples for usage:

- [Equate](https://github.com/mohe2015/numera/blob/main/tests/example-equate/test.typ)
- [Equate with sub-numbering](https://github.com/mohe2015/numera/blob/main/tests/example-equate-sub-numbering/test.typ)
- [Per-heading numbering](https://github.com/mohe2015/numera/blob/main/tests/example-per-heading-level-1-numbering/test.typ)
- [Per-heading subfigures](https://github.com/mohe2015/numera/blob/main/tests/example-per-heading-subfigures/test.typ)
- [Involved Equate compatibility](https://github.com/mohe2015/numera/blob/main/tests/involved-example-compatibility-equate/test.typ)

## Development

```bash
cargo install --locked typst-cli
cargo install --locked tytanic
cargo install --locked typstyle
cargo install --git https://github.com/typst/package-check.git
cargo install --git https://github.com/sjfhsjfh/typship.git

typship login universe # Currently Personal access tokens (classic) required

export TYPST_PACKAGE_PATH=$PWD/packages
typst-package-check check
typstyle --inplace .
typstyle --check .
tt run
typship publish universe
```
