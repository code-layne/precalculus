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
`\gradedblank`. Each page then carries corner registration marks, a QR code, and an id strip
(`ID: <tracking id>`). Graded pages never carry a student name.
Each `\gradedblank` line is written identically in the blank and the key; the key prints the
answer inside the box (`precalculus-key` turns this on whenever a document loads `grading`). See
`math-shared/README.md` for the macros and `math-shared/grading-system-design.md` for the plan,
and the "Graded components" section of [LESSON_SHAPE.md](LESSON_SHAPE.md) for which components
are graded and how their assignment ids are formed.

```bash
# a lesson component: manifest.json, and the check that blank and key agree
make -C unit03/lesson01 manifest COMP=homework
# per student: the lesson packet with her name on the cover and her copy of every graded component
make -C unit03/lesson01 roster-packets ROSTER=~/Mathematics/rosters/roster-map.csv SECTION="Precalculus"

# a unit test (also runnable from tests/ or test_keys/ with the bare name)
make -C unit01 manifest COMP=tests/practice_test
make -C unit01 roster-packets COMP=tests/actual_test ROSTER=~/Mathematics/rosters/roster-map.csv

# the same from the root
make roster-packets LESSON=unit03/lesson01 ROSTER=~/Mathematics/rosters/roster-map.csv
make roster-packets COMP=unit01/tests/actual_test ROSTER=~/Mathematics/rosters/roster-map.csv
make manifest COMP=unit01/lesson02/ap_practice
```

Scanned pages go to an outside service, so a graded page carries only the student's tracking id.
In a lesson packet the name is printed on the Name line of the lesson cover. Every graded
component (AP Practice, a printed homework) starts on a fresh sheet, so the student tears those
sheets out and turns them in, and the cover stays in her packet. The lesson's roster PDF is
`target/compiled/unitXX/lessonYY_roster.pdf`, one packet per student in roster order, paginated
like `make student`. A test instead gets math-shared's tear-off name sheet: each student's run
(name sheet, blank back, copy, and a blank page if the copy is odd) is even, so every name sheet
starts on an odd page when the roster PDF prints duplex. Both builds write each graded
component's `manifest.json` first, which `grading ingest` reads. `SECTION=` builds one section.
The roster PDFs hold names, so they stay under `target/`, which is never committed; the build
fails if a name reaches a graded page. Keep `roster-map.csv` outside the repository.
