---
name: lesson-planning
description: >-
  Author complete, build-ready lessons for a LaTeX-based curriculum project (one with a
  shared/ style package and a Makefile hierarchy that compiles components with latexmk
  and merges them with pdfunite). Use this whenever the user wants to create, draft, or
  build a lesson, a lesson plan, a unit, or any lesson component — warm-up, guided notes,
  activity, exit ticket, homework, cover sheet, or their answer keys. This project is the
  **Precalculus** course: `COURSE_PLAN.md` is the authoritative unit/lesson map, and the
  Precalculus CED in `spec/` drives each lesson's objectives and essential knowledge. Also
  use it to author unit-level tests and unit covers. Trigger this even when the user just
  says "make lesson 2.3" or "I need a warm-up and key for tomorrow," and even if they don't
  say the words "skill" or "LaTeX."
---

# Lesson Planning — Precalculus

This skill authors lessons for the **Precalculus** curriculum and produces print-ready PDFs
through the project's own build system. **It builds around the project's conventions — it does
not invent its own.**

The course at a glance:

- **Track is non-honors.** An honors precalculus course runs separately. This course's job is to
  cover the fundamentals thoroughly so a student moves comfortably into a *regular* college
  calculus course — depth over breadth. Scaffold accordingly.
- **Structure is 8 units × 8 lessons = 64 lessons**, plus a sample test per unit.
  **`COURSE_PLAN.md` is authoritative** for the unit/lesson map, each lesson's status, and which
  CED topic drives it. Read it before authoring; it does not mirror the CED 1:1.
- **Content source is the Precalculus CED** (the files in `spec/`, named `ap-precalculus-*.pdf`
  on disk). Lessons `COURSE_PLAN.md` marks **New** have no CED topic — they exist to slow the
  ramp for the non-honors track or to add calculus-readiness material.
- **The course is called "Precalculus" — never "AP Precalculus".** The College Board CED is the
  content backbone, but no course-facing text carries an AP prefix on the course name: not the
  cover, not a page header, not a lesson plan, not these docs. Other AP terminology is fine and
  should stay — "AP-style multiple choice", "AP Skill", "AP Exam weighting". The rule is about
  the *course name* only. The `spec/ap-precalculus-*.pdf` filenames stay as they are on disk.
- **Style prefix is `precalculus`** — `shared/precalculus-{colors,article,boxes,key,beamer}.sty`.
  The palette is **plum with gold accents**. A teacher **slide deck** is supported, and every
  lesson ships one.

## What a lesson is

A lesson lives in `unitXX/lessonYY/` and consists of:

- **`main.tex`** — the teacher-facing **lesson plan** (the root document of the lesson dir).
- A set of **student components**, each its own subdirectory containing **either** a `main.tex`
  (authored, compiled to a PDF) **or** a `main.pdf` (a prefab PDF, used as-is):
  `cover`, `warmup`, `notes`, `activity`, `exit_ticket`, `homework`, and optional `slides`.
- An **answer key** for each keyed component, as a *separate* sibling directory:
  `warmup_key`, `notes_key`, `activity_key`, `exit_ticket_key`, `homework_key`.
  (`cover` has no key.)

`shared/lesson.mk` discovers a component if it has a `main.tex` **or** a `main.pdf`, compiles
the `main.tex` ones with `latexmk -xelatex`, and builds **five work products** into
`target/compiled/unitXX/`:

| Product | What it is |
|---|---|
| `lessonYY_plan.pdf` | The teacher-facing lesson plan — the lesson-root `main.tex`, on its own. |
| `lessonYY_slides.pdf` | The Beamer deck **printed**: 3 slides per letter page, thumbnails down the left column and a ruled notes column beside each. |
| `lessonYY_slides.pptx` | The same deck wrapped for PowerPoint — one full-bleed page image per slide, the **projected** form. |
| `lessonYY_student.pdf` | `cover warmup notes activity exit_ticket homework` — the blank versions, in that pedagogical order. |
| `lessonYY_key.pdf` | The same packet with each component swapped for its `_key` (cover unchanged), in the same order. |

