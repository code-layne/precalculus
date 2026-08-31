# Precalculus — Unit and Lesson Breakdown

Generated 2026-08-06 from the repository tree (`unit0*/`), the unit cover pages, and
`COURSE_PLAN.md`. Titles below are the ones **actually compiled into the files**
(`\LessonNumberName`); where they differ from `COURSE_PLAN.md`, the drift is flagged in the
last section.

**Course:** Precalculus (non-honors track). 8 units × 8 lessons = **64 lessons**, plus a
unit test per unit. Pacing target 18–22 class periods per unit (55-minute meetings).
Content backbone: the Precalculus CED in `spec/`.

**Per-lesson deliverables (9 PDFs + deck):** cover, warm-up + key, guided notes + key,
group activity + key, exit ticket + key, and a Beamer `slides/` deck. **Homework is
DeltaMath** — the cover carries an assignment slot, a due-date slot, and its own score slot
below the in-class total, and no `homework/` directory exists unless a lesson is explicitly
overridden because DeltaMath has no practice for the topic. Lessons still on the pre-August
shape ship a printed `homework/` + `homework_key/` until they are reauthored.

**Pedagogy:** traditional gradual release. Each 55-minute period runs warm-up → hook →
**I Do** → **We Do** → **You Do** → group activity → **debrief** → exit ticket, and the
lesson plan opens with a Lesson Flow box whose minutes sum to 55. The debrief is
teacher-facing only; the student packet closes with the exit ticket.

Status legend — **authored** = written to the current plan, convention-compliant;
**moved** = old AP-paced body relocated but not yet reauthored; **new** = scaffolded
skeleton awaiting authoring.

---

## Unit 1 — Functions and Change  *(fully authored)*

> How do we describe the way one quantity changes with respect to another?
> What do rates of change, transformations, composition, and inverses reveal about how a
> function behaves?

| # | Lesson | CED source | Dir | Status |
|---|--------|-----------|-----|--------|
| 1.0 | Introduction to Functions and Change | New (unit opener) | `unit01/lesson00` | authored |
| 1.1 | Function Fundamentals | New (notation, domain/range, reading graphs) | `unit01/lesson01` | authored |
| 1.2 | Change in Tandem | CED 1.1 | `unit01/lesson02` | authored |
| 1.3 | Rates of Change | CED 1.2 + 1.3 | `unit01/lesson03` | authored |
| 1.4 | Transformations of Functions | CED 1.12 | `unit01/lesson04` | authored |
| 1.5 | Composition of Functions | CED 2.7 | `unit01/lesson05` | authored |
| 1.6 | Inverse Functions | CED 2.8 | `unit01/lesson06` | authored |
| 1.7 | Function Model Selection and Construction | CED 1.13 + 1.14 | `unit01/lesson07` | authored |

The function toolkit (transformations, composition, inverses) is pulled forward out of the
CED's Unit 2 so every later unit can lean on it — inverses land before exponentials need
them. Unit 1 is the only unit that currently carries `tests/`, `test_keys/`,
`sample_test/`, and `sample_test_key/` directories.

## Unit 2 — Polynomial Functions  *(fully authored)*

> How does the algebraic structure of a polynomial reveal the key features of its graph?
> How do zeros, multiplicity, and end behavior determine what a polynomial function can model?

| # | Lesson | CED source | Dir | Status |
|---|--------|-----------|-----|--------|
| 2.0 | Introduction to Polynomial Functions | New (unit opener) | `unit02/lesson00` | authored |
| 2.1 | Quadratic Functions Revisited | New (extends CED 1.3) | `unit02/lesson01` | authored |
| 2.2 | Polynomial Functions and Rates of Change | CED 1.4 | `unit02/lesson02` | authored |
| 2.3 | Polynomial Functions and Real Zeros | New (split of CED 1.5) | `unit02/lesson03` | authored |
| 2.4 | Polynomial Functions and Complex Zeros | CED 1.5 | `unit02/lesson04` | authored |
| 2.5 | Polynomial Functions and End Behavior | CED 1.6 | `unit02/lesson05` | authored |
| 2.6 | Equivalent Representations of Polynomial Expressions | New (split of CED 1.11) | `unit02/lesson06` | authored |
| 2.7 | Polynomial Equations, Inequalities, and Modeling | New (absorbs CED 1.14 modeling) | `unit02/lesson07` | authored |

The CED's three dense polynomial lessons become eight. Real zeros stay separated from
complex zeros — the unit's main concession to the non-honors pace. The old standalone
Modeling lesson (`unit02/lesson08`) is retired; its open-box model, context-driven domain
restriction, and regression route folded into 2.7.

## Unit 3 — Rational Functions

> How does the ratio of two polynomials create new behavior — zeros, asymptotes, and holes?
> How do we read the graph of a rational function from its equation, and the equation from
> its graph?

