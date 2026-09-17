---
course: Precalculus
prefix: precalculus
meeting_length: 60
reference_lesson: unit01/lesson01
components: [cover, warmup, notes, ap_practice, homework, slides]
keyed: [warmup, notes, ap_practice, homework]
one_page: [warmup]
doc_titles:
  warmup: Warm-Up
  notes: Guided Notes
  ap_practice: AP Practice
  homework: Homework
  exit_ticket: Exit Ticket
  activity: Group Activity
note_labels:
  warmup: Warm-Up
  notes: Guided Notes
  ap_practice: AP Practice
  homework: Homework
  exit_ticket: Exit Ticket
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
worked examples, gentler ramps than the CED implies. 8 units, a sample test per unit, 60-minute
meetings. **Unit 1 numbers its lessons 1.1 onward and is no longer fixed at eight** — its
opener was retired in the September 2026 replan and further lessons are expected; see
`COURSE_PLAN.md`, which is authoritative for the lesson map. Unit 2 numbers its lessons 2.0–2.7
(the `lesson00` directory is its unit opener); units 3–8 still number X.1–X.8. **Every lesson ships a Beamer deck.**

## 1. The lesson shape

**Every new lesson follows traditional gradual release — I Do → We Do → You Do — not
experience-first.** A 60-minute period runs, in order:

> warm-up → hook → **I Do** (model) → **We Do** (guided) → **You Do** (independent)
> → **debrief** → homework launch

| Phase | Minutes | Component |
| --- | --- | --- |
| Warm-Up — silent, individual spiral review | 5 | `warmup` |
| Hook — whole-class discussion | 2–3 | `hookbox` atop `notes`; scripted in the plan |
| **I Do** — teacher models, students watch and annotate | ~10 | `notes` — each row's definition, its display, its first problem |
| **We Do** — fill the notes together, every blank cold-called | ~18–22 | `notes` — the rest of each row's grid |
| **You Do** — work alone while the teacher circulates | **11–14** | the notes' last row |
| Debrief — whole-class share-out and the headline | 5 | — (in the plan only) |
| Homework Launch — start named homework problems alone; teacher circulates | 3 | `homework` |

**The minutes must sum to exactly 60** — the value of `\MeetingLength`. The split above is the
skeleton's (5 / 3 / 10 / 20 / 14 / 5 / 3); the reference lesson runs 5 / 2 / 10 / 22 / 13 / 5 / 3
because four ideas share one block, and it *says so*. The split is the lesson's to choose; the
sum is not. Never pad the total to reach 60 — cut, and say in the box what you cut and what you
protected. **You Do gets real time** — 11–14 minutes, never the 5 it got when an activity sheet
competed for the period. **The Homework Launch is never cut to zero** — with no exit ticket it is
the period's last formative read.

**`notes` — *Guided Notes* — is the in-class centrepiece (2026-09-12 shape, ported
from AP Statistics).** `\pageheader{…}` → `vocabbox` (`\termblanklong` rows, filled *as each term is
named*) → `hookbox` (the same hook as the plan, with write-lines) → **one two-column *Main Ideas / Questions* | *Notes* table**
(`guidednotes` in `precalculus-boxes.sty`), 3–4 pages at 10pt. **There is no `objectivebox`** — the
cover carries the targets. Each **row** is one idea on the one worked context: a short label on
the left (`\mainidea[lead]{Label}`); on the right one or two **complete printed sentences** (the
definition or the general form, read — never a sentence with words punched out), **one large
pre-drawn display** (a graph, a table, the two things students conflate side by side) the
student reads or annotates with `\labelbox`, then a bold prompt and a **two-across grid of a few
numbered problems** (`probgrid` + `\pcell`, **2–3 cm of work room each**, algebra in `work`
blocks); a procedure uses `\stepnum{n}`, the sentence to land an *In your own words*
`\writespace`. Three or four instruction rows — the last carries the **target misconception as
problems**, the case where the two answers *disagree* — then the **You Do row — required**: `\mainidea[You do, alone]{Title}`, 3–4 problems that escalate, ending with the one a finisher should still find hard, worked alone for the 11–14 minutes the flow table gives while the teacher circulates; the plan's Differentiation box says what the teacher does at each problem, and Active Monitoring names the crux and its You Do transfer by number. **Density rules:** a `\blank{}` only where a single word or number *is* the answer (a table to fill, a display to name), never mid-sentence, a handful per lesson; 12–19 problems, two across, never three; every row a picture; the plan names, by problem number, which problems the teacher works, which is the trap, which is the crux. **The instruction rows are the I Do and We Do** — the teacher reads the definition, marks up the display and works the first problem of each grid; the class works the rest, every one cold-called.
Lessons authored before 2026-09-12 use the boxed notes (`notesbox` sections + `practicebox`);
convert them by the recipe in `templates/lesson/components.md` when you touch them.

