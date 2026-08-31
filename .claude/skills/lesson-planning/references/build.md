# Build System

The project compiles with **XeLaTeX** (via `latexmk`) and merges PDFs with **`pdfunite`**
(poppler). The skill authors `.tex`; the project's own Makefiles do the building. **Never edit
`shared/` or the Makefiles to make a lesson build — fix the lesson's `.tex` instead.**

## The three-level Make hierarchy

Each level is a thin `Makefile` that includes a `shared/*.mk`. The scaffolder creates all
three as needed (see "Scaffolding a lesson"), so you rarely write them by hand:

- **Root `Makefile`** (`include shared/root.mk`) — discovers `unit*/Makefile`, delegates, and
  merges unit PDFs into `target/compiled/curriculum_{student,key}.pdf`.
- **`unitXX/Makefile`** (`include ../shared/unit.mk`) — discovers `lesson*/Makefile`,
  delegates, and merges lesson PDFs into `target/compiled/unitXX_{student,key}.pdf`.
- **`lessonYY/Makefile`** (`include ../../shared/lesson.mk`) — the engine. It:
  - **Discovers a component if it has `main.tex` or `main.pdf`.** Authored components
    (`main.tex`) are compiled; prefab components (`main.pdf`) are used as-is from the source
    tree. A directory with neither is skipped.
  - Compiles each `<comp>/main.tex` with
    `latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error`,
    sending output to `target/UNIT/LESSON/<comp>/` and a stamp to `.stamps/`.

## The five lesson work products

Every lesson builds five files into `target/compiled/unitXX/`:

| Product | What it is |
|---|---|
| `lessonYY_plan.pdf` | The teacher-facing lesson plan — the lesson-root `main.tex`, on its own. |
| `lessonYY_slides.pdf` | The Beamer deck **printed**: 3 slides per letter page, thumbnails down the left column and a ruled notes column beside each. |
| `lessonYY_slides.pptx` | The same deck wrapped for PowerPoint — one full-bleed page image per slide, the **projected** form. |
| `lessonYY_student.pdf` | `cover warmup notes exit_ticket homework` — the blank versions, in that pedagogical order. (`activity` still merges between `notes` and `exit_ticket` on a lesson not yet reauthored.) |
| `lessonYY_key.pdf` | The same packet with each component swapped for its `_key` (cover unchanged), in the same order. |

There is **no `lessonYY_full.pdf`** — that combined plan + slides + keys packet is gone. The
plan and the slides are separate teacher artifacts, and the key packet is the student packet
answered.

Three passes make those products more than a `pdfunite` concatenation:

- **`shared/handout.tex`** re-frames the compiled deck into the 3-up printable. The deck is the
  source of truth — never edit the handout or the PPTX, edit `slides/main.tex` and rebuild.
- **`shared/pdf2pptx.py`** wraps the raw deck (not the 3-up handout) as OOXML. It is
  dependency-free — poppler only, which the build already needs. `PPTX_DPI` (default 300)
  trades file size against projected sharpness.
- **`shared/paginate.tex`** rebuilds each merged packet so page numbers run across the whole
  lesson, every component starts on an **odd (recto)** page, and the **student and key packets
  are page-for-page identical**: each component gets the same slot — `max(blank, key)` pages
  rounded up to even — with the shorter one padded by blank versos. Page 7 of the key is
  page 7 of the student packet.

Since the two packets are laid out against each other, `student` and `key` both compile every
component of *both* before merging — they stay aligned whether built together or separately.

A lesson with no `slides/` directory still builds the other products; `slides` and `pptx` just
print `(no slides in unitXX/lessonYY)`.

## Commands