| # | Lesson | CED source | Dir | Status |
|---|--------|-----------|-----|--------|
| 3.1 | Rational Functions and End Behavior | CED 1.7 | `unit03/lesson01` | moved |
| 3.2 | Rational Functions and Zeros | CED 1.8 | `unit03/lesson02` | moved |
| 3.3 | Rational Functions and Vertical Asymptotes | CED 1.9 | `unit03/lesson03` | moved |
| 3.4 | Rational Functions and Holes | CED 1.10 | `unit03/lesson04` | moved |
| 3.5 | Equivalent Representations of Rational Expressions | CED 1.11 | `unit03/lesson05` | moved |
| 3.6 | Graphing Rational Functions | New (synthesis) | `unit03/lesson06` | new |
| 3.7 | Rational Equations and Inequalities | New | `unit03/lesson07` | new |
| 3.8 | Modeling with Rational Functions | New | `unit03/lesson08` | new |

Rational-function behavior is the closest precalculus gets to limit language, so it earns
a full unit. Old CED 1.11 covered polynomial *and* rational equivalence; its file lives
here as 3.5 and the polynomial half was reauthored separately as 2.6.

## Unit 4 — Exponential Functions

> What distinguishes exponential change from linear change?
> How do we build, compare, and validate exponential models of real data?

| # | Lesson | CED source | Dir | Status |
|---|--------|-----------|-----|--------|
| 4.1 | Change in Arithmetic and Geometric Sequences | CED 2.1 | `unit04/lesson01` | moved |
| 4.2 | Change in Linear and Exponential Functions | CED 2.2 | `unit04/lesson02` | moved |
| 4.3 | Exponential Functions | CED 2.3 | `unit04/lesson03` | moved |
| 4.4 | Exponential Function Manipulation | CED 2.4 | `unit04/lesson04` | moved |
| 4.5 | The Number e and Continuous Growth | New (calculus preparation) | `unit04/lesson05` | new |
| 4.6 | Exponential Function Context and Data Modeling | CED 2.5 | `unit04/lesson06` | moved |
| 4.7 | Competing Function Model Validation | CED 2.6 | `unit04/lesson07` | moved |
| 4.8 | Growth, Decay, and Interest Applications | New | `unit04/lesson08` | new |

## Unit 5 — Logarithmic Functions

> Why do logarithms undo exponentials, and how does that inverse relationship let us solve
> equations?
> How do logarithmic scales make multiplicative change readable?

| # | Lesson | CED source | Dir | Status |
|---|--------|-----------|-----|--------|
| 5.1 | Logarithmic Expressions | CED 2.9 | `unit05/lesson01` | moved |
| 5.2 | Inverses of Exponential Functions | CED 2.10 | `unit05/lesson02` | moved |
| 5.3 | Logarithmic Functions | CED 2.11 | `unit05/lesson03` | moved |
| 5.4 | Logarithmic Function Manipulation | CED 2.12 | `unit05/lesson04` | moved |
| 5.5 | Exponential Equations and Inequalities | New (split of CED 2.13) | `unit05/lesson05` | new |
| 5.6 | Logarithmic Equations and Inequalities | CED 2.13 | `unit05/lesson06` | moved |
| 5.7 | Logarithmic Function Context and Data Modeling | CED 2.14 | `unit05/lesson07` | moved |
| 5.8 | Semi-log Plots | CED 2.15 | `unit05/lesson08` | moved |

CED 2.13 packs exponential and logarithmic equation-solving into one lesson; here they are
taken one at a time (5.5 exponential, 5.6 logarithmic).

## Unit 6 — Trigonometric Functions

> How do sine and cosine turn motion around a circle into functions we can graph and analyze?
> How do we model periodic phenomena with sinusoidal functions?

| # | Lesson | CED source | Dir | Status |
|---|--------|-----------|-----|--------|
| 6.1 | Periodic Phenomena | CED 3.1 | `unit06/lesson01` | moved |
| 6.2 | Angles and Radian Measure | New (split of CED 3.2) | `unit06/lesson02` | new |
| 6.3 | Sine, Cosine, and Tangent | CED 3.2 | `unit06/lesson03` | moved |
| 6.4 | Sine and Cosine Function Values | CED 3.3 | `unit06/lesson04` | moved |
| 6.5 | Sine and Cosine Function Graphs | CED 3.4 | `unit06/lesson05` | moved |
| 6.6 | Sinusoidal Functions | CED 3.5 | `unit06/lesson06` | moved |
| 6.7 | Sinusoidal Function Transformations | CED 3.6 | `unit06/lesson07` | moved |
| 6.8 | Sinusoidal Function Context and Data Modeling | CED 3.7 | `unit06/lesson08` | moved |

Radian measure gets a standalone lesson before the unit circle — the most common
non-honors stumbling block, and non-negotiable for calculus.

## Unit 7 — Analytic Trigonometry and Polar Coordinates

> How do inverse trigonometric functions and identities let us solve trigonometric
> equations exactly?
> What does the polar coordinate system reveal that Cartesian coordinates hide?

