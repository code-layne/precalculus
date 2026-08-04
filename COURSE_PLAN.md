# Precalculus — Course Plan

**Track:** non-honors. An honors precalculus course runs separately; this course's job is
to cover the fundamentals of precalculus thoroughly so a student moves comfortably into a
*regular* college calculus course. Depth over breadth: the function/polynomial/rational/
exponential/logarithmic/trigonometric core is spread out and reinforced, and the
parameters-vectors-matrices material is condensed into a single closing unit.

**Structure:** 8 units × 8 lessons = **64 lessons**, plus a sample test per unit.
Units 1 and 2 number their eight lessons 1.0–1.7 and 2.0–2.7 (see the replan notes below);
units 3–8 still number theirs X.1–X.8 and adopt the X.0 opener as each is reauthored.
Pacing target: 18–22 class periods per unit (55-minute meetings).

**Content source:** the AP Precalculus CED (`spec/`) remains the content backbone.
"CED n.m" below refers to the CED topic that drives the lesson's objectives and essential
knowledge. Lessons marked **New** have no single CED topic; they exist to slow the ramp
for the non-honors track or to add calculus-readiness material.

## How this restructure was performed (August 2026)

The previous tree mirrored the CED directly: 4 units, 58 lessons. This restructure:

- **moved 52 lessons** into the new 8-unit numbering (content untouched apart from a
  mechanical renumber of `\UnitNumberName`, `\LessonNumberName`, `\pageheader`, cover
  banners, and `%!` header comments);
- **scaffolded 12 new lesson slots** (skeletons only, born convention-compliant);
- **dropped 6 lessons** whose material is absorbed by a neighbor (see the condensation
  record at the bottom; content recoverable from git history before this restructure).

**Every lesson is scheduled for reauthoring.** Until a moved lesson is reauthored, its
body is the old AP-paced content: its internal cross-references ("in Lesson 2.7 we saw…")
still use the *old* numbering, and lessons that absorb a dropped neighbor do not yet
contain the absorbed material. Reauthoring a lesson also retrofits the five conventions
(vocabpar → teachernote → namestrip → work rule → boxguard) — see the `lesson-planning`
skill; there is no bulk sweep.

## Unit and lesson map

Status legend: **moved** = old lesson relocated, body not yet reauthored;
**new** = scaffolded skeleton awaiting authoring;
**authored** = written to the new scope, born convention-compliant.

### Unit 1: Functions and Change

Replanned August 2026: Unit 1 numbers its eight lessons **1.0–1.7** (the unit opens with
an introduction lesson). Two pairs from the original 8-unit map were merged (old 1.2+1.3
→ 1.3; old 1.7+1.8 → 1.7), and two new lessons were added at the front.

| # | Lesson | Source | Status |
|---|--------|--------|--------|
| 1.0 | Introduction to Functions and Change | New (unit introduction) | authored |
| 1.1 | Function Fundamentals | New (notation, domain/range, evaluating, reading graphs) | authored |
| 1.2 | Change in Tandem | CED 1.1 (was 1.1) | authored |
| 1.3 | Rates of Change | CED 1.2 + 1.3 (was 1.2; absorbs 1.3) | authored |
| 1.4 | Transformations of Functions | CED 1.12 (was 1.12) | authored |
| 1.5 | Composition of Functions | CED 2.7 (was 2.7) | authored |
| 1.6 | Inverse Functions | CED 2.8 (was 2.8) | authored |
| 1.7 | Function Model Selection and Construction | CED 1.13 + 1.14 (was 1.7; absorbs 1.8) | authored |

Rationale: the unit opens with an orientation lesson (1.0) and an explicit
function-fundamentals ramp (1.1) for the non-honors track, then the function toolkit
(transformations, composition, inverses) is pulled forward so every later unit can use
it. Composition and inverses land here — before exponentials need them — instead of
mid-Unit-2 as in the CED. Average rate of change and its linear/quadratic application
travel together (1.3), and the two modeling lessons merge into a single closer (1.7).

### Unit 2: Polynomial Functions

Replanned August 2026: Unit 2 numbers its eight lessons **2.0–2.7**, matching Unit 1. The
unit opens with an introduction lesson (2.0), and to stay at eight the old 2.8 (Modeling)
folds into the equations/inequalities lesson, now 2.7. Lessons 2.1–2.6 keep their titles
and their directories — no lesson was renumbered.

