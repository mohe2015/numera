---
name: tytanic-documentation
description: Instructions to use Tytanic (`tt`)
---

When you want to use Tytanic, consult the documentation in https://github.com/typst-community/tytanic/tree/main/docs/book/src. If the home directory contains a `tytanic` directory, read the documentation from there, otherwise clone it.

# Quick Start

## Environment Setup

Always run before any Tytanic commands:
```bash
export TYPST_PACKAGE_PATH=$PWD/packages
```

## Common Commands

| Command | Description |
|---------|-------------|
| `tt list` | List all tests (uses `all()` expression) |
| `tt list -e '<expression>'` | List tests matching expression |
| `tt run` | Run all tests |
| `tt run <test-name>` | Run a specific test |
| `tt run -e '<expression>'` | Run tests matching expression |
| `tt update <test-name>` | Update reference output for a test |
| `tt update` | Update all tests' references |
| `tt new <name>` | Create a new persistent unit test |
| `tt new --compile-only <name>` | Create a compile-only test |
| `tt new --ephemeral <name>` | Create an ephemeral test |
| `tt remove <test-name>` | Remove a test |

## Test Set Expressions

Filter tests using boolean expressions with `-e` or `--expression`:

- `all()` — all tests
- `none()` — no tests
- `skip()` — tests marked with `[skip]` annotation
- `persistent()` — persistent (visual regression) tests
- `ephemeral()` — ephemeral (dynamic reference) tests
- `compile-only()` — compile-only tests
- `r:^pattern` — regex pattern match (e.g., `r:^features`)
- `regex:pattern` — alternative regex syntax

Operators: `and`/`&`, `or`/`\|`, `not`/`!`, `( )`

Examples:
```bash
tt run -e 'not compile-only() and r:^features'   # Run non-compile-only tests in features/
tt run -e 'r:^issue-'                             # Run all issue-* tests
tt run -e 'skip() and r:^regression'              # Run skipped regression tests (needs --no-skip)
```

## Test Kinds

### 1. Persistent Tests (Default)
Visual regression tests comparing output against reference PNGs in `ref/`.

**Create:** `tt new my-test`

**Structure:**
```
tests/my-test/
├── test.typ     # Main test script
└── ref/
    ├── 1.png    # Reference page 1
    ├── 2.png    # Reference page 2 (if multi-page)
    └── ...
```

**Update references:** `tt update my-test`

### 2. Compile-Only Tests
Tests that check compilation only, no visual output.

**Create:** `tt new --compile-only my-test`

**Structure:**
```
tests/my-test/
└── test.typ     # Main test script
```

**Use for:** API testing, panic assertions, value checks.

### 3. Ephemeral Tests
Tests where the reference is generated dynamically from `ref.typ`.

**Create:** `tt new --ephemeral my-test`

**Structure:**
```
tests/my-test/
├── test.typ     # Main test script
├── ref.typ      # Reference script (compiled each run)
└── out/         # Auto-generated (in .gitignore)
└── diff/        # Auto-generated (in .gitignore)
```

## Annotations (in test.typ)

Place annotations in a leading `///` doc comment block:

| Annotation | Description | Example |
|------------|-------------|---------|
| `[skip]` | Skip this test | `/// [skip]` |
| `[dir: rtl\|ltr]` | Text direction | `/// [dir: rtl]` |
| `[ppi: <float>]` | Pixels per inch | `/// [ppi: 144]` |
| `[max-delta: <0-255>]` | Max per-pixel delta | `/// [max-delta: 5]` |
| `[max-deviations: <int>]` | Max deviating pixels | `/// [max-deviations: 100]` |
| `[input: KEY=VALUE]` | Set sys.inputs | `/// [input: THEME=dark]` |

## Test Library (Augmented Standard Library)

Available in unit tests (not template tests):

```typst
#import "test"
#import "/src/lib.typ": my-function  // Access package internals

// Assertions
#assert.eq(actual, expected)
#assert.ne(actual, not-equal)
#assert-panic(() => function(args))

// Panic handling
let result = catch(() => function(args))
// result is the panic message string, or `none` if no panic
#assert.eq(result, "panicked with: expected X, got Y")
```

## Project Configuration (typst.toml)

```toml
[package]
name = "my-package"
version = "0.1.0"
entrypoint = "lib.typ"

[tool.tytanic]
tests = "tests"           # Path to test directory
[tool.tytanic.default]
dir = "ltr"               # Default direction
ppi = 144.0               # Default PPI
max-delta = 1             # Default max per-pixel delta
max-deviations = 0        # Default max deviations
use-system-fonts = false  # Use system fonts
```