There is no combined "full" packet — the plan and the two slide products are separate teacher
artifacts, and the key packet is the student packet answered, **page for page**. A prefab
`main.pdf` is fed straight to `pdfunite` from the source tree with no compile step — so dropping
in a ready-made PDF is all that's needed (Step 5).

## What a unit is

A unit (`unitXX/`) holds its eight lessons plus **unit-level summative assessments**, scaffolded
automatically when the unit is first created (Step 3):

- **`tests/`** — the blank tests, one subdir each: **`practice_test/`** (a study copy students
  keep) and **`actual_test/`** (the real test given in a testing setting). Its `Makefile`
  (`include ../../shared/tests.mk`) compiles both, and its `drop` target publishes the
  *practice* test to `sample_test/main.pdf`.
- **`test_keys/`** — **`practice_test_key/`** and **`actual_test_key/`**, with
  `include ../../shared/test_keys.mk`; its `drop` publishes to `sample_test_key/main.pdf`.
- **`sample_test/`**, **`sample_test_key/`** — drop-in dirs. `shared/unit.mk` merges
  `sample_test` at the tail of the unit **student** packet and `sample_test_key` at the tail of
  the unit **key** packet. The *actual* test and its key are merged into nothing.
- **`unit_cover/`** — the unit packet's front matter, and optionally **`unit_cover_key/`**: the
  same page 1 (both wrappers `\input unit_cover/body.tex`, so they cannot drift) plus a page of
  **exam scoring notes**, merged into the **key packet only**. That page is where a unit test's
  answer rationale and extended-response scoring belong — never at the foot of a `*_test_key`,
  because the practice test is bound into the *student* packet and the rationale would ride
  along in front of students. A unit with no `unit_cover_key/` gets the plain cover in both.

The eight existing units predate the `body.tex` split: each has a single `unit_cover/main.tex`.
Adding a key cover to one means moving the sheet body into `unit_cover/body.tex` first.

## Multi-lesson dispatch — REQUIRED when generating more than one lesson

**When the request covers two or more lessons, do NOT author them sequentially.**
Spawn one subagent per lesson in a single message using the `Agent` tool, each briefed
with the lesson number, CED topic content, and a pointer to this skill. The coordinator
(this agent) pulls from upstream and gathers CED content first (Steps 0–2 below, once), then
fans out. The upstream pull happens **once, in the coordinator, before any subagent is spawned** —
subagents inherit the synced tree and must not run their own merge.

Pattern for a two-lesson request:

```
# Coordinator does once, FIRST — before reading or scaffolding anything:
git fetch origin && git merge --no-edit origin/main

# Coordinator does once, after the merge:
- detect prefix, read COURSE_PLAN.md, read one model lesson, extract CED topics for L7.4 and L7.5

# Coordinator scaffolds ALL lesson directories before spawning subagents:
python3 .claude/skills/lesson-planning/scripts/new_lesson.py --project . --unit 07 --lesson 04 --course "Precalculus" --title "..." --unit-title "..."
python3 .claude/skills/lesson-planning/scripts/new_lesson.py --project . --unit 07 --lesson 05 --course "Precalculus" --title "..." --unit-title "..."

# Then in ONE message, spawn two agents in parallel:
Agent(lesson=7.4, ced_content=..., model_lesson_path=...)
Agent(lesson=7.5, ced_content=..., model_lesson_path=...)

# Each subagent uses the Write tool only to fill in content (no Bash needed).
# Coordinator then builds and GATES both before opening the PR:
#   make -C unit07/lesson04 all && make -C unit07/lesson05 all
#   make -C unit07 check        ← one report covering every lesson in the unit
```

**Why the coordinator must scaffold:** Subagents run in a fresh permission context and
may not have auto-approved Bash access. Scaffolding requires running `python3 new_lesson.py`
(Bash). The coordinator always has this permission; subagents often do not. Scaffolding
first means subagents only need the Write tool to fill in content.