| # | Lesson | Source | Status |
|---|--------|--------|--------|
| 2.0 | Introduction to Polynomial Functions | New (unit introduction) | authored |
| 2.1 | Quadratic Functions Revisited | New (extends CED 1.3) | authored |
| 2.2 | Polynomial Functions and Rates of Change | CED 1.4 (was 1.4) | authored |
| 2.3 | Polynomial Functions and Real Zeros | New (split of CED 1.5) | authored |
| 2.4 | Polynomial Functions and Complex Zeros | CED 1.5 (was 1.5) | authored |
| 2.5 | Polynomial Functions and End Behavior | CED 1.6 (was 1.6) | authored |
| 2.6 | Equivalent Representations of Polynomial Expressions | New (split of CED 1.11) | authored |
| 2.7 | Polynomial Equations, Inequalities, and Modeling | New (absorbs CED 1.14 modeling) | authored |

Rationale: the CED covers polynomials in three dense lessons; the non-honors track gets
eight. The unit opens with an orientation lesson (2.0) that names the polynomial family
before any analysis of it. Real zeros stay separated from complex zeros — the split is the
unit's main concession to the non-honors pace, so it is the one protected when a merge is
needed. Equation and inequality solving (a calculus prerequisite) closes the unit together
with the modeling work it motivates.

**Unit 2 is fully reauthored.** The old standalone Modeling lesson at `unit02/lesson08` has
been retired: its material folded into 2.7 (the open-box model, the domain restriction drawn
from context, and regression as the technology route), and the directory was removed. Unit 2
is the first unit whose eight lessons are all written to the new plan and born
convention-compliant.

### Unit 3: Rational Functions

| # | Lesson | Source | Status |
|---|--------|--------|--------|
| 3.1 | Rational Functions and End Behavior | CED 1.7 (was 1.7) | moved |
| 3.2 | Rational Functions and Zeros | CED 1.8 (was 1.8) | moved |
| 3.3 | Rational Functions and Vertical Asymptotes | CED 1.9 (was 1.9) | moved |
| 3.4 | Rational Functions and Holes | CED 1.10 (was 1.10) | moved |
| 3.5 | Equivalent Representations of Rational Expressions | CED 1.11 (was 1.11) | moved |
| 3.6 | Graphing Rational Functions | New (synthesis) | new |
| 3.7 | Rational Equations and Inequalities | New | new |
| 3.8 | Modeling with Rational Functions | New | new |

Rationale: rational-function behavior is the closest precalculus gets to limit language;
it earns a full unit. Old 1.11 covered polynomial *and* rational equivalence — its file
lives here (3.5); the polynomial half is reauthored separately as 2.6.

### Unit 4: Exponential Functions

| # | Lesson | Source | Status |
|---|--------|--------|--------|
| 4.1 | Change in Arithmetic and Geometric Sequences | CED 2.1 (was 2.1) | moved |
| 4.2 | Change in Linear and Exponential Functions | CED 2.2 (was 2.2) | moved |
| 4.3 | Exponential Functions | CED 2.3 (was 2.3) | moved |
| 4.4 | Exponential Function Manipulation | CED 2.4 (was 2.4) | moved |
| 4.5 | The Number e and Continuous Growth | New (calculus preparation) | new |
| 4.6 | Exponential Function Context and Data Modeling | CED 2.5 (was 2.5) | moved |
| 4.7 | Competing Function Model Validation | CED 2.6 (was 2.6) | moved |
| 4.8 | Growth, Decay, and Interest Applications | New | new |

### Unit 5: Logarithmic Functions

| # | Lesson | Source | Status |
|---|--------|--------|--------|
| 5.1 | Logarithmic Expressions | CED 2.9 (was 2.9) | moved |
| 5.2 | Inverses of Exponential Functions | CED 2.10 (was 2.10) | moved |
| 5.3 | Logarithmic Functions | CED 2.11 (was 2.11) | moved |
| 5.4 | Logarithmic Function Manipulation | CED 2.12 (was 2.12) | moved |
| 5.5 | Exponential Equations and Inequalities | New (split of CED 2.13) | new |
| 5.6 | Logarithmic Equations and Inequalities | CED 2.13 (was 2.13) | moved |
| 5.7 | Logarithmic Function Context and Data Modeling | CED 2.14 (was 2.14) | moved |
| 5.8 | Semi-log Plots | CED 2.15 (was 2.15) | moved |

Rationale: CED 2.13 packs exponential and logarithmic equation-solving into one lesson;
the non-honors track takes them one at a time (5.5 exponential, 5.6 logarithmic).

### Unit 6: Trigonometric Functions