**`warmup`** — 3–5 quick problems of *prerequisite* spiral review, exactly one page, `work`
blocks for anything multi-step; may be a prefab PDF. **`ap_practice`** (2026-09-16) — **extra
credit, optional, exactly two pages**: page 1 is *Section I*, five AP Precalculus–style
multiple-choice items with four options (A)–(D), distractors built from the lesson's real
errors; page 2 is *Section II*, one multi-part free-response question on a table or graph with
interpret-in-context parts, the last part the finisher's stretch. Contexts used nowhere else in
the lesson. **`homework`** (2026-09-16) — **printed, graded, exactly two pages**, last in the
packet: 8–12 numbered problems in titled parts (`headlinebox{lilac}`), every context new (the
notes teach, the You Do transfers, the homework transfers again); one item is the **diagnostic**
the plan's Homework Launch names, one asks for the day's headline in writing, and a closing
`spiralbox` previews the next lesson. **`cover`** — full-bleed plum banner, `\namedateperiod` (the one place it
belongs), a `learningtargetbox` with one "I can…" per Learning Objective, the `tocbox` packet
table (§2), and optionally a `remindbox` that carries the lesson's *ideas*, never its process.
**`slides`** — the Beamer deck: title slide, hook, then frames that follow the release order
(I Do → We Do → You Do → debrief → homework launch), hand-built on the bespoke `precalculus-beamer`
theme.

**Two phases are teacher-facing only.** The **hook** is scripted in the plan (and echoed by the
notes' `hookbox`); the **debrief** exists *only* in the plan — a `Debrief (N min)` box and a
`[Debrief]` teacher note. **There is no `debrief/` student component**; the student packet
closes with the homework.

**What this course does not have — do not re-add any of it:**

- **No group activity.** Never scaffold or author `activity/`. The `\S` sections carry I Do
  and We Do; the practice box carries You Do. Tier R / A / E `tcolorbox`es belong to the old
  activity sheet — never reintroduce them inside a component. The build still merges an
  `activity/` where one exists, which is how the 62 lessons not yet reauthored keep building;
  that is backward compatibility, not a component to author.
- **No exit ticket** (retired 2026-09-16). Never scaffold `exit_ticket/`. The formative read
  comes from circulating the You Do and the Homework Launch. The build still merges an
  `exit_ticket/` where one exists, for lessons not yet reauthored.
- **No DeltaMath by default** (retired 2026-09-16). Homework is the printed `homework/`
  component, authored for every lesson; DeltaMath is only a per-lesson override the user asks
  for (§2).
- **No `debrief/` student component**, no `reflectionbox` at the end of the notes.
- **No tiered instruction on paper.** One document for the whole class; differentiation is
  where the teacher stands during You Do, specified in the plan.
- **No experience-first structure** (no `experience/`).

**`unit01/lesson01` is the reference implementation** (five lesson parts, the denser variant).
Mirror its preamble, box usage, pacing, and tone.
Never model on a lesson `COURSE_PLAN.md` still marks **moved** — its body is pre-restructure
content on the old palette. The live lesson overrides every document, this one included.

## 2. Grading and homework policy

**Two in-class components are scored on the cover** — Warm-Up and Guided Notes. Then:

- **`ap_practice` — extra credit.** Optional; its cover row is shaded `goldbg`, labelled
  **Extra credit**, and its score cell is `$+$\,\blank{1.0cm}` — outside the total. The plan
  names the multiple-choice answers and what each distractor means in its `[AP Practice]` note.
- **`homework` — graded, printed, last in the packet.** Its cover row carries a *Due:* slot
  (the teacher sets the date; this course prints no due-date rule) and a score blank. Students
  start named problems in the 3-minute Homework Launch.

The cover's packet table:

```latex
1 & Warm-Up      & ... & \blank{1.2cm} \\
2 & Guided Notes & ... & \blank{1.2cm} \\
\rowcolor{goldbg}
3 & AP Practice  & \textbf{Extra credit} --- AP-style multiple choice and free response & $+$\,\blank{1.0cm} \\
4 & Homework     & ... \quad Due: \blank{2.2cm} & \blank{1.2cm} \\
\midrule
  & \multicolumn{2}{r}{\textbf{Total} \quad {\footnotesize (1, 2, and 4, plus any extra credit)}} & \blank{1.2cm} \\
```

**Homework Launch (3 min)** replaces the exit ticket. The plan's `Homework Launch` box names the
problems students start, the **diagnostic item** to read over shoulders (the one that tests the
day's central distinction), and three piles to sort what the teacher sees into. The `[Homework]`
teacher note says which items to grade for accuracy and which predict the next lesson.

**The DeltaMath override.** Only when the user asks for it on a given lesson: omit `homework/`,
give cover row 4 a DeltaMath assignment slot, and say so in Reinforcement & Extension and the
`[Homework]` note. Never assume it.

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

- **The Main Ideas / Notes table** — `guidednotes`, `\mainidea`, `\notesprompt`, `probgrid` /
  `probgrid*`, `\pcell`, `\writespace`, `\labelbox`, `\stepnum` — is defined in
  `precalculus-boxes.sty` (ported from AP Statistics 2026-09-12; the commentary there is the
  reference; labels and step discs are set in `plum`). Traps: **inside a table cell `\\` ends
  the row** and spills the rest into the label column — break lines with `\par`; **a row cannot
  break across pages** — give the figure its own sub-row (a bare `\\`, then `& ...`) and put each
  grid row in its own sub-row, reopening as `probgrid*` (no top rule); **`\pcell`'s height is the
  answer space only**, below the statement, and an answer longer than it overflows silently. The
  key differs from the blank only in `-key` for `-boxes`, the vocabulary rows, `\blank`→`\ans`,
  and the answer argument of each `\pcell`, `\writespace`, `\labelbox`.

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
sentence in italics, said by the teacher and echoed back; a homework item asks for it in
writing), *point forward* (or read a read-only notes section aloud here) — then a
`\textbf{Do not}` line: no re-teaching, no new questions, no starting the homework early) →
**Homework Launch (3 min)** (`skillbox{redbox}`; the problems students start, the diagnostic
item, the three piles) → **Reinforcement & Extension** (`skillbox{goldbox}`;
`\textbf{Homework --- printed, graded (2 pages).}` overview by part and problem;
`\textbf{AP Practice --- extra credit (2 pages).}` overview naming what each distractor catches;
`\textbf{Preview:}` of the next lesson) → **Teacher notes, five, in packet order:**
`[Warm-Up]`, `[Guided Notes]`, `[Debrief]`, `[AP Practice]`, `[Homework]`.

