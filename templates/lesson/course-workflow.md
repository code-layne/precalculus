# Course Workflow — Precalculus

The course-specific companion to the shared skill's `references/ap-workflow.md` and
`references/standards-workflow.md` (`~/.claude/skills/lesson-planning/`). Those two files say
how to read a CED and how to author from a title + description + standards in general; this
file says what is different *here*. Read `LESSON_SHAPE.md` §3 first — it is the summary; this
is the detail.

## Read `COURSE_PLAN.md` first — the CED is not the lesson map

**This course does not mirror the CED.** The CED has 4 units; this course has **8 units × 8
lessons**, non-honors, spread out so the function/polynomial/rational/exponential/logarithmic/
trigonometric core is reinforced and the parameters–vectors–matrices material is condensed into
a single closing unit.

`COURSE_PLAN.md` is authoritative. For the target lesson it gives the title, the focus, the
status (**moved** = body not yet reauthored, **new** = skeleton awaiting authoring, **authored**
= written to the new scope), and the **"CED n.m"** topic that drives it. Look the lesson up
there, then open the CED at that topic. **The lesson title is the one in `COURSE_PLAN.md`, not
the CED topic title.**

Lessons marked **New** have **no CED topic** — they exist to slow the ramp or to add
calculus-readiness material. Author those through the shared `references/standards-workflow.md`
instead, using the prerequisite skills being re-activated (or the calculus-readiness idea the
lesson exists to add) as the "standards"; `COURSE_PLAN.md`'s focus column is the starting
point. A New lesson uses the same lesson-plan skeleton; it simply fills Priority Ideas & Skills
with the prerequisite skills and carries no CED tags (the Primary Objective notes
"no CED topic", as `unit01/lesson01` does).

## The course is called "Precalculus", never "AP Precalculus"

The College Board CED is the content backbone, but **no course-facing text carries an AP prefix
on the course name**: not the cover, not a page header, not a lesson plan, not the deck, not
these docs. Other AP terminology is fine and should stay — "AP-style multiple choice",
"AP Skill 2.B", "AP Exam weighting". The rule is about the *course name* only. The
`spec/ap-precalculus-*.pdf` filenames stay as they are on disk.

## The spec documents

| File | Use |
| --- | --- |
| `spec/ap-precalculus-course-at-a-glance.pdf` | Structural backbone: the four CED units, pacing + exam weighting, ordered topics, and each topic's Mathematical Practice tags. **Read this first.** |
| `spec/ap-precalculus-course-and-exam-description.pdf` | The full CED (large). Contains per-topic **Required Course Content**: Learning Objectives and Essential Knowledge statements. The authoring source. |
| `spec/ap-precalculus-ced-clarification-and-guidance.pdf` | Scope limits and notation clarifications — read the relevant pages when a topic's boundary is ambiguous. |
| `spec/ap-precalculus-course-overview.pdf`, `...poster.pdf` | Supplementary framing. Optional. |

For these text-layer PDFs, `pdftotext -layout` is sufficient; rasterize only if a topic's
two-column layout is ambiguous.

## The framework vocabulary

This CED has **no "Big Ideas"** and no Enduring Understandings. Its cross-cutting dimension is
the three **Mathematical Practices**, which spiral across every topic.

**In lesson plans these are written `AP Skill x.y`** — e.g. `\textbf{AP Skill 2.B} --- Construct
equivalent representations`. That is the label every authored lesson uses; match it rather than
writing "Mathematical Practice 2.B". The course *name* drops its AP prefix; this framework term
keeps its own.

| Practice | Name | Sub-skills |
| --- | --- | --- |
| **1** | Procedural and Symbolic Fluency | `1.A` solve equations and inequalities · `1.B` express functions, equations, or expressions in analytically equivalent forms · `1.C` construct new functions |
| **2** | Multiple Representations | `2.A` identify information from graphical, numerical, analytical, and verbal representations · `2.B` construct equivalent representations |
| **3** | Communication and Reasoning | `3.A` describe the characteristics of a function · `3.B` describe the assumptions and limitations of a model · `3.C` support conclusions or choices with a logical rationale or appeal to evidence |

**Code scheme** — flat and topic-based, unlike AP Statistics' `BIGIDEA-n.LETTER`:

