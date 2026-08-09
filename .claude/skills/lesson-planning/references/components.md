# Components

The spec for authoring each file after scaffolding. The scaffolder (`scripts/new_lesson.py`)
gives you a correctly-preambled skeleton with TODO markers; this file says what fills them.
**Always also open a real built lesson in the same course as the gold reference** — these specs
summarize the pattern, but the live project is authoritative. For macros and boxes see
`references/conventions.md`.

Contents: [Lesson plan](#lesson-plan) · [Cover](#cover) · [Warm-up](#warm-up) ·
[Guided notes](#guided-notes) · [Activity](#activity) · [Exit ticket](#exit-ticket) ·
[Homework](#homework) · [Slides](#slides) · [Answer-key discipline](#answer-key-discipline) ·
[Unit cover](#unit-cover) · [Sample test & key](#sample-test--key)

General rules:
- Student components preamble with `-article` + `-boxes`; keys with `-article` + `-key`.
- Keep the **key structurally identical** to its blank — it is the blank with answers filled in.
- **Author to the five conventions from the start** (full spec in `references/conventions.md`):
  worked solutions in byte-identical `\begin{work}` blocks (**work rule**); teacher prose in the
  lesson plan as `\begin{teachernote}[Component]`, never in a `_key` (**teachernote**); no
  name/date/period row on any component but the cover (**namestrip**); `\par\vspace{2pt}` after a
  `vocabbox` intro sentence (**vocabpar**); `\boxguard` before any breakable box that would strand
  a stub, in the blank and the key both (**boxguard**).
- Paraphrase any AP CED language into teaching wording; keep LO/EK codes as the audit trail.
- Use the project's boxes and fill-in macros rather than hand-rolling layout.

## Lesson plan

`main.tex` at the lesson root — teacher-facing, never handed to students. Canonical section
order (same skeleton for review and primary-content lessons; review lessons simply carry no
AP tags and list review topics):

1. **Title block** — `\CourseName` + `\UnitNumberName \LessonNumberName`. No school year
   anywhere in the title block.
2. **Primary Objective** — a `tcolorbox` (`lilac`/`plum`). One or two sentences restating the
   CED Learning Objectives as student-facing aims. AP Precalculus has no "Big Idea" tag.
3. **Priority Ideas & Skills** — `skillbox{goldbox}`, two `minipage`s. Left: the priority
   skills, labelled with the Mathematical Practice and sub-skill (e.g. "Practice 2 — Multiple
   Representations: construct equivalent representations (2.B)"). Right: "Key Understandings"
   paraphrased from the EKs.
4. **Vocabulary, Concepts & Theorems** — `skillbox{greenbox}`, a `tabularx` term/definition
   table (use `\TallMath{...}` for tall formulas).
5. **Activate Prior Knowledge & Spiral Review** — `skillbox{sky}` (**not** `fixedskillbox` — that environment does not exist); lists the prerequisite skills the warm-up reviews, **in words**. Text-only — never embed a warm-up thumbnail.
6. **Hook** — `skillbox{sky}`: the entry question or scenario.
7. **Lesson** (and optional **Lesson (cont.)**) — `skillbox{sky}` with `\begin{multicols}{2}`;
   the worked instructional progression, bolding the questions you'll pose.
8. **Explicit Instruction: <technique>** — one `skillbox{sky}` per technique, two columns:
   numbered steps on the left, a worked example (often with a Desmos screenshot) on the right.
9. **Active Monitoring** — `skillbox{redbox}`: what to circulate and check; cold-call prompts.
10. **Group Work & Differentiation** — `skillbox{redbox}`: a `multicols{3}` with **Tier R —
    Remediate / Tier A — Approaching Proficiency / Tier E — Extension** bullet lists that
    mirror the activity tiers.
11. **Individual Work & Assessment** — `skillbox{redbox}`: exit-ticket items + an SOL/AP-style
    MC, with a note on collecting and using results.
12. **Reinforcement & Extension** — `skillbox{goldbox}`: homework overview, an extension, and a
    preview of the next lesson.
13. **Teacher notes** — one `\begin{teachernote}[Component]` per component, in packet order
    (Warm-Up, Guided Notes, Group Activity, Exit Ticket, Homework): pacing, common errors, what
    to look for. This is the **only** place teacher-only prose goes — never in a `_key`.

## Cover

`cover/main.tex` — student-facing front page of the packet. No key. Structure:
- Full-bleed navy banner (tikz) with `\LARGE` course name, unit, and `Lesson <id>  <title>`.
- `\namedateperiod` — the cover is the **one** component that carries it (namestrip).
- `learningtargetbox` — an "I can…" list, **one target per Learning Objective**.
- `tocbox` — a `tabularx` listing each packet component (#, Component, Description, Score blank)
  with a Total row. Keep the rows aligned with the components you actually scaffolded.
- Optionally mirror the lesson plan's Priority Ideas & Vocabulary for student reference.

## Warm-up

`warmup/` (+ `warmup_key/`) — short spiral review of *prerequisite* skills, on exactly one page.
May be a **prefab PDF**: if so, just drop it in as `warmup/main.pdf` (and `warmup_key/main.pdf`)
— `lesson.mk` merges it directly. If authored: 3–5 quick problems with work space, and **no name
row** (namestrip). Key mirrors with `\ans`; multi-step answers go in a `work` block authored
byte-identically in both files. Either way the lesson plan's spiral review is **text-only** —
never embed a thumbnail of the warm-up.

## Guided notes

`notes/` (+ `notes_key/`) — the student's fill-in notes. Structure:
- `\pageheader{Unit X, Lesson Y.Z}{Guided Notes}` — **no name row** (namestrip).
- `objectivebox` — "By the end of this lesson, I will be able to…" with `\writeline`s for
  students to fill (the key uses `\ansline{...}`, one per Learning Objective).
- `vocabbox` — `\termblanklong{Term}` per key term (the key follows each with `\ansline{...}`).
  If the box opens with an intro sentence, end it with `\par\vspace{2pt}` in **both** files —
  without the `\par` the sentence and the first term collide (vocabpar).
- `hookbox` — the same hook as the plan, with write-lines for student responses.
- Direct-instruction sections in `notesbox{Title}` with blanks (`\blank`, `\writeline`) at the
  points where students record steps/definitions/results.
- Optional `practicebox` ("Guided Practice") with 1–2 worked-with-class problems.

## Activity

`activity/` (+ `activity_key/`) — differentiated group practice.
- `\pageheader{Unit X, Lesson Y.Z}{Group Activity}` — **no name row** (namestrip).
- Three `tcolorbox`es titled **Tier R — Remediate**, **Tier A — Approaching Proficiency**,
  **Tier E — Extension** (`colframe=black!40`), each with problems and generous `\vspace` work
  room. Tiers escalate in difficulty and align to the same skills.
- Key mirrors exactly, filling answers with `\ans{...}` and marking correct MC options with
  `\textcolor{keyred}{\textbf{$\leftarrow$ correct}}`, plus brief worked steps.

## Exit ticket

`exit_ticket/` (+ `exit_ticket_key/`) — a short independent check (2–3 items), no notes.
`\pageheader{...}{Exit Ticket}` — **no name row** (namestrip); a tight `enumerate` with a little
work space. Key fills with `\ans` (multi-step answers in a `work` block). Graded for completion in the example courses ("mistakes happen,
blanks don't").

## Homework

`homework/` (+ `homework_key/`) — independent practice + stretch.
`\pageheader{...}{Homework}` — **no name row** (namestrip); a numbered practice set, an
`extensionbox` ("Extension — optional"), and a short preview of the next lesson. Key fills with
`\ans` and shows worked steps for the harder items — in `work` blocks, mirrored in the blank.

## Slides

`slides/` — optional Beamer deck (`\documentclass[aspectratio=169,11pt]{beamer}` +
`\usepackage{<prefix>-beamer}`). No key. Title slide is hand-built (navy background canvas +
minipage), content slides use `\navyheader{Title}` and `\sectionlabel[color]{LABEL}`. Note
`\CourseName` is **not** defined in beamer — write the course name literally. Mirror the
existing `slides/main.tex` closely; the beamer theme is bespoke.

## Answer-key discipline

There is no key toggle — every key is a separate file under `<comp>_key/`:
- Copy the blank component **verbatim**, then swap `\usepackage{<prefix>-boxes}` for
  `\usepackage{<prefix>-key}`.
- Replace each blank/write-line with `\ans{answer}` (inline) or `\ansline{answer}` (fills a
  write-line). Title becomes "<DocTitle> — Answer Key".
- For multiple choice, keep all options and tag the correct one
  (`\textcolor{keyred}{\textbf{$\leftarrow$ correct}}`), then show the reasoning in a short
  `itemize`.
- **Never put a `teachernote` in a key** — it is the one block with no counterpart in the blank,
  so it makes the key longer. Teacher-only guidance goes in the lesson plan as
  `\begin{teachernote}[Component]`.
- **Worked solutions go in `\begin{work}`**, authored byte-identically in the blank and the key.
  The blank reserves the exact height and prints nothing; the key prints the same block in
  `keyred`, so the two cannot drift apart.
- **Mirror every `\boxguard`** into the key alongside the blank.
- Because the key matches the blank line-for-line, the two paginate identically — verify by
  building both and comparing (`pdfinfo`; the student and key packets must report equal pages).

## Unit tests (summative assessments)

Unit-level, not per-lesson — scaffolded once per unit under `unitXX/tests/` and
`unitXX/test_keys/` (see `references/build.md`). Author **two blank tests and their two keys**,
all with `\pageheader{Unit X: <Title>}{...}` + `\namedateperiod` — tests are taken in a testing
setting, not stapled behind a lesson cover, so they keep the name row:

- **`tests/practice_test/main.tex`** — the study copy students keep. Opens with a `remindbox`
  telling students it mirrors the real test in format and ideas but uses different numbers.
  Organize into `\parthead{Part …}` sections (vocabulary, multiple choice, short
  answer/computation, extended response) with `\vspace` work room. This test is **published as
  the unit's `sample_test`** and lands in the student packet.
- **`tests/actual_test/main.tex`** — the real test given at test time. Same format, parts, and
  difficulty as the practice test, **different numbers/contexts**; no "this is practice" box.
  It is **never** merged into a packet — it is distributed separately.
- **`test_keys/practice_test_key/main.tex`**, **`test_keys/actual_test_key/main.tex`** — the
  keys, each mirroring its blank test exactly (preamble swaps `-boxes` for `-key`), answers in
  `\ans{...}`, correct MC options tagged, worked solutions in byte-identical `work` blocks. **No
  `teachernote`** — a test key's answer rationale and extended-response scoring go on page 2 of
  `unitXX/unit_cover_key/`, so they reach the key packet only; the practice key is published as
  `sample_test_key` and its blank rides in the *student* packet.

Content comes from across the whole unit's standards (it is summative) — sample every skill the
unit's lessons taught, and keep the interpret-and-justify emphasis in the extended response. The
practice and actual versions must stay parallel so the practice test is honest preparation.
Build/publish with `make -C unitXX/tests all` and `make -C unitXX/test_keys all`.

`sample_test/` and `sample_test_key/` are drop-in directories holding only a `.gitkeep` until the
`drop` target publishes the practice test/key into them; no `.tex` is authored there.

## Unit cover (optional pair)

`unitXX/unit_cover/` and `unitXX/unit_cover_key/` — the front matter of the unit packets,
discovered by `shared/unit.mk` and merged ahead of the lesson packets. The student cover goes
into the student packet; the key cover replaces it in the key packet (a unit with no
`unit_cover_key/` gets the plain cover in both). Both compile fresh like a lesson component —
no PDF is committed to the source tree.

The sheet itself lives in **`unit_cover/body.tex`**; both wrappers `\input` it, so page 1 cannot
drift between them. Edit the cover there, never in a wrapper.

```latex
% unit_cover/main.tex — 1pp student cover
\documentclass[10pt]{article}
\usepackage{precalculus-article}
\usepackage{precalculus-boxes}
\begin{document}
\input{body.tex}
\end{document}

% unit_cover_key/main.tex — the same page 1, plus one page of scoring notes
\documentclass[10pt]{article}
\usepackage{precalculus-article}
\usepackage{precalculus-boxes}
\begin{document}
\input{../unit_cover/body.tex}
\newpage
\begin{headlinebox}{plum}{\color{white}\bfseries Unit X --- Exam Scoring Notes (Teacher Copy)}\end{headlinebox}
\begin{teachernote}[Practice Test --- Part B] ... \end{teachernote}
\end{document}
```

Page 1 carries the unit banner, an overview, a lesson table, and the unit's big ideas — student
facing, so no scoring information. Structure it to match the existing units:

- Full-bleed **plum** banner (TikZ): course name, teacher name/year, unit number + title.
- Unit overview `tcolorbox` (`lilac`/`plum`): 4–6 sentence summary of the unit arc.
- Lessons table in a `skillbox{goldbox}`: columns `#`, `\textbf{Title}`, `Focus` — one row per
  lesson, `\arraystretch=1.6`.
- Standards table in a `skillbox{greenbox}`: standard code + one-line description for every
  standard the unit covers.

Page 2 (key only) is teacher-only: the answer rationale and extended-response scoring for
**both** unit assessments — the prose that must not sit in a `*_test_key`, because the practice
test is bound into the student packet. Keep it to one page: cover + notes is a single
double-sided sheet.

**The eight existing units predate this split** — each has a single `unit_cover/main.tex` and no
`body.tex`. To add a key cover to one, first move the sheet's body out of `main.tex` into
`unit_cover/body.tex` and leave the wrapper `\input{body.tex}`, then write the key wrapper.
