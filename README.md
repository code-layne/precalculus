# precalculus

Non-honors Precalculus: 8 units × 8 lessons. See [COURSE_PLAN.md](COURSE_PLAN.md)
for the unit/lesson map, content sources, and the reauthoring checklist.

## Getting the source

`math-shared/` is a git submodule, [code-layne/math-shared](https://github.com/code-layne/math-shared),
which holds the grading package shared across the courses. It sits at the project root, not under
`shared/`: the build searches `shared/` recursively, and `math-shared/examples` holds `main.tex`
files a component build would pick up. Clone with it:

```bash
git clone --recurse-submodules https://github.com/code-layne/precalculus
```

In a clone made without `--recurse-submodules`, run `git submodule update --init` once. Ordinary
builds still work without the submodule; only components that load `grading` and the grading
targets below need it.

## Graded components

A component that loads `grading` (from `math-shared/grading.sty`) marks its graded answers with
`\gradedblank`. Each page then carries corner registration marks, a QR code, and a name strip.
Each `\gradedblank` line is written identically in the blank and the key; the key prints the
answer inside the box (`precalculus-key` turns this on whenever a document loads `grading`). See
`math-shared/README.md` for the macros and `math-shared/grading-system-design.md` for the plan,
and the "Graded components" section of [LESSON_SHAPE.md](LESSON_SHAPE.md) for which components
are graded and how their assignment ids are formed.

```bash
make -C unit03/lesson01 manifest COMP=homework
make -C unit03/lesson01 roster-packets COMP=homework ROSTER=~/Rosters/precalculus/roster-map.csv
make -C unit01/tests manifest COMP=practice_test
make -C unit01/tests roster-packets COMP=actual_test ROSTER=~/Rosters/precalculus/roster-map.csv
make -C unit01 manifest COMP=lesson02/ap_practice     # unit level: delegates to the lesson or tests/
```
