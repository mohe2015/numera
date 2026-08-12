---
name: typst-documentation
description: When you have problems with Typst usage this provides documentation
---

When you need to read the Typst documentation, consult the local documentation in `~/Documents/typst/docs/`. If this directory does not exist, clone the repository first:

```bash
git clone git@github.com:typst/typst.git ~/Documents/typst
# or: git clone https://github.com/typst/typst.git ~/Documents/typst
```

## Documentation Structure (Local: `~/Documents/typst/docs/`)

```
docs/
├── content/           # Documentation content (Typst files)
│   ├── index.typ              # Documentation root
│   ├── overview.typ           # Overview page
│   ├── tutorial/              # Beginner tutorial (4 chapters)
│   │   ├── index.typ
│   │   ├── 1-writing.typ
│   │   ├── 2-formatting.typ
│   │   ├── 3-advanced.typ
│   │   └── 4-template.typ
│   ├── reference/             # API reference
│   │   ├── index.typ
│   │   ├── language/          # Language concepts
│   │   │   ├── index.typ
│   │   │   ├── syntax.typ       # Syntax modes, markup shortcuts
│   │   │   ├── scripting.typ    # Functions, variables, control flow
│   │   │   ├── styling.typ      # Show/set rules
│   │   │   └── context.typ      # Contextual programming
│   │   ├── library/           # All built-in functions & types
│   │   │   ├── index.typ
│   │   │   ├── foundations.typ  # Types, functions, operators, stdlib
│   │   │   ├── model.typ        # Headings, paragraphs, links, equations
│   │   │   ├── text.typ         # Text styling, numbering, dictionaries
│   │   │   ├── math.typ         # Math mode, functions, symbols
│   │   │   ├── symbols.typ      # Unicode symbols
│   │   │   ├── layout.typ       # Grid, layout, columns, blocks
│   │   │   ├── visualize.typ    # Drawing, images, colors
│   │   │   ├── introspection.typ # Meta, diagnostics, imports
│   │   │   └── data-loading.typ # CSV, JSON, YAML, TOML, PDF
│   │   ├── export/            # Export formats
│   │   │   ├── index.typ
│   │   │   ├── pdf.typ
│   │   │   ├── html.typ
│   │   │   ├── png.typ
│   │   │   ├── svg.typ
│   │   │   └── bundle.typ
│   ├── guides/                # In-depth how-tos
│   │   ├── index.typ
│   │   ├── for-latex-users.typ
│   │   ├── page-setup.typ
│   │   ├── tables.typ
│   │   └── accessibility.typ
│   └── changelog/             # Version history
├── components/           # Documentation infrastructure (Typst files)
├── assets/               # CSS/JS/static files
└── dev/                  # Developer docs (architecture, etc.)
```

## Online Documentation

- **Reference docs:** https://typst.app/docs/reference/
- **Tutorial:** https://typst.app/docs/tutorial/
- **Guides:** https://typst.app/docs/guides/
- **Reference index:** https://typst.app/docs/reference/
- **Standard library:** https://typst.app/docs/reference/library/
- **Universe (packages):** https://typst.app/universe/
- **Forum (questions):** https://forum.typst.app/

## Reading Documentation Files

### File Format
All documentation content files are `.typ` files — they are written in Typst itself and use Typst-specific macros for rendering. Read them directly:

```bash
read ~/Documents/typst/docs/content/reference/library/foundations.typ
```

### Key Files for Common Questions

| Topic | File to Read |
|-------|--------------|
| Basic syntax, modes, markup | `content/reference/language/syntax.typ` |
| Variables, functions, control flow | `content/reference/language/scripting.typ` |
| Show/set rules, styling | `content/reference/language/styling.typ` |
| Types and core functions | `content/reference/library/foundations.typ` |
| Document structure (headings, paragraphs, links) | `content/reference/library/model.typ` |
| Text, numbering, dictionaries | `content/reference/library/text.typ` |
| Math mode and functions | `content/reference/library/math.typ` |
| Layout, grid, columns | `content/reference/library/layout.typ` |
| Drawing, colors, images | `content/reference/library/visualize.typ` |
| Meta, diagnostics, imports | `content/reference/library/introspection.typ` |
| Data loading (CSV, JSON, YAML) | `content/reference/library/data-loading.typ` |
| PDF/HTML/PNG/SVG export | `content/reference/export/*.typ` |
| Guide for LaTeX users | `content/guides/for-latex-users.typ` |

