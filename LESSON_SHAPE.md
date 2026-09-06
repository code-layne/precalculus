---
course: Precalculus
prefix: precalculus
meeting_length: 60
reference_lesson: unit01/lesson01
components: [cover, warmup, notes, exit_ticket, slides]
keyed: [warmup, notes, exit_ticket]
one_page: [warmup, exit_ticket]
doc_titles:
  warmup: Warm-Up
  notes: Guided Notes
  exit_ticket: Exit Ticket
  homework: Homework
  activity: Group Activity
note_labels:
  warmup: Warm-Up
  notes: Guided Notes
  exit_ticket: Exit Ticket
  homework: Homework
  activity: Group Activity
skeletons: templates/lesson
unit_tests: true
structure_source: ced
spec_dir: spec
course_index: COURSE_PLAN.md
check_target: true
point_size: 10
---

# Lesson Shape — Precalculus

This is the course profile the shared `lesson-planning` skill (`~/.claude/skills/lesson-planning/`)
reads before authoring anything. The skill carries the mechanism — build, LaTeX rules, workflow,
scripts; **this file carries the policy** — everything true of this course that is not
necessarily true of the others. Keep it current: when a convention changes, change it here first.
The frontmatter is machine-read by the scaffolder; the sections below are read by the skill at
Step 0. The skeletons, the per-component spec (`components.md`), and the CED companion
(`course-workflow.md`) live in `templates/lesson/`.

**The course at a glance.** Non-honors Precalculus — an honors course runs separately. Its job is
to cover the fundamentals thoroughly so a student moves comfortably into a *regular* college
calculus course: **depth over breadth**, a context first, small numbers, one new idea at a time,
worked examples, gentler ramps than the CED implies. **8 units × 8 lessons = 64 lessons**, plus
a sample test per unit; 60-minute meetings. Units 1 and 2 number their lessons X.0–X.7 (the
`lesson00` directory is the unit opener); units 3–8 still number X.1–X.8 and adopt the X.0
opener as each is reauthored. **Every lesson ships a Beamer deck.**

## 1. The lesson shape

**Every new lesson follows traditional gradual release — I Do → We Do → You Do — not
experience-first.** A 60-minute period runs, in order:

> warm-up → hook → **I Do** (model) → **We Do** (guided) → **You Do** (independent)
> → **debrief** → exit ticket

| Phase | Minutes | Component |
| --- | --- | --- |
| Warm-Up — silent, individual spiral review | 5 | `warmup` |
| Hook — whole-class discussion | 2–3 | `hookbox` atop `notes`; scripted in the plan |
| **I Do** — teacher models, students watch and annotate | ~10 | `notes` §1 (and the first example of §2) |
| **We Do** — fill the notes together, every blank cold-called | ~18–22 | `notes` §2… |
| **You Do** — work alone while the teacher circulates | **11–14** | the notes' `practicebox` |
| Debrief — whole-class share-out and the headline | 5 | — (in the plan only) |
| Exit Ticket — individual, silent, collected | 5 | `exit_ticket` |

**The minutes must sum to exactly 60** — the value of `\MeetingLength`. The split above is the
skeleton's (5 / 3 / 10 / 18 / 14 / 5 / 5); the reference lesson runs 5 / 2 / 10 / 22 / 11 / 5 / 5
because four ideas share one block, and it *says so*. The split is the lesson's to choose; the
sum is not. Never pad the total to reach 60 — cut, and say in the box what you cut and what you
protected. **You Do gets real time** — 11–14 minutes, never the 5 it got when an activity sheet
competed for the period.