| # | Lesson | Source | Status |
|---|--------|--------|--------|
| 6.1 | Periodic Phenomena | CED 3.1 (was 3.1) | moved |
| 6.2 | Angles and Radian Measure | New (split of CED 3.2) | new |
| 6.3 | Sine, Cosine, and Tangent | CED 3.2 (was 3.2) | moved |
| 6.4 | Sine and Cosine Function Values | CED 3.3 (was 3.3) | moved |
| 6.5 | Sine and Cosine Function Graphs | CED 3.4 (was 3.4) | moved |
| 6.6 | Sinusoidal Functions | CED 3.5 (was 3.5) | moved |
| 6.7 | Sinusoidal Function Transformations | CED 3.6 (was 3.6) | moved |
| 6.8 | Sinusoidal Function Context and Data Modeling | CED 3.7 (was 3.7) | moved |

Rationale: radian measure gets a standalone lesson before the unit circle — the single
most common trig stumbling block for non-honors students, and non-negotiable for calculus.

### Unit 7: Analytic Trigonometry and Polar Coordinates

| # | Lesson | Source | Status |
|---|--------|--------|--------|
| 7.1 | The Tangent Function | CED 3.8 (was 3.8) | moved |
| 7.2 | Inverse Trigonometric Functions | CED 3.9 (was 3.9) | moved |
| 7.3 | Trigonometric Equations and Inequalities | CED 3.10 (was 3.10) | moved |
| 7.4 | The Secant, Cosecant, and Cotangent Functions | CED 3.11 (was 3.11) | moved |
| 7.5 | Equivalent Representations of Trigonometric Functions | CED 3.12 (was 3.12) | moved |
| 7.6 | Trigonometry and Polar Coordinates | CED 3.13 (was 3.13) | moved |
| 7.7 | Polar Function Graphs | CED 3.14 (was 3.14) | moved |
| 7.8 | Rates of Change in Polar Functions | CED 3.15 (was 3.15) | moved |

### Unit 8: Parametric Functions, Vectors, and Matrices

| # | Lesson | Source | Status |
|---|--------|--------|--------|
| 8.1 | Parametric Functions and Planar Motion | CED 4.1 + 4.2 (was 4.1; absorbs 4.2) | moved |
| 8.2 | Parametric Functions and Rates of Change | CED 4.3 (was 4.3) | moved |
| 8.3 | Parametrically Defined Circles and Lines | CED 4.4 + 4.7 (was 4.4; absorbs 4.7) | moved |
| 8.4 | Implicitly Defined Functions | CED 4.5 (was 4.5) | moved |
| 8.5 | Conic Sections | CED 4.6 (was 4.6) | moved |
| 8.6 | Vectors and Vector-Valued Functions | CED 4.8 + 4.9 (was 4.8; absorbs 4.9) | moved |
| 8.7 | Matrices and Matrix Operations | CED 4.10 + 4.11 (was 4.10; absorbs 4.11) | moved |
| 8.8 | Matrices as Transformations and Models | CED 4.12–4.14 (was 4.12; absorbs 4.13, 4.14) | moved |

Rationale: the CED's 14-lesson Unit 4 is a survey; for the non-honors track it compresses
to 8. Parametric and implicit descriptions are kept nearly whole (they pay off in
calculus); the vector and matrix material is compressed hardest.

## Condensation record (dropped lesson directories)

| Old lesson | Title | Absorbed into |
|-----------|-------|---------------|
| 4.2 | Parametric Functions Modeling Planar Motion | 8.1 |
| 4.7 | Parametrization of Implicitly Defined Functions | 8.3 |
| 4.9 | Vector-Valued Functions | 8.6 |
| 4.11 | The Inverse and Determinant of a Matrix | 8.7 |
| 4.13 | Matrices as Functions | 8.8 |
| 4.14 | Matrices Modeling Contexts | 8.8 |

From the Unit 1 replan (August 2026; old numbers are the 8-unit numbering in use just
before the replan):

| Old lesson | Title | Absorbed into |
|-----------|-------|---------------|
| 1.3 | Rates of Change in Linear and Quadratic Functions | 1.3 (Rates of Change) |
| 1.8 | Function Model Construction and Application | 1.7 (Function Model Selection and Construction) |

The dropped directories' full content is in git history (tree at tag/commit prior to the
restructure, under `unit04/lessonNN`). When reauthoring an absorbing lesson, pull the
essential ideas from the absorbed lesson at reduced depth — the goal is exposure, not
honors-level mastery.

## Reauthoring checklist (per lesson)

1. Rewrite the lesson plan and components to the new scope (this file + unit cover define
   the scope; the CED topic supplies objectives and essential knowledge).
2. Pace for the non-honors classroom: more worked examples, gentler ramps, one big idea
   per lesson.
3. Fix internal cross-references to the **new** lesson numbering.
4. Apply the five conventions in order: vocabpar → teachernote → namestrip → work rule →
   boxguard.
5. Build and verify: `make -C unitXX/lessonYY all`; warm-up and exit ticket exactly one
   page (blank and key); every component's page count equals its key's.