Each subagent receives: (a) the extracted CED content for its single lesson,
(b) the path of one model lesson to mirror, (c) the known-errors checklist below,
and (d) instructions to use Write tool only (coordinator handles build/verify). The
coordinator collects results, builds all lessons, verifies page counts, and opens one PR.

## Hard constraints — read before authoring a single line

These rules are non-negotiable. They recur every lesson if not followed.

### 1. One page: warmup and exit ticket

The warmup and exit ticket (blank AND key) must each fit on **exactly one printed page**.
Design to fit one page from the start — do not draft long and trim later.
Budget: `\pageheader` + `\namedateperiod` + content ≈ 3–4 questions max.

After building, verify before moving on:
```bash
pdftoppm -r 72 target/unitXX/lessonYY/warmup/main.pdf /tmp/wm \
  && ls /tmp/wm*.ppm | wc -l     # must print 1
pdftoppm -r 72 target/unitXX/lessonYY/exit_ticket/main.pdf /tmp/et \
  && ls /tmp/et*.ppm | wc -l     # must print 1
```
If either prints > 1: cut a question, rebuild, re-check. Do not continue until both return 1.
Same check for their keys.

### 2. No "sketch the…" questions

Never ask students to draw, sketch, or construct a graph freehand anywhere (warmup,
exit ticket, notes, activity, homework). Replace with: (a) a pre-drawn figure to
read/interpret, (b) a table to fill in, or (c) a computation question.

### 3. `\ans{}` is a TEXT-MODE macro — two hard rules

`\ans{text}` expands to `\textcolor{keyred}{\textbf{#1}}`. Its argument is text mode.

**Rule A — `\ans{}` must NEVER appear inside `$...$` or `\[...\]`.**
Close math first, call `\ans{}`, reopen math if needed.

```latex
% WRONG — causes compile error every time:
$SE = \dfrac{\ans{0.8}}{\sqrt{\ans{25}}}$

% RIGHT — close math, then \ans, then reopen:
$SE = \dfrac{s}{\sqrt{n}} = $ \ans{$0.8 / \sqrt{25} \approx 0.16$}

% ALSO RIGHT — in-formula filled slots use {\color{keyred}\mathbf{...}}:
$SE = \dfrac{{\color{keyred}\mathbf{0.8}}}{\sqrt{{\color{keyred}\mathbf{25}}}} \approx $ \ans{0.16}
```

**Rule B — Never put math-only commands bare inside `\ans{}`.**
`\sqrt`, `\dfrac`, `\hat`, `\overline`, `\ne`, `_`, `^` fail in text mode.
Wrap them in `$...$` inside `\ans{}`:

```latex
% WRONG:  \ans{\sqrt{n}}   \ans{s/\sqrt{n}}   \ans{\hat p}
% RIGHT:  \ans{$\sqrt{n}$} \ans{$s/\sqrt{n}$} \ans{$\hat p$}
```

After writing each key file, grep for `\\ans{` and confirm every hit is in text mode.

### 4. `fixedskillbox` does not exist — use `skillbox`

The only lesson-plan box environment is `skillbox`. `fixedskillbox` is not defined and
causes "Environment fixedskillbox undefined" every time.

```latex
% WRONG:  \begin{fixedskillbox}[...]{lilac}
% RIGHT:  \begin{skillbox}[...]{lilac}
```

After writing each lesson plan, grep for `fixedskillbox` and confirm zero hits.

### 5. Other known-bad patterns (do not use)

- `\ding{55}` — `pifont` not loaded; use `\textbf{$\times$}` instead
- bare `gold` color — use `goldbg` / `goldacc`
- `\usepackage{precalculus-boxes}` in a key file — keys use `precalculus-key` only (it includes boxes)
- `fixedskillbox` anywhere (see rule 4)
- `tierbox` — does not exist; use `tcolorbox` with `[colback=white, colframe=black!40, title=\textbf{Tier R --- ...}, fonttitle=\bfseries, arc=2mm, left=3mm, right=3mm, top=2mm, bottom=2mm]`

### 6. Only use colors defined in `shared/*-colors.sty`