```bash
make -C unitXX/lessonYY all       # all five products
make -C unitXX/lessonYY plan      # lessonYY_plan.pdf
make -C unitXX/lessonYY slides    # lessonYY_slides.pdf (3-up with notes column)
make -C unitXX/lessonYY pptx      # lessonYY_slides.pptx
make -C unitXX/lessonYY student   # lessonYY_student.pdf
make -C unitXX/lessonYY key       # lessonYY_key.pdf
make -C unitXX/lessonYY check     # convention gate — builds, then FAILS on a violation
make -C unitXX/lessonYY clean     # remove this lesson's target/ and stamps

make -C unitXX student|key        # merge a whole unit's packets
make -C unitXX check              # gate every lesson in the unit, in one report
make student|key                  # merge the whole curriculum (from project root)
make check                        # gate the whole curriculum
make clean | distclean            # clean everything (distclean also removes target/ and .stamps)
```

Only the two packets aggregate to unit and curriculum level; `plan`, `slides`, and `pptx` are
per-lesson teacher artifacts and stay in `target/compiled/unitXX/`.

**`check` is the gate `all` cannot be.** A LaTeX compile exits 0 on a key that runs a page longer
than its blank, a two-page exit ticket, or `\ans` buried in math — the failures that quietly cost a
student packet a padding page. `check` depends on the build stamps (the page checks read the
compiled *per-component* PDFs — the merged packets prove nothing, the pagination pass has already
padded them to match), reports every violation in one pass, and exits 1. Implemented in
`shared/lesson_check.py`; the full list of checks is in `references/conventions.md`
("The convention gate"). Run it after every build, before opening a PR.

Outputs land in `target/`: per-component PDFs under `target/UNIT/LESSON/<comp>/main.pdf`,
work products under `target/compiled/`.

Build order does not matter. Lesson plans never embed a component PDF (no warm-up thumbnails —
the spiral review is always text-only), so `plan` has no dependency on `student`, and the five
targets can be built in any order or individually.

## Verifying page counts

The one-page rule for the warm-up and exit ticket is checked on the **component** PDFs, not on
the paginated packet (which pads to even slots):

```bash
pdftoppm -r 72 target/unitXX/lessonYY/warmup/main.pdf /tmp/wm && ls /tmp/wm*.ppm | wc -l
```

For the packets, confirm the pairing instead — these two must be equal:

```bash
pdfinfo target/compiled/unitXX/lessonYY_student.pdf | grep Pages
pdfinfo target/compiled/unitXX/lessonYY_key.pdf | grep Pages
```

## Scaffolding a lesson

```bash
python3 ${CLAUDE_SKILL_DIR}/scripts/new_lesson.py --project . --unit 02 --lesson 03 \
  --title "Composition of Functions" --unit-title "Functions and Their Graphs" --course "Precalculus" \
  --components cover,warmup,notes,exit_ticket,homework,slides \
  [--prefab warmup,warmup_key] [--lesson-id 2.3]
```

It detects the prefix (`precalculus`) from `shared/*-colors.sty`. It writes the lesson
`Makefile`, the lesson plan, and each authored component + key skeleton — **and creates the root
`Makefile` and the unit `Makefile` if they don't already exist** (never clobbering them). Pass
`--prefab <dirs>` to create empty drop-in directories instead (where you place each `main.pdf`).
`slides` is in the default component list — every lesson ships a deck — and the scaffolder
requires `shared/precalculus-beamer.sty` for it, erroring clearly if it is missing; drop `slides`
from `--components` for a lesson that genuinely has none. Then author the skeletons
(`references/components.md`).

## Prefab PDFs

To include a ready-made PDF as a component, drop it in as `<comp>/main.pdf` (and
`<comp>_key/main.pdf` for a prefab key). `lesson.mk` discovers it and feeds it straight to
`pdfunite` — no `main.tex`, no compile step. `make clean` removes only `target/` and stamps, so
your source PDFs are never deleted. The lesson-root plan and `slides` may also be prefab PDFs.

## Unit assessments (tests)

Each unit carries summative assessments alongside its lessons, scaffolded automatically when
the unit is created:

- **`unitXX/tests/`** — `practice_test/main.tex` (student study copy) and `actual_test/main.tex`
  (real test), plus `Makefile` = `include ../../shared/tests.mk`.
