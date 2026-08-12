# numera

Per-chapter figure and equation numbering, subfigure numbering, numbering functions that can render differently for references, equate package compatibility.

**Entry point:** `lib.typ`
**Package:** `@preview/numera:0.0.1`

## Setup commands

### Check if dependencies are already installed

Only run the install commands below if the installed versions don't match. Check with:

```bash
typst --version          # Expected: 0.15.1
typstyle --version       # Expected: 0.15.1
tt --version             # Expected: 0.4.1
typship --version        # Expected: 0.4.2
typst-package-check --version  # from git
```

### Install dependencies

```bash
cargo install --locked typst-cli@0.15.1
cargo install --locked tytanic@0.4.1
cargo install --locked typstyle@0.15.1
cargo install --git https://github.com/typst/package-check.git
cargo install typship@0.4.2
```

### Login to Typst universe (for publishing)
```bash
typship login universe  # Personal access tokens (classic) required
```

## Development workflow

> **Important:** Always run `export TYPST_PACKAGE_PATH=$PWD/packages` before any Typst commands. This environment variable is required for loading the local package, including when running tests.

### Pre-commit checks
```bash
export TYPST_PACKAGE_PATH=$PWD/packages
typst-package-check check
typstyle --check .
tt run
```

### Run all tests
```bash
export TYPST_PACKAGE_PATH=$PWD/packages
tt run
```

### Run a specific test
```bash
export TYPST_PACKAGE_PATH=$PWD/packages
tt run tests/<test-name>/test.typ
```

### Format code
```bash
typstyle --check .
```

### Publish package
```bash
typship publish universe
```

## Code style

- Typst language conventions
- Use `typstyle` for consistent formatting
- Run `typstyle --check .` before committing
- Keep `lib.typ` modular — one logical unit per code block
- Comment complex logic, especially show rules and counter manipulation

## Testing

- Regression tests live in `tests/` directory
- Each test is a self-contained `.typ` file with its own expected output
- Test directories follow naming patterns:
  - `reasoning-*` — reasoning/edge-case tests (excluded via `.typstignore`)
  - `compatibility-*` — compatibility tests (e.g., with `equate` package)
  - `issue-*` — regression tests for specific issues
- Each test has `ref/` (reference output), `out/` (actual output), and `diff/` (diff) subdirectories
- Tests are run via `tytanic` (`tt run`)

## PR instructions

- Title format: `[numera] <Title>`
- Always run `typstyle --check .` and `tt run` before committing
- Ensure the whole test suite passes (use `tt run`)
- Add tests for new features or bug fixes

## CI

CI is configured in `.github/workflows/typst-ci.yml` and runs:
1. `typst-package-check check` — package validation
2. `typstyle --check .` — formatting check
3. `tt run` — regression tests