## Reading Rust Source Documentation

The reference content (especially library functions) is embedded in Rust doc comments in the source files. This is the **primary source of truth** for function documentation, as the Typst content files only provide a high-level overview:

```bash
# Key Rust crates for reference:
# crates/typst-kernel/     - Core types, error handling
# crates/typst-library/    - Standard library functions (model, math, text, etc.)
# crates/typst-base/       - Foundation types and functions
# crates/typst-syntax/     - Language syntax, lexer, parser
# crates/typst-eval/       - Evaluation engine, builtins
# crates/typst-parsetree/  - Parse tree nodes

# Search for specific function:
grep -rn "counter" ~/Documents/typst/crates/typst-library/src/ | head -20

# Search for specific feature:
grep -rn "numbering" ~/Documents/typst/crates/typst-library/src/model/ | head -20

# Browse introspection (counters, query) source:
grep -l "counter\|query" ~/Documents/typst/crates/typst-library/src/ -r
```

**Important:** The `counter` function and other introspection features are defined in `crates/typst-library/src/`. Documentation for these functions (including parameters, behavior, and examples) is in the Rust doc comments, not in the Typst content files. The Typst content files only mention them briefly.

### Common Source Files by Topic

| Topic | Source Files |
|-------|-------------|
| Counters, queries | `crates/typst-library/src/model/counter.rs` |
| Numbering | `crates/typst-library/src/model/numbering.rs` |
| Headings | `crates/typst-library/src/model/heading.rs` |
| Figures | `crates/typst-library/src/model/figure.rs` |
| References | `crates/typst-library/src/model/reference.rs` |
| Link resolution | `crates/typst-library/src/model/link.rs` |
| Text styling | `crates/typst-library/src/text/` |
| Layout | `crates/typst-library/src/layout/` |
| Math | `crates/typst-library/src/math/` |

## Using the `typst` CLI

The Typst CLI is installed at `~/.cargo/bin/typst` (version 0.15.1). Useful commands:

```bash
typst compile input.typ output.pdf     # Compile to PDF
typst compile input.typ output.html    # Compile to HTML (if enabled)
typst watch input.typ                  # Watch and recompile on changes
typst init my-project                  # Create new project
typst eval "1 + 1"                     # Evaluate inline Typst code
typst fonts                            # List discovered fonts
typst info                             # Debug information
```

### Important Environment Variables

| Variable | Purpose |
|----------|---------|
| `TYPST_PACKAGE_PATH` | Path to local package repositories (e.g., `$PWD/packages`) |
| `TYPST_CERT` | Custom CA certificate for HTTPS |
| `TYPST_FEATURES` | Enable experimental features |
| `TYPST_FONT_PATHS` | Custom font directories |
| `TYPST_IGNORE_SYSTEM_FONTS` | Ignore system fonts |
| `TYPST_PACKAGE_CACHE_PATH` | Custom package cache location |
| `TYPST_ROOT` | Override the project root |

## Common Patterns to Look For

### Library Function Signatures
Look for patterns like:
```typst
#my-function(param: value = default) -> return-type
```

### Show Rules
```typst
#show heading: it => ...
#set text(size: 12pt)
```

### Counter Manipulation
```typst
#counter(section).increment()
#counter(section).current()
```

### Import Patterns
```typst
#import "path/to/file.typ": named-items
#import "/src/lib.typ": package-internal
#import "std" from "typst"    // stdlib import
```

## Testing Typst Documentation Examples

When reading examples from the docs, you can test them in the current project:

```bash
export TYPST_PACKAGE_PATH=$PWD/packages

# Test a snippet inline:
typst eval '1 + 1'
typst eval '#heading("Hello")'

# Or create a temporary test file:
echo '#heading("Test")' | typst compile -
```

## Tips

1. **Start with the tutorial** — the 4-chapter tutorial (`content/tutorial/`) provides the best introduction
2. **Reference by function** — if you know a function name, check `content/reference/library/`
3. **Guides for specific tasks** — use `content/guides/` for in-depth how-tos (e.g., "for-latex-users.typ")
4. **Changelog** — `content/changelog/` has per-version changes
5. **Example markers** — Documentation uses `>>>` for compile-only lines and `<<<` for display-only lines in code blocks
6. **Cross-references** — Typst docs use `@label` syntax for internal references