- **`unitXX/test_keys/`** — `practice_test_key/main.tex` and `actual_test_key/main.tex`, plus
  `Makefile` = `include ../../shared/test_keys.mk`.
- **`unitXX/sample_test/`**, **`unitXX/sample_test_key/`** — drop-in dirs that receive published
  PDFs (initially empty, with a `.gitkeep`).

`shared/tests.mk`/`shared/test_keys.mk` compile every `*/main.tex` subdir, then a `drop` target
**publishes the practice test/key** to `sample_test/main.pdf` and `sample_test_key/main.pdf`.
`shared/unit.mk` then merges `sample_test` into the unit **student** packet and
`sample_test_key` into the unit **key** packet (falling back to `sample_test` if no key has been
published). The **actual** test/key are never merged.

A unit's optional cover is the other bookend `unit.mk` discovers: **`unitXX/unit_cover/`** goes
into the student packet, and **`unitXX/unit_cover_key/`** (same page 1 by `\input`, plus a page
of exam scoring notes) replaces it in the key packet. A unit with no `unit_cover_key/` gets the
plain cover in both. Both are compiled by `unit.mk` itself — there is no separate make target to
run first. See `components.md` ("Unit cover").

```bash
make -C unitXX/tests all         # compile practice + actual tests, publish sample_test/main.pdf
make -C unitXX/test_keys all     # compile both keys, publish sample_test_key/main.pdf
make -C unitXX key               # merges the published sample test key into the unit key packet
make -C unitXX/tests clean       # remove target/UNIT/tests
```

Build order matters: run `make -C unitXX/tests all` (and `test_keys all`) **before** the unit
packet, so the `sample_test` prefab exists when `unit.mk` merges it. Output lands in
`target/UNIT/tests/<name>/main.pdf` and `target/UNIT/test_keys/<name>/main.pdf`.

## Troubleshooting

`-file-line-error` makes errors report as `file:line: message`. Read the component's log at
`target/UNIT/LESSON/<comp>/main.log`. Common issues:

- **`File 'warmup/main' not found`** in the lesson plan → the plan is embedding a warm-up
  thumbnail, which this project does not use. Delete the `\includegraphics{warmup/main}` line
  and write the spiral review as text.
- **`Undefined control sequence \CourseName`** → the course macros aren't defined. Either the
  style package defines them or the lesson plan must; the scaffolder picks the right one, but a
  hand-edited plan may have dropped them.
- **`\includegraphics` fails for a screenshot** → put images in `images/` (the plan sets
  `\graphicspath{{images/}}`) and load `graphicx` (the plan does; `-article` does not).
- **Key won't compile / option clash** → a key loads `-key` only; do **not** also load
  `-boxes` (it's pulled in). Mirror the blank, swapping that one package line.
- **Garbled glyphs or font errors** → the build is XeLaTeX-only (it uses `unicode-math` /
  `fontspec`-style features); don't compile with `pdflatex`. `latexmk -xelatex` is set in
  `lesson.mk`.
- **`pdfunite: command not found`** → install poppler-utils.
- **A new component didn't appear in the packet** → its directory has neither `main.tex` nor
  `main.pdf`, or its name isn't in `STUDENT_ORDER`. Use the standard component names; the key
  packet is derived from that same list by swapping in each `_key` sibling.
- **`handout pass failed` / `pagination pass failed`** → the message names the log
  (`target/UNIT/LESSON/.handout/handout.log` or `.paginate/paginate.log`) and prints the first
  errors. Almost always an upstream problem: a deck or component PDF that failed to compile.
- **The key packet is longer than the student packet** → it shouldn't be; `paginate` pads both
  to the same slot per component. If they differ, a component is missing its `_key` sibling
  (it then appears blank in both) or a packet was merged from a stale `target/`.

If a fix seems to require changing `shared/` or a Makefile, stop and raise it — that's a
project-level refactor, not a per-lesson change.