Before using any color name in a box or tcolorbox, verify it is defined in the project's
color file (`shared/precalculus-colors.sty`). Never invent color names. Defined colors:

```
plum  plumlight  lilac  lilacmid  goldacc  goldbg  hookbg
greenbg  greenacc  redbg  redacc  charcoal  slate  linegray  keyred
goldbox  greenbox  redbox  plumbox
navy  navylight  sky  skymid          ← DEPRECATED aliases onto the plum ramp
```

**Use `plum`/`lilac` in new material.** `navy`, `navylight`, `sky`, and `skymid` still compile —
they are `\colorlet` aliases kept so older lessons keep building — but they name the wrong color
and must not appear in anything newly authored.

Any other name (e.g. `royal`, `burgundy`, `bluebox`, `purplebox`, `orangebox`, `gold`) is
**undefined** and will cause a compile error. When in doubt, `grep` the `.sty` file first.

## Workflow

Follow these steps in order. Read the referenced files as you reach each step rather than
all upfront.

### Step 0 — Pull from upstream (always do this first, before reading anything)

Lessons are authored in parallel branches and worktrees, so `shared/`, `COURSE_PLAN.md`, and the
conventions move underneath you between sessions. **Sync with `origin/main` before you read a
single file** — everything Step 1 detects (prefix, palette, macros, which lessons exist) is only
valid against the current tree.

```bash
git fetch origin
git status --short            # must be clean; commit or stash first if not
git merge --no-edit origin/main
```

Then:

- **Resolve any conflicts before authoring.** Never start writing lesson content on top of a
  half-merged tree.
- **Re-read `COURSE_PLAN.md` after the merge**, even if you read it earlier in the session — a
  lesson's title, topic mapping, or component list may have changed upstream.
- **Re-read the model lesson after the merge, not before.** Style-package changes (a renamed
  color, a new box environment, a convention retrofit) land on main constantly; a preamble copied
  from a pre-merge read is exactly how a lesson builds locally and breaks on main.
- If the merge brings in changes to `shared/*.sty`, delete stale build stamps before rebuilding:
  `find .stamps -name "*.stamp" -delete`.

If there is no `origin` remote, or the repo is detached from any upstream, say so and continue —
do not invent a remote.

### Step 1 — Detect project context

Never assume the prefix or conventions. Inspect the project **after the Step 0 merge**:

1. **Confirm the prefix.** `ls shared/*-colors.sty` → here it is `precalculus`. All
   `\usepackage{precalculus-article}` etc. must use it.
2. **Learn course-level macros.** Grep the shared styles and an existing lesson plan for
   `\CourseName`, `\MeetingLength`, `\UnitNumberName`, `\LessonNumberName`. Define in the new
   files only what isn't already provided.
3. **Choose the input path.** Look for College Board CED files in a `spec/` directory, named
   `ap-*.pdf` (the detailed `...course-and-exam-description.pdf`, the `...course-at-a-glance.pdf`,
   and supporting overview/poster files). If present → **CED path** (`references/ap-workflow.md`).
   If absent → **standards path** (`references/standards-workflow.md`).
   **In this course the CED does not map 1:1 to lessons.** `COURSE_PLAN.md` is the authoritative
   unit/lesson map (8 units × 8 lessons, non-honors); it names the CED topic that drives each
   lesson, and lessons marked **New** have no CED topic at all — those take the standards path.
   Read `COURSE_PLAN.md` for the target lesson before opening the CED.
4. **Find the insertion point.** List `unit*/lesson*` to determine the next unit/lesson
   number and whether the target lesson already exists.
5. **Read one built lesson as a model.** Open an existing **reauthored** lesson (per
   `COURSE_PLAN.md`'s status column) and mirror its preamble lines, box usage, and tone. Do not
   model on a lesson still marked **moved** — its body is pre-restructure content that has not
   been brought up to the conventions or the plum palette. Conventions are summarized in
   `references/conventions.md`, but the live project is the source of truth.

### Step 2 — Gather inputs

- **CED path:** read `COURSE_PLAN.md` for the lesson's row (title, focus, and the "CED n.m"
  topic that drives it), then extract that topic's Learning Objective → Essential Knowledge
  content from the CED, plus the governing Big Idea and Skill. See `references/ap-workflow.md`.
  Confirm the topic mapping with the user before authoring.
