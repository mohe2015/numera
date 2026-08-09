# AGENTS Session Learnings

## Setup
- Repository root: `/home/runner/work/numera/numera`.
- This is a Typst package (`typst.toml`) with package entrypoint `lib.typ`.
- Primary local quality commands are:
  - `typst-package-check check`
  - `typstyle --check .`
  - `tt run`
- CI (`.github/workflows/typst-ci.yml`) installs `typstyle`, `tytanic`, and `typst-package-check`, then runs the same checks.

## Project structure
- `lib.typ`: main package implementation (`numera`) and helper exports used by consumers/tests.
- `README.md`: usage, examples, and development commands.
- `tests/`: regression-style Typst fixtures.
  - Each scenario has `test.typ` plus snapshot images under `ref/`.
  - Includes core examples (`example-*`), `equate` compatibility coverage, and reasoning/issue-specific cases.
- `.typstignore`: ignores generated/reference and local package paths during Typst operations.

## Practical notes from this session
- For quick orientation, start with `README.md`, then `typst.toml`, then `lib.typ`.
- Validation flow is straightforward: format check + package check + regression tests.