- Learning Objective → `UNIT.TOPIC.LETTER` (e.g. `1.1.A`, `1.4.A`)
- Essential Knowledge → `UNIT.TOPIC.LETTER.number` (e.g. `1.1.A.1`, `1.4.A.5`)

The unit digit is the **CED** unit (1–4), *not* this course's unit number. Record CED codes as
written; do not renumber them to match the 8-unit map.

## Extraction steps

1. **Look the lesson up in `COURSE_PLAN.md`** — title, focus, status, and the driving CED topic.
2. **Find the topic in course-at-a-glance** — note its Mathematical Practice tags and the CED
   unit's pacing/weighting.
3. **Pull the topic's Required Course Content from the CED.** Locate the topic page (search the
   extracted text for the topic number, e.g. `1.4`) and capture every **Learning Objective**
   (code + sentence) and every **Essential Knowledge** statement under it (code + sentence).
4. **Normalize the text.** CED extraction injects control characters (e.g. a bell character for
   a non-breaking space), hyphenates across line breaks, and interleaves the two columns — strip
   control chars, rejoin wrapped lines, and separate the LO column from the EK column before
   using the text.
5. **Confirm the mapping with the user** before authoring: show the topic, the LO/EK list, and
   the proposed lesson title. A CED topic often spans more than one lesson in this course
   (that is the point of the 8-unit spread), and some lessons absorb two topics — let the user
   decide the granularity.

## Mapping CED content into the lesson

| Lesson element | Source |
| --- | --- |
| Lesson title (`\LessonNumberName`) | The title from `COURSE_PLAN.md` — **not** the CED topic title |
| **Primary Objective** (lesson plan) | Restate the LOs as student-facing aims; no Big Idea tag exists to add |
| **Priority Ideas & Skills** (lesson plan, gold box) | Left: `\textbf{AP Skill x.y} --- <sub-skill name>`. Right: "Key Understandings" paraphrased from the EKs, with the target misconception named |
| **Vocabulary, Concepts & Theorems** | Terms named in the EKs |
| **Learning Targets** (cover, "I can…") | One target per Learning Objective, reworded as "I can …", naming the formal term in bold |
| Standards line | The LO/EK codes addressed (e.g. `1.4.A`, `1.4.A.1`) — recorded in the lesson plan |
| Guided notes / exit ticket | Practice that exercises the named Practice against the EK statements; mirror the cognitive level of the LO verbs (describe, identify, construct, determine, compare, support). The notes' `\S` sections carry I Do and We Do; the practice box is the You Do; the exit ticket is the individual check |
| DeltaMath homework (plan, Reinforcement & Extension) | Target coverage stated by **item type**, drawn from the same EKs |

Keep wording **paraphrased**, not copied verbatim from the CED — the lesson should restate the
framework in teaching language, with the codes as the audit trail. **Scaffold for the
non-honors track:** a context first, small numbers, one new idea at a time, worked examples, and
a gentler ramp than the CED's pacing implies.

## Worked fragment (CED Topic 1.4)

From the CED: LO `1.4.A` ("Identify key characteristics of polynomial functions related to rates
of change."), EK `1.4.A.5` ("Points of inflection of a polynomial function occur at input values
where the rate of change changes from increasing to decreasing or vice versa.").

Produces, in the lesson plan:
```latex
\begin{tcolorbox}[colback=lilac,colframe=plum,boxrule=0.9pt,arc=2mm,...]
  \textbf{Primary Objective:} Students will identify the key characteristics of a polynomial
  function that describe how its rate of change behaves --- where the function is increasing
  or decreasing, and where that behavior itself turns around at a point of inflection.
\end{tcolorbox}
...
\begin{skillbox}[Priority Ideas \& Skills]{goldbox}
  \textbf{AP Skill 3.A} --- Describe the characteristics of a function
  \begin{itemize}\item Read increasing/decreasing behavior and points of inflection from a polynomial's graph.\end{itemize}
\end{skillbox}
```
and, on the cover: a learning target "I can find where a polynomial's rate of change switches
direction, and say what that point means." Standards addressed: `1.4.A`, `1.4.A.5`.

For the rest of the document structure, follow `templates/lesson/components.md`; for macros
and boxes, the shared skill's `references/conventions.md`; for everything course-specific,
`LESSON_SHAPE.md`.