**`notes` — *Guided Notes* — is the in-class centrepiece and the whole release lives inside
it.** `\pageheader{Unit X, Lesson Y.Z}{Guided Notes}`; an `objectivebox` ("By the end of this
lesson, I will be able to…", one blank-bearing item per Learning Objective); a `vocabbox`
filled *as each term is defined*; a `hookbox` carrying the same hook as the plan with
write-lines; then `\S`-numbered `notesbox{n. Title}` sections — **these are the I Do and We Do**;
then the **`practicebox` — required, and it *is* the You Do**: 3–4 items that escalate, ending
with the one a finisher should still find hard (what a Tier E prompt used to be). Students work
it alone while the teacher circulates; the plan's Differentiation box says what the teacher does
at each item. The crux — the item that surfaces the lesson's target misconception — lives in
the practice box, and the plan names it in Key Understandings and again in Active Monitoring.

**`warmup`** — 3–5 quick problems of *prerequisite* spiral review, exactly one page, `work`
blocks for anything multi-step; may be a prefab PDF. **`exit_ticket`** — 2–3 items, no notes,
exactly one page; the one item that tests the day's central distinction is the diagnostic the
plan sorts tickets by. **`cover`** — full-bleed plum banner, `\namedateperiod` (the one place it
belongs), a `learningtargetbox` with one "I can…" per Learning Objective, the `tocbox` packet
table (§2), and optionally a `remindbox` that carries the lesson's *ideas*, never its process.
**`slides`** — the Beamer deck: title slide, hook, then frames that follow the release order
(I Do → We Do → You Do → debrief → exit ticket), hand-built on the bespoke `precalculus-beamer`
theme.

**Two phases are teacher-facing only.** The **hook** is scripted in the plan (and echoed by the
notes' `hookbox`); the **debrief** exists *only* in the plan — a `Debrief (N min)` box and a
`[Debrief]` teacher note. **There is no `debrief/` student component**; the student packet
closes with the exit ticket.

**What this course does not have — do not re-add any of it:**

- **No group activity.** Never scaffold or author `activity/`. The `\S` sections carry I Do
  and We Do; the practice box carries You Do. Tier R / A / E `tcolorbox`es belong to the old
  activity sheet — never reintroduce them inside a component. The build still merges an
  `activity/` where one exists, which is how the 62 lessons not yet reauthored keep building;
  that is backward compatibility, not a component to author.
- **No printed homework by default.** Homework is DeltaMath (§2). `homework/` exists only on a
  lesson the user has explicitly overridden.
- **No `debrief/` student component**, no `reflectionbox` at the end of the notes.
- **No tiered instruction on paper.** One document for the whole class; differentiation is
  where the teacher stands during You Do, specified in the plan.
- **No experience-first structure** (no `experience/`), no `ap_practice/`.

**`unit01/lesson01` is the reference implementation** (five lesson parts, the denser variant);
`unit01/lesson00` is the four-part variant. Mirror their preamble, box usage, pacing, and tone.
Never model on a lesson `COURSE_PLAN.md` still marks **moved** — its body is pre-restructure
content on the old palette. The live lesson overrides every document, this one included.

## 2. Grading and homework policy

**Three in-class components are scored on the cover** — Warm-Up, Guided Notes, Exit Ticket —
and close with an **In-Class Total** row. The exit ticket is **collected and graded for
completion** ("mistakes happen, blanks don't"); the plan's Individual Work & Assessment box names
the diagnostic item to sort tickets by and what to do about it in the next lesson's warm-up
window.

**Homework is DeltaMath.** Do not scaffold `homework/` unless asked. On a DeltaMath lesson:

- There is no `homework/` or `homework_key/` directory.
- The cover's `tocbox` lists the three in-class components (no Group Activity row), closes them
  with the In-Class Total, then carries a final DeltaMath row with three slots — assignment
  name, due date, and its own score:

  ```latex
  3 & Exit Ticket & ... & \blank{1.2cm} \\
  \midrule
    & \multicolumn{2}{r}{\textbf{In-Class Total}} & \blank{1.2cm} \\
  \midrule
  \rowcolor{lilac}
  4 & \textbf{Homework} & \textbf{DeltaMath} \quad Assignment: \blank{2.9cm} \quad Due: \blank{1.9cm} & \blank{1.2cm} \\
  ```

- The plan's Reinforcement & Extension box opens **`\textbf{Homework --- DeltaMath.}`** and
  states **target coverage** — the item *types* the set should hit — never numbered problems.
  Students record the assignment's name, due date, and score in the cover row.
- The last teacher note is `\begin{teachernote}[Homework --- DeltaMath]`, and it tells the
  teacher to read the DeltaMath report **by item type, not overall score**, naming which item
  type means the lesson missed.
- The due date is whatever the teacher writes in the cover's *Due* slot; this course has no
  fixed due-date rule to print.

**The paper-homework override.** Only when DeltaMath has no practice for the topic, and only
when the user asks for it: scaffold with `--components cover,warmup,notes,exit_ticket,homework,slides`,
author `homework/` + `homework_key/` per `templates/lesson/components.md` (a numbered practice
set, an `extensionbox`, a preview of the next lesson; keys mirror with `\ans`/`work`), make cover
row 4 an ordinary component row folded back above a plain **Total**, replace the DeltaMath
paragraph in Reinforcement & Extension with a printed-homework overview, and title the last
teacher note `[Homework]`.

## 3. Where structure comes from

`structure_source` is **`ced`** — the College Board Precalculus CED in `spec/`
(`ap-precalculus-course-and-exam-description.pdf`, `...course-at-a-glance.pdf`,
`...ced-clarification-and-guidance.pdf`) supplies each lesson's Learning Objectives and
Essential Knowledge — **but the CED is not the lesson map.** The CED has 4 units; this course
has 8 × 8, and **`COURSE_PLAN.md` is authoritative** for the unit/lesson map, each lesson's
status (*moved* / *new* / *authored*), and the **"CED n.m"** topic that drives it. Read the
lesson's row there *before* opening the CED; the lesson title is the one in `COURSE_PLAN.md`,
not the CED topic's. A CED topic often spans more than one lesson here, and some lessons absorb
two topics — confirm the granularity with the user before authoring.

**Lessons `COURSE_PLAN.md` marks *New* have no CED topic** — they slow the ramp or add
calculus-readiness material. Author those through the shared `references/standards-workflow.md`,
with the prerequisite skills being re-activated as the "standards" and the plan's focus column
as the starting point; same skeleton, no CED tags.

**The course is called "Precalculus" — never "AP Precalculus".** No course-facing text carries
an AP prefix on the course *name*: not the cover, not a page header, not a plan, not the deck.
Other AP terminology stays — "AP-style multiple choice", "AP Skill 2.B", "AP Exam weighting".
The `spec/ap-precalculus-*.pdf` filenames stay as they are on disk.

**The framework has no Big Ideas.** Its cross-cutting dimension is the three Mathematical
Practices, written in plans as **`AP Skill x.y`** (e.g. `\textbf{AP Skill 2.B} --- Construct
equivalent representations`). Codes are flat and topic-based — LO `1.4.A`, EK `1.4.A.5` — and
the leading digit is the *CED* unit, not this course's; record codes as written. The full
Practice table, the extraction steps, and the mapping table are in
`templates/lesson/course-workflow.md`.

**`COURSE_PLAN.md` is the `course_index`.** After authoring or reauthoring a lesson, update its
row: status → *authored*, title if it changed, and the CED source if the mapping moved. Trust
the live `unit*/lesson*` directories for what exists; `COURSE_BREAKDOWN.md` is a generated
snapshot (2026-08-06) of titles as compiled, kept for reference, not maintained by hand.

## 4. Style notes

- **Prefix `precalculus`** — `shared/precalculus-{colors,article,boxes,key,beamer}.sty`.
- **Course macros live inline in the lesson plan, not in the style package.** Every plan defines
  `\newcommand{\CourseName}{Precalculus}` and `\newcommand{\MeetingLength}{60 minutes}` (plus
  `\UnitNumberName`, `\LessonNumberName`) in its own preamble. The scaffolder detects that
  `shared/` lacks them and inlines them from this profile's `course` and `meeting_length`.
  `\CourseName` is not defined in beamer either — the deck writes "Precalculus" literally — and
  `\pageheader` prints "Precalculus" itself. No school year, no teacher name, in any title block.
- **`point_size` is 10 — every document in this course is 10pt**, student components and keys
  included (`\documentclass[10pt]{article}`), not the 12pt most sibling courses use. The
  skeletons carry `10pt` literally; match them and the reference lesson, and do not "fix" a
  component to 12pt. Sizing rules of thumb quoted at 12pt elsewhere run smaller here — measure
  on the compiled PDF.
- **Palette — plum with gold accents.** Defined: `plum plumlight lilac lilacmid goldacc goldbg
  hookbg greenbg greenacc redbg redacc charcoal slate linegray keyred` plus the lesson-plan
  aliases `goldbox greenbox redbox plumbox`. **Use `plum`/`lilac` in new material.** `navy`,
  `navylight`, `sky`, `skymid` still compile — `\colorlet` aliases onto the plum ramp kept so
  older lessons build — but they name the wrong colour and must not appear in anything newly
  authored (retire them when a lesson is reauthored). Bare `gold`, `royal`, `burgundy`,
  `bluebox`, `purplebox`, `orangebox` are **undefined**. The beamer theme redefines `goldacc` and
  `hookbg` to its own brighter values; that is intended.
- **`fixedskillbox` exists in `precalculus-boxes` and is banned.** It is unbreakable, so a long
  box silently overflows the page. `skillbox` for every lesson-plan box; grep `fixedskillbox`
  for zero hits before building. Where a phase table must stay intact, `\boxguard[22]` before
  the `skillbox` (the Lesson Flow box) or `\boxguard[20]` (the Debrief box).
- **`tierbox` does not exist**, and there is no tiering on paper — drop the concept.
- **`practicebox` takes no argument and its title is fixed as "Individual Practice"** — it is the
  You Do, not a "Guided Practice" as in the statistics course. A titled box is `notesbox{Title}`.
  Other boxes: `objectivebox`, `learningtargetbox`, `vocabbox`, `hookbox`, `spiralbox`,
  `scenariobox[Title]{color}`, `headlinebox{color}`, `blurbbox[Title]{color}`, `reflectionbox`,
  `extensionbox`, `tocbox`, `remindbox`, `skillbox[Title]{color}`.
- **Vocabulary rows.** `\termblank` and `\termblanklong` exist in `-article`, but **`\termans`,
  `\vocabans`, and `\answerspace` do not exist in this course** — the shared skill's
  `\termblank ↔ \termans` and `\answerspace{H}{}` mechanisms are unavailable here. The reference
  lesson hand-rolls each row as `\noindent\textbf{\textcolor{plum}{Term:}}\\[1pt]\writeline\\[3pt]`
  in the blank, mirrored by `\ansline{definition}` in the key with the definition short enough
  not to wrap; a `\termblanklong{Term}` (two write-lines) is mirrored by the term line plus two
  `\ansline`s. Prose answers use `\writelines{n}` ↔ *n* `\ansline{}`, sized from the key's true
  wrapped length; `\writelines{n}` occupies n+1 line slots. A `vocabbox` intro sentence ends
  with `\par\vspace{2pt}` in **both** files (vocabpar) — `\termblanklong` opens with a
  `\noindent` that is a no-op mid-paragraph, so without the `\par` the sentence and the first
  term collide. Fix it per lesson, never in `shared/`.
- `\componenttablekey` exists in `-key` (a statistics leftover) with no blank counterpart; do
  not use it.
- `\ding{55}` — `pifont` is not loaded; use `\textbf{$\times$}`.
- `\TallMath{...}` (tall inline math) is defined per document in the preamble; the skeletons
  carry it.
- The cover loads `ltablex` + `\keepXColumns`; the plan loads `graphicx` +
  `\graphicspath{{images/}}` (`-article` loads neither). Desmos screenshots go in `images/`.
- **Never embed a warm-up thumbnail in the plan.** The spiral-review box is text only — list the
  prerequisite skills in words — whether the warm-up is authored or prefab. The course's
  `lesson_plan.tex` skeleton deliberately carries no `@@SPIRALWARMUP@@` token, so the shared
  scaffolder cannot insert one; do not add `\includegraphics{warmup/main}` by hand.
- **Deck** — `\documentclass[aspectratio=169, 11pt]{beamer}` + `precalculus-beamer`; content
  frames use `\plumheader{Title}` (not `\navyheader`) and `\sectionlabel[color]{LABEL}`; the
  title slide is hand-built on a `plum` background canvas with a minipage.
- `\boxguard` (default 16 lines) and `teachernote` (optional title argument) are in `-boxes`, so
  they reach keys through `-key` and the plan through `-boxes`; a bare `\begin{teachernote}`
  still compiles, which is how un-migrated keys keep building.
- `\namedateperiod` on the cover and the unit tests only; `\namepartnerperiod` is not used.

## 5. Lesson-plan section order

Title block (`\CourseName` over `\UnitNumberName \LessonNumberName`; no school year) →
**Primary Objective** (a `tcolorbox` `colback=lilac, colframe=plum`; the CED LOs restated as
student-facing aims; a New lesson adds *"(Foundations ramp --- no CED topic)"*) →
**Lesson Flow — Gradual Release (60 minutes)** (`\boxguard[22]` + `skillbox{lilac}`; the
seven-row Phase / Min / what-students-are-doing `tabularx`, **no Group Activity row, Min summing
to exactly 60**; closing *"If the clock slips"* paragraph naming what to cut first and what to
protect — this box sits *above* Priority Ideas so the clock is the second thing the teacher
reads) → **Priority Ideas & Skills** (`skillbox{goldbox}`; left `\textbf{AP Skill x.y} --- …`,
right Key Understandings paraphrased from the EKs, the target misconception named) →
**Vocabulary, Concepts & Theorems** (`skillbox{greenbox}`, term/definition `tabularx`) →
**Activate Prior Knowledge & Spiral Review (5 min)** (`skillbox{lilac}`, text only) →
**Hook (N min)** (`skillbox{lilac}`) → **Lesson — I Do / We Do / You Do** (`skillbox{lilac}`
with `multicols{2}`, titled exactly so — not plain `Lesson`; four or five parts, each opening
`\textbf{I DO --- Part 1: Title} (8 min)` then a required italic line naming the notes section
it covers **and who is holding the pen** — I Do: *"Teacher works; students watch and annotate.
Nothing is cold-called in this phase."* · We Do: *"Class fills the blanks together; cold-call
every one."* · You Do: *"Students work alone; circulate and say nothing a neighbor could say
instead."* A part without that line is not tagged; part minutes must agree with the flow table)
→ **Explicit Instruction: <technique>** (optional, one `skillbox{lilac}` per technique: numbered
steps left, worked example right) → **Active Monitoring** (`skillbox{redbox}`; opens
*"Circulate during the You Do phase"*; common errors + cold-call prompts) →
**Differentiation — During You Do (N min)** (`skillbox{redbox}`, N = the You Do row; **Support /
On level / Extend** as moves the teacher makes while circulating the practice box — which item
to sit beside a struggling student for, what the class should clear unaided, the question to
hand a finisher; a former Tier E prompt worth keeping becomes the *last practice item*; no
Tier R/A/E language) → **Debrief (N min)** (`\boxguard[20]` + `skillbox{redbox}`, **between**
Differentiation and Individual Work; three timed moves as an `enumerate` — *share out the You Do*
(one answer per practice item, not a full review), *name the headline* (the day's central
sentence in italics, said by the teacher and echoed back, immediately before the exit ticket asks
for it in writing), *point forward* (or read a read-only notes section aloud here) — then a
`\textbf{Do not}` line: no re-teaching, no new questions, no starting the exit ticket early) →
**Individual Work & Assessment (5 min)** (`skillbox{redbox}`; the exit-ticket items + an
assessment note naming the diagnostic item) → **Reinforcement & Extension** (`skillbox{goldbox}`;
`\textbf{Homework --- DeltaMath.}` + target coverage by item type; `\textbf{Extension (optional):}`;
`\textbf{Preview:}` of the next lesson) → **Teacher notes, five, in packet order:**
`[Warm-Up]`, `[Guided Notes]`, `[Debrief]`, `[Exit Ticket]`, `[Homework --- DeltaMath]`.

The Debrief note says why those minutes are worth protecting and what to borrow from instead
when the guided phase overruns; the Homework note reads the DeltaMath report by item type. The
Debrief note has no component behind it, so `note_labels` does not list it — write it by hand.
On a paper-homework override, and on a legacy lesson migrated with `movenotes.py`, the last note
is titled `[Homework]`. The `Differentiation — During You Do` box **replaced** the old
`Group Work & Differentiation` box; never write the old one.

## 6. Unit-level assessments

A unit holds `tests/` (`practice_test/`, `actual_test/`; `include ../../shared/tests.mk`; its
`drop` publishes the *practice* test to `sample_test/main.pdf`), `test_keys/`
(`practice_test_key/`, `actual_test_key/`; likewise, to `sample_test_key/main.pdf`), the two
`sample_test*` drop-in dirs (merged by `shared/unit.mk` at the tail of the unit student / key
packets), and **`unit_cover/`** at the front. The scaffolder creates all of this the first time
a unit is created; **today only `unit01` carries the test directories** — units 2–8 have a
`unit_cover/` and nothing else, and get their tests via `new_lesson.py --tests` when authored.

- **Tests keep `\namedateperiod`** — taken in a testing setting, not stapled behind a cover.
  `\pageheader{Unit X: <Title>}{...}`, `\parthead{Part …}` sections (vocabulary, multiple
  choice, short answer/computation, extended response). Practice and actual versions are
  **parallel** — same format, parts, and difficulty, different numbers and contexts. The
  actual test and its key are never merged into any packet.
- **A test key carries no `teachernote`.** Answer rationale and extended-response scoring go on
  **page 2 of `unitXX/unit_cover_key/main.tex`**, which reaches the key packet only. The
  practice test and its key must be the same number of pages — check by hand, because
  **`make check` does not walk `unitXX/tests/`** (a test blank legitimately keeps its name row).
- **`unit_cover/` + `unit_cover_key/`**: the sheet lives in `unit_cover/body.tex`; both wrappers
  `\input` it, so page 1 cannot drift. Page 1 is student-facing (plum banner, unit overview
  box, lessons table in a `skillbox{goldbox}`, standards table in a `skillbox{greenbox}`);
  page 2 (key only) is the scoring notes. **Only `unit01` is split**; units 2–8 still have a
  single `unit_cover/main.tex` and no `body.tex` — to add a key cover, move the body out first.
  `unit01/unit_cover*` is the worked example.
- Build: `make -C unitXX/tests all && make -C unitXX/test_keys all` **before** `make -C unitXX
  student|key`, so the published sample test exists when `unit.mk` merges it.

There is no course-wide final in this repository.

## 7. Legacy shapes and regeneration

Recognize the shape by the component directories and the plan's boxes:

| Shape | Has | Where |
| --- | --- | --- |
| **current** (gradual release, 2026-08) | `notes/` + `exit_ticket/`, **no** `activity/`, **no** `homework/`; plan opens with the Lesson Flow box | `unit01/lesson00`, `unit01/lesson01` |
| **group-activity, convention-compliant** | `activity/` + `homework/` present; plan has a plain `Lesson` box and `Group Work \& Differentiation`; plum palette; the five conventions applied (`COURSE_PLAN.md`: *authored*) | `unit01/lesson02`–`07`, `unit02/lesson00`–`07` |
| **moved / pre-restructure** | the same directories, but the body is the old AP-paced lesson: cross-references in the *old* numbering, `navy`/`sky` colours, teacher notes still in the `_key` files, name rows on every component, Tier R/A/E boxes on the activity sheet, no `work` blocks, no `\boxguard`, sometimes no deck (`COURSE_PLAN.md`: *moved* or *new*) | units 03–08 |

The build accepts all of them. When asked to touch one, **ask whether to regenerate it** in the
current shape. Reauthoring happens **lesson by lesson — there is no bulk sweep**; a project-wide
pass would re-flow the pagination of every verified lesson at once.

**Converting a lesson to the current shape:**

1. Sync, then read its `COURSE_PLAN.md` row. For a **moved** lesson, reauthor the *scope* first:
   the new-numbering cross-references, any absorbed neighbour's ideas at reduced depth (the
   condensation record at the bottom of `COURSE_PLAN.md`; content is in git history), non-honors
   pacing. Convert to the plum palette as you go.
2. **Fold the activity into the notes.** Its scenario and crux become the later `\S` sections
   (the We Do); its items become the `practicebox` — 3–4 escalating, the former Tier E prompt
   last so every student sees it. Then `git rm -r activity activity_key`.
3. **Homework → DeltaMath.** `git rm -r homework homework_key` (unless the user overrides for
   this lesson); the cover's `tocbox` becomes three rows + In-Class Total + the DeltaMath row.
4. **Rewrite the plan** in the §5 order: insert the Lesson Flow box (sum 60, no activity row),
   retitle the Lesson box and tag every part with its phase and pen line, replace
   `Group Work \& Differentiation` with `Differentiation --- During You Do`, insert the Debrief
   box between it and Individual Work, rewrite Reinforcement & Extension around DeltaMath, and
   re-cut the teacher notes to the five (any note still in a `_key` moves first —
   `movenotes.py`).
5. **Cover**: learning targets one per LO in the formal vocabulary; packet table per §2;
   `\namedateperiod` stays here and nowhere else (`namestrip.py`).
6. **Deck**: author one if the lesson has none (15 do not); otherwise reorder it to
   hook → I Do → We Do → You Do → debrief → exit ticket.
7. **Apply the five conventions in the §8 order**, then delete stale stamps —
   `rm -rf .stamps/unitXX/lessonYY target/unitXX/lessonYY` — `make -C unitXX/lessonYY all`,
   `make -C unitXX/lessonYY check`, and update the lesson's `COURSE_PLAN.md` row.

Finish with the evidence per lesson: `make all` exits 0, `make check` passes (page parity, the
one-page warm-up and exit ticket on both sides, `\ans` placement, no key-side notes, namestrip),
and every component's page count equals its `_key`'s on the compiled components, not the padded
packets.

**Scoreboard (2026-09):** 2 of 64 lessons are in the current shape (`unit01/lesson00`,
`lesson01`); 14 are convention-compliant group-activity lessons (`unit01/lesson02`–`07`,
`unit02/lesson00`–`07`); 48 are moved / pre-restructure (units 03–08). Across the tree: 61
plans still carry a `Group Work \& Differentiation` box, 117 `_key` files still hold teacher
notes and 324 component files still carry a name row (all in units 03–08), 53 activity sheets
use Tier R/A/E boxes, 205 files still use the deprecated `navy`/`sky` names, and 15 lessons have
no deck (`unit03/lesson06`–`08`, `unit04/lesson05`, `08`, `unit05/lesson05`, `unit06/lesson02`,
all of `unit08`).

## 8. Review order

When reviewing or revising a lesson, execute the conventions in this order, and re-measure after
each step rather than trusting a verdict recorded against earlier box heights:

> **1. vocabpar → 2. teachernote → 3. namestrip → 4. work rule → 5. boxguard**

The first four each change how much vertical space a component takes; **boxguard runs last
because it repairs the pagination the other four disturb**. vocabpar leads because it makes
vocab boxes taller and can reverse a guard verdict measured before it; teachernote and namestrip
both *remove* material (namestrip is not always free — reclaimed space can let the key fit a box
the blank still pushes, a mismatch boxguard then closes); the work rule re-matches blank to key
once the lengths have settled. A regeneration runs **shape → deck** first (§7), then the five.
Apply only the conventions named — all five if none are — and finish with `make -C unitXX/lessonYY
all && make -C unitXX/lessonYY check`, reporting any violation the gate still shows and why.