| # | Lesson | CED source | Dir | Status |
|---|--------|-----------|-----|--------|
| 7.1 | The Tangent Function | CED 3.8 | `unit07/lesson01` | moved |
| 7.2 | Inverse Trigonometric Functions | CED 3.9 | `unit07/lesson02` | moved |
| 7.3 | Trigonometric Equations and Inequalities | CED 3.10 | `unit07/lesson03` | moved |
| 7.4 | The Secant, Cosecant, and Cotangent Functions | CED 3.11 | `unit07/lesson04` | moved |
| 7.5 | Equivalent Representations of Trigonometric Functions | CED 3.12 | `unit07/lesson05` | moved |
| 7.6 | Trigonometry and Polar Coordinates | CED 3.13 | `unit07/lesson06` | moved |
| 7.7 | Polar Function Graphs | CED 3.14 | `unit07/lesson07` | moved |
| 7.8 | Rates of Change in Polar Functions | CED 3.15 | `unit07/lesson08` | moved |

## Unit 8 — Parametric Functions, Vectors, and Matrices

> How do parametric and implicit descriptions widen what a function can describe?
> How do vectors and matrices model motion and transformation in the plane?

| # | Lesson | CED source | Dir | Status |
|---|--------|-----------|-----|--------|
| 8.1 | Parametric Functions and Planar Motion | CED 4.1 + 4.2 | `unit08/lesson01` | moved |
| 8.2 | Parametric Functions and Rates of Change | CED 4.3 | `unit08/lesson02` | moved |
| 8.3 | Parametrically Defined Circles and Lines | CED 4.4 + 4.7 | `unit08/lesson03` | moved |
| 8.4 | Implicitly Defined Functions | CED 4.5 | `unit08/lesson04` | moved |
| 8.5 | Conic Sections | CED 4.6 | `unit08/lesson05` | moved |
| 8.6 | Vectors and Vector-Valued Functions | CED 4.8 + 4.9 | `unit08/lesson06` | moved |
| 8.7 | Matrices and Matrix Operations | CED 4.10 + 4.11 | `unit08/lesson07` | moved |
| 8.8 | Matrices as Transformations and Models | CED 4.12–4.14 | `unit08/lesson08` | moved |

The CED's 14-lesson survey compresses to 8: parametric and implicit descriptions are kept
nearly whole (they pay off in calculus), the vector and matrix material is compressed
hardest.

---

## Authoring status at a glance

| Unit | Authored | Moved (needs reauthoring) | New (skeleton) |
|------|---------|---------------------------|----------------|
| 1 — Functions and Change | 8 | 0 | 0 |
| 2 — Polynomial Functions | 8 | 0 | 0 |
| 3 — Rational Functions | 0 | 5 | 3 |
| 4 — Exponential Functions | 0 | 6 | 2 |
| 5 — Logarithmic Functions | 0 | 7 | 1 |
| 6 — Trigonometric Functions | 0 | 7 | 1 |
| 7 — Analytic Trig and Polar | 0 | 8 | 0 |
| 8 — Parametric, Vectors, Matrices | 0 | 8 | 0 |
| **Total** | **16** | **41** | **7** |

## Structural gaps observed in the tree

- **Units 3–8 have no `X.0` opener.** They number `X.1–X.8` in `lesson01–lesson08`. Per the
  plan, each adopts the `X.0` orientation lesson when it is reauthored — which means
  renumbering, not just adding a directory.
- **Only Unit 1 has test directories** (`tests/`, `test_keys/`, `sample_test/`,
  `sample_test_key/`). Units 2–8 have none, though the plan promises a sample test per unit.
- **15 lessons have no `slides/` deck:** 3.6–3.8, 4.5, 4.8, 5.5, 6.2, and all eight of
  Unit 8. The unauthored Unit 8 lessons predate the slides convention; the rest are
  skeletons.
- **Unit covers 3–8 still use the deprecated `skymid` color**; Units 1–2 use the current
  `lilacmid` plum palette. Each cover is a one-line fix when its unit is reauthored.

## Title drift (file contents vs. `COURSE_PLAN.md`)

These lessons still carry their pre-restructure titles in `\LessonNumberName`; all are
`moved` lessons whose bodies have not been reauthored yet.

| # | Title in the files | Title in `COURSE_PLAN.md` |
|---|-------------------|---------------------------|
| 3.5 | Equivalent Representations of Polynomial and Rational Expressions | Equivalent Representations of Rational Expressions |
| 5.6 | Exponential and Logarithmic Equations and Inequalities | Logarithmic Equations and Inequalities |
| 8.1 | Parametric Functions | Parametric Functions and Planar Motion |
| 8.6 | Vectors | Vectors and Vector-Valued Functions |
| 8.7 | Matrices | Matrices and Matrix Operations |
| 8.8 | Linear Transformations and Matrices | Matrices as Transformations and Models |

The 3.5 and 5.6 titles matter most: both name material that the plan has explicitly moved
elsewhere (the polynomial half to 2.6, the exponential half to 5.5), so their bodies still
duplicate a neighbor's scope.