The Debrief note says why those minutes are worth protecting and what to borrow from instead
when the guided phase overruns (never the Homework Launch); the AP Practice note gives the
multiple-choice answers and the distractor to look for; the Homework note says what to grade for
accuracy and what predicts the next lesson. The Debrief note has no component behind it, so
`note_labels` does not list it — write it by hand. The `Differentiation — During You Do` box **replaced** the old
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
| **current** (gradual release + back-of-packet, 2026-09-16) | `notes/` + `ap_practice/` + `homework/`, **no** `exit_ticket/`, **no** `activity/`; plan has a Homework Launch box | `unit01/lesson01` |
| **exit-ticket gradual release** (2026-08) | `notes/` + `exit_ticket/`, no `homework/` (DeltaMath); plan has Individual Work & Assessment | none remaining |
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
3. **Exit ticket out; AP Practice and Homework in.** `git rm -r exit_ticket exit_ticket_key`;
   author `ap_practice/` + `homework/` (and keys), two pages each, per §1 and
   `templates/lesson/components.md` — a legacy homework is rewritten, not kept, since it is
   neither two pages nor in a fresh context. The cover's `tocbox` becomes the §2 table.
4. **Rewrite the plan** in the §5 order: insert the Lesson Flow box (sum 60, no activity row),
   retitle the Lesson box and tag every part with its phase and pen line, replace
   `Group Work \& Differentiation` with `Differentiation --- During You Do`, insert the Debrief
   box, replace Individual Work & Assessment with the Homework Launch box, rewrite Reinforcement
   & Extension around the homework and AP Practice, and re-cut the teacher notes to the five (any note still in a `_key` moves first —
   `movenotes.py`).
5. **Cover**: learning targets one per LO in the formal vocabulary; packet table per §2;
   `\namedateperiod` stays here and nowhere else (`namestrip.py`).
6. **Deck**: author one if the lesson has none (15 do not); otherwise reorder it to
   hook → I Do → We Do → You Do → debrief → homework launch.
7. **Apply the five conventions in the §8 order**, then delete stale stamps —
   `rm -rf .stamps/unitXX/lessonYY target/unitXX/lessonYY` — `make -C unitXX/lessonYY all`,
   `make -C unitXX/lessonYY check`, and update the lesson's `COURSE_PLAN.md` row.

Finish with the evidence per lesson: `make all` exits 0, `make check` passes (page parity, the
one-page warm-up on both sides, AP Practice and Homework exactly two pages each (checked by hand —
`make check` proves parity, not length), `\ans` placement, no key-side notes, namestrip),
and every component's page count equals its `_key`'s on the compiled components, not the padded
packets.

**Scoreboard (2026-09-17):** 1 lesson is in the current shape (`unit01/lesson01`);
14 are convention-compliant group-activity lessons (`unit01/lesson02`–`07`,
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
