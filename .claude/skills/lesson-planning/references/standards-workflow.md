# Standards Workflow

Use this for the lessons `COURSE_PLAN.md` marks **New** — the ramp-slowing and
calculus-readiness lessons that have **no CED topic** behind them. (It is also the path for a
project with no `spec/ap-*` documents at all.) The lesson is driven by three inputs the user
supplies:

1. **Lesson title** — e.g. "Solving Linear Equations".
2. **Description** — a few sentences on what the lesson covers and why.
3. **Standards** — the list being addressed. These are usually codes from the course's
   framework (for Virginia courses, SOL codes such as `A.1`, `AII.3`; elsewhere CCSS, state
   standards, or a district scope-and-sequence). Take them as given; don't invent codes.

If the user gives only a title, ask for the description and standards before authoring — those
two are what make the lesson plan specific rather than generic. For a **New** lesson in this
course, the "standards" are typically the prerequisite skills being re-activated, or the
calculus-readiness idea the lesson exists to add; `COURSE_PLAN.md`'s focus column is the
starting point.

## Mapping inputs into the lesson

The document structure is identical to the CED path (`references/components.md`); only the
*source* of the content differs. There are no Mathematical Practice tags.

| Lesson element | Source |
| --- | --- |
| Lesson title (`\LessonNumberName`) | the supplied title |
| **Primary Objective** | one or two sentences distilled from the description (what students will be able to do) |
| **Priority Ideas & Skills** | the concrete skills implied by the standards + description; group them as the lesson's priority list |
| **Vocabulary, Concepts & Theorems** | the terms and formulas the lesson introduces or relies on |
| **Learning Targets** (cover, "I can…") | one target per standard (or per major skill), reworded as "I can …" |
| Standards line | the supplied standard codes, recorded in the lesson plan (and a coverage log if the project keeps one) |
| Guided notes / exit ticket / homework | practice that exercises each standard; scale the notes' practice box (the You Do phase) across the difficulty range the standards imply, hardest item last |

## Steps

1. Confirm the title, description, and standards with the user; clarify scope if a standard is
   broad enough to span multiple lessons.
2. Scaffold the lesson (`scripts/new_lesson.py`) with the components you need. This course
   defines `\CourseName`/`\MeetingLength` **inline in the lesson plan**, not in the style
   package, so pass `--course "Precalculus"` or the generated plan says "TODO Course".
3. Author the lesson plan and components per `references/components.md`, keeping the objective
   and learning targets traceable to the standards.
4. Mirror the course's existing assessment conventions — e.g. a standards-style multiple-choice
   item in the Individual Work & Assessment section and on the exit ticket.
5. Build, then gate it: `make -C unitXX/lessonYY all && make -C unitXX/lessonYY check`
   (`references/build.md`).

The live project is the gold reference: open a **reauthored** lesson (per `COURSE_PLAN.md`'s
status column) and match its tone, section depth, and box usage.