- **Standards path:** collect the lesson title, a short description, and the list of standards
  being addressed. See `references/standards-workflow.md`.

Either way, the lesson-plan *structure* is identical (`references/components.md` → "Lesson
plan"). A review or ramp-slowing lesson uses the same skeleton; it simply fills the Priority
Ideas & Skills with the prerequisite skills being re-activated and carries no CED tags.

### Step 3 — Scaffold the lesson directory

Run the scaffold script, which creates the directory, the one-line `Makefile`
(`include ../../shared/lesson.mk`), and the component subdirectories you request:

```bash
python3 ${CLAUDE_SKILL_DIR}/scripts/new_lesson.py --project . --unit 02 --lesson 03 \
  --title "Composition of Functions" --unit-title "Functions and Their Graphs" --course "Precalculus" \
  --components cover,warmup,notes,activity,exit_ticket,homework,slides
```

It also creates the root and unit `Makefile`s if they are missing, and — **when the unit is new**
— scaffolds that unit's `tests/`, `test_keys/`, `sample_test/`, and `sample_test_key/` (see "What
a unit is"). It never clobbers: re-scaffolding a later lesson leaves authored tests alone. Pass
`--no-tests` to skip, or `--tests` to force the test dirs into an existing unit.

The script is bundled with the skill, so it is invoked via `${CLAUDE_SKILL_DIR}` (the working
directory at runtime is the user's project, not the skill folder); `--project .` is the project
root you're working in.

It auto-detects the prefix and writes each authored component's `main.tex` as a correctly-
preambled skeleton (and the matching `_key` skeleton for keyed components). Pass `--prefab warmup`
to create that component as an empty drop-in directory instead, where you place the supplied
`main.pdf` (Step 5). Then fill in the skeletons.

### Step 4 — Author the lesson plan and components

Author each file following `references/components.md`, which gives the required section
structure and a worked skeleton for every component and its key. Hold to these invariants:

- **Student components** preamble with `\documentclass[10pt]{article}` +
  `\usepackage{<prefix>-article}` + `\usepackage{<prefix>-boxes}`.
- **Answer keys** are *separate files* that swap `-boxes` for `\usepackage{<prefix>-key}`
  and wrap every answer in `\ans{...}` (inline) or `\ansline{...}` (fills a write-line).
  Mirror the blank document exactly, then fill the blanks with `\ans`. There is **no**
  answer-key toggle — never try to build one.
- **Author to the five conventions from the start** (full spec in `references/conventions.md`):
  worked solutions go in byte-identical `\begin{work}` blocks in the blank and the key (the
  **work rule**); teacher prose goes in the lesson plan as `\begin{teachernote}[Component]`,
  never in a `_key`; components carry **no** name/date/period row (**namestrip** — the cover is
  the one place it belongs); a `vocabbox` intro sentence is followed by `\par\vspace{2pt}` before
  the first term (**vocabpar**); and `\boxguard` goes before any breakable box that would
  otherwise strand a stub, in the blank and the key both (**boxguard**).
- Use the project's box vocabulary (`skillbox`, `objectivebox`, `learningtargetbox`,
  `vocabbox`, `hookbox`, `notesbox`, `practicebox`, `scenariobox`, `tocbox`, etc.) and
  fill-in helpers (`\blank`, `\writeline`, `\writelines{n}`, `\termblanklong`) rather than
  reinventing layout. The full catalog is in `references/conventions.md`.
- **Never embed a warm-up thumbnail.** The spiral review section of the lesson plan is always
  text-only — list the prerequisite skills in words. Do not use
  `\includegraphics{warmup/main}` (or any other component PDF) in a lesson plan, whether the
  warm-up is authored or prefab. It couples the plan to build order and breaks the moment a
  prefab warm-up becomes an authored one.

### Step 5 — Handle prefab components

When the user supplies a ready-made PDF for a component (a pre-built warm-up, a publisher
worksheet), just drop it in — no wrapper needed:

1. Place the PDF as `<comp>/main.pdf` (e.g. `warmup/main.pdf`).
2. If the key is also a prefab PDF, place it as `<comp>_key/main.pdf`.

`shared/lesson.mk` discovers the component by its `main.pdf` and feeds it straight to `pdfunite`,
skipping compilation. Use `--prefab <comp>` when scaffolding to create the empty drop-in
directory. (This relies on the `lesson.mk` that supports prefab `main.pdf` discovery — if a
project's Makefile still only globs `main.tex`, update it first; see `references/build.md`.)

### Step 6 — Build

Build from the lesson directory (or the unit/root for wider packets):

```bash
make -C unit02/lesson03 all       # all five products
make -C unit02/lesson03 plan      # lessonYY_plan.pdf
make -C unit02/lesson03 slides    # lessonYY_slides.pdf (3-up with notes column)
make -C unit02/lesson03 pptx      # lessonYY_slides.pptx
make -C unit02/lesson03 student   # lessonYY_student.pdf
make -C unit02/lesson03 key       # lessonYY_key.pdf
```

Only the two packets aggregate upward: `make -C unit02 student|key` merges a unit, and
`make student|key` at the root merges the whole curriculum. `plan`, `slides`, and `pptx` stay
per-lesson in `target/compiled/unitXX/`. Output lands in `target/`. The build needs XeLaTeX,
`latexmk`, `pdfunite`/`pdfinfo`/`pdftoppm` (poppler), and `python3`; if a compile fails,
surface the `.log` and fix the offending `.tex` rather than editing the build system. Details
and troubleshooting in `references/build.md`.

### Step 7 — Gate it with `make check`

**`make all` exiting 0 does not mean the lesson is correct.** A LaTeX compile is perfectly happy
with a key that runs a page longer than its blank, a two-page exit ticket, and `\ans` buried in
math. `make check` is what turns those into failures:

```bash
make -C unit02/lesson03 check     # one lesson — builds first, then gates
make -C unit02 check              # every lesson in the unit, in one report
make check                        # the whole curriculum
```

It enforces page parity (every keyed component equals its `_key`), the one-page rule for the
warm-up and exit ticket on **both** sides, `\ans`/`\ansline` never inside math, no `teachernote`
in a component key, and no name row on a worksheet. It reports **every** violation in one pass
and exits 1, so it is the gate to run before opening a PR — not a smoke test. Implemented in
`shared/lesson_check.py`; full list in `references/conventions.md` ("The convention gate").

Source-only checks, no build required:

```bash
python3 shared/lesson_check.py unit02/lesson03 --no-pages
```

`check` supersedes the manual page-count comparison — but if you want it directly, the student
and key packets must report the **same page count**:

```bash
for f in target/compiled/unit02/lesson03_{student,key}.pdf; do pdfinfo "$f" | awk -v f="$f" '/^Pages/{print f, $2}'; done
```

**The gate does not walk `unitXX/tests/`.** A test blank legitimately keeps its name row, so the
checker skips it — that is a limit of the checker, not an exemption. A unit test key must still
carry no `teachernote` (scoring notes go on page 2 of `unitXX/unit_cover_key/`) and must still
paginate identically to its blank. Verify both by hand.

## Reviewing or revising a lesson — the five conventions, in order

The conventions landed **after** most of this course was authored, so any of the 64 existing
lessons can be behind on one. The user brings a lesson forward by name:

> `/lesson-planning apply boxguard namestrip retrofit to 6.1 and 6.3`

Apply **only the conventions named** — all five if none are named — to the lessons named.

**Whenever you review or revise a lesson, execute the conventions in this order:**

> **1. vocabpar → 2. teachernote → 3. namestrip → 4. work rule → 5. boxguard**

The first four each change how much vertical space a component takes; **boxguard runs last
because it repairs the pagination the other four disturb**. vocabpar leads because it makes
vocab boxes taller and can reverse a guard verdict measured before it. Re-measure after each
step — a "this guard costs a page" verdict is only valid for the box heights it was measured
against.

| # | Name | The rule | How to apply |
| --- | --- | --- | --- |
| 1 | **vocabpar** | `\par` before the first term in a `vocabbox`, so the intro sentence and the first term do not collide | Hand fix: `\par\vspace{2pt}` in `notes/main.tex` **and** `notes_key/main.tex` |
| 2 | **teachernote** | Teacher prose in the lesson plan, one titled note per component — never in a `_key` | `python3 .claude/skills/lesson-planning/scripts/movenotes.py unitNN/lessonMM` (`--check` to preview) |
| 3 | **namestrip** | Name/date/period row on the cover (and tests) only | `python3 .claude/skills/lesson-planning/scripts/namestrip.py --project . --unit NN --lesson MM` (`--check` to preview) |
| 4 | **work rule** | A component is the same length blank and keyed | `work` blocks authored byte-identically in both files; `\writelines{n}` only for prose `\ansline` drift |
| 5 | **boxguard** | No box stranded as a ~1in sliver across a page break | `\boxguard` (or `\boxguard[n]`) on its own line before the `\begin{...}` — blank **and** key |

Full spec for each: `references/conventions.md` ("The five conventions").

**There is no bulk sweep.** Retrofitting every lesson at once would re-flow the pagination of
all 64 lesson slots at once; do them lesson-by-lesson as they are reviewed.

**Always finish with the evidence**, per lesson: `make -C unitXX/lessonYY all` exits 0 **and**
`make -C unitXX/lessonYY check` passes — the latter is what proves every component's page count
equals its `_key`'s and the warm-up and exit ticket are still 1 page on both sides. Report any
violation the gate still reports and why.

## Reference files

- `references/conventions.md` — the style packages, every box environment, the fill-in and
  answer-key macros, color palette, per-document-type preambles, and **the five conventions**
  (vocabpar, teachernote, namestrip, work rule, boxguard). Read before authoring.
- `references/components.md` — section-by-section spec and a skeleton for the lesson plan and
  each component + key, plus the **unit tests** and the **unit cover pair**.
- `references/ap-workflow.md` — reading the Precalculus CED and mapping Mathematical Practice /
  LO / EK into the lesson. Pair it with `COURSE_PLAN.md`, which is authoritative for *which*
  CED topic drives a given lesson.
- `references/standards-workflow.md` — the title + description + standards path, used for the
  lessons `COURSE_PLAN.md` marks **New** (no CED topic).
- `references/build.md` — the Makefile hierarchy, scaffolding, prefab PDFs, build commands,
  the `check` gate, unit assessments, and troubleshooting.

## Guardrails

- **Pull from upstream first, every time.** `git fetch origin && git merge --no-edit origin/main`
  before reading the project, gathering inputs, or authoring — and re-read `COURSE_PLAN.md` and the
  model lesson after the merge. See Step 0.
- Detect, don't assume: prefix, course macros, and the AP-vs-standards path all come from
  inspecting the project (Step 1).
- Mirror an existing built lesson for tone and preamble; the live project overrides this doc.
- Keep blank and key documents in lockstep — the key is the blank with answers filled in.
- Don't modify `shared/` or the Makefiles to make a lesson build; fix the lesson's `.tex`.
- **Multi-lesson requests → parallel subagents.** See "Multi-lesson dispatch" above.
- **One-page warmup and exit ticket** — verify with `pdftoppm` after every build. See "Hard constraints" above.
- **`\ans{}` in text mode only; `skillbox` not `fixedskillbox`** — grep-check every file before building. See "Hard constraints" above.
- **When reviewing or revising a lesson, run the conventions in order:** vocabpar → teachernote →
  namestrip → work rule → boxguard. Boxguard is always last — it repairs the pagination the other
  four disturb. There is no bulk sweep; retrofit lesson-by-lesson.
