#!/usr/bin/env python3
"""Scaffold a new lesson directory for a LaTeX curriculum project.

Creates unitXX/lessonYY/ with a Makefile, the lesson-plan main.tex, and the
requested component subdirectories (each with a correctly-preambled main.tex,
and a matching _key for keyed components). Auto-detects the style-package
prefix and whether course-level macros are already defined in shared/, and
creates the root Makefile and the unit Makefile if they don't exist yet.

Example:
    python new_lesson.py --project . --unit 02 --lesson 03 \
        --title "Composition of Functions" --unit-title "Functions and Their Graphs" \
        --components cover,warmup,notes,activity,exit_ticket,slides
"""
from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

SKEL_DIR = Path(__file__).resolve().parent.parent / "assets" / "skeletons"

KEYED = ["warmup", "notes", "activity", "exit_ticket", "homework"]
NO_KEY = ["cover", "slides"]
ALL_COMPONENTS = KEYED + NO_KEY
# Homework is DeltaMath: `homework` is a valid component but NOT a default. Pass it
# explicitly (--components ...,homework) only for a lesson the user has overridden.
DEFAULT_COMPONENTS = ["cover", "warmup", "notes", "activity", "exit_ticket", "slides"]

DOC_TITLE = {
    "warmup": "Warm-Up",
    "notes": "Guided Notes",
    "activity": "Group Activity",
    "exit_ticket": "Exit Ticket",
    "homework": "Homework",
}
# NAMESTRIP (references/conventions.md): worksheet components carry NO name/date/
# period row — the student writes their name once, on the cover the packet is
# stapled behind, and every repeat costs vertical space at the top of the page.
# Only cover.tex and the unit tests (taken in a testing setting) keep
# \namedateperiod, so newly scaffolded lessons are born namestripped.
NAME_ROW: dict[str, str] = {}


def fail(msg: str) -> "NoReturn":  # type: ignore[name-defined]
    print(f"error: {msg}", file=sys.stderr)
    sys.exit(1)


def detect_prefix(shared: Path) -> str:
    matches = sorted(shared.glob("*-colors.sty"))
    if not matches:
        fail(f"no <prefix>-colors.sty in {shared} — is this a curriculum project root?")
    return matches[0].name[: -len("-colors.sty")]


def shared_defines_coursename(shared: Path) -> bool:
    pat = re.compile(r"\\(?:new|provide)command\{\\CourseName\}")
    return any(pat.search(sty.read_text(encoding="utf-8", errors="ignore")) for sty in shared.glob("*.sty"))


def detect_course_name(shared: Path) -> str | None:
    pat = re.compile(r"\\(?:new|provide)command\{\\CourseName\}\{([^}]*)\}")
    for sty in shared.glob("*.sty"):
        m = pat.search(sty.read_text(encoding="utf-8", errors="ignore"))
        if m:
            return m.group(1).strip()
    return None


def render(name: str, subs: dict[str, str]) -> str:
    text = (SKEL_DIR / name).read_text(encoding="utf-8")
    for token, value in subs.items():
        text = text.replace(f"@@{token}@@", value)
    return text


def write(path: Path, content: str, force: bool) -> None:
    if path.exists() and not force:
        fail(f"{path} already exists (use --force to overwrite)")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    print(f"  + {path}")


def ensure(path: Path, content: str) -> None:
    """Create a file only if it does not already exist (never clobbers)."""
    if path.exists():
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    print(f"  + {path}")


def prefab_dir(path: Path) -> None:
    """Create an empty component directory for a dropped-in prefab PDF.

    No main.tex is written; the user drops the PDF as <dir>/main.pdf and the
    refactored lesson.mk merges it directly. A .gitkeep keeps the empty dir tracked.
    """
    path.mkdir(parents=True, exist_ok=True)
    gitkeep = path / ".gitkeep"
    if not gitkeep.exists():
        gitkeep.write_text("", encoding="utf-8")
    print(f"  + {path}/  (drop the prefab PDF here as main.pdf)")


def scaffold_unit_tests(project: Path, unit_dir: str, unit_int: str,
                        unit_title: str, prefix: str) -> None:
    """Scaffold a unit's summative-assessment components (idempotent via ensure()).

    Creates four sibling dirs under the unit:
      tests/           practice_test + actual_test (blank), thin-include Makefile
      test_keys/       practice_test_key + actual_test_key, thin-include Makefile
      sample_test/     drop-in for the PDF the tests/ `drop` target publishes
      sample_test_key/ drop-in for the PDF the test_keys/ `drop` target publishes
    The practice test/key double as the sample_test/sample_test_key that
    shared/unit.mk merges into the student/key packets; the actual test/key stay
    out of every packet.
    """
    udir = project / unit_dir
    print(f"  unit tests for {unit_dir}/ ...")
    ensure(udir / "tests" / "Makefile", "include ../../shared/tests.mk\n")
    ensure(udir / "test_keys" / "Makefile", "include ../../shared/test_keys.mk\n")

    practice_intro = (
        "\n\\vspace{0.10in}\n"
        "\\begin{remindbox}\n\\small\n"
        f"\\textbf{{This is a practice test.}} It mirrors the real Unit {unit_int} test in "
        "length, format,\nand the ideas it covers, but the numbers and contexts differ. Work "
        "every problem\nwith no notes, then check your answers against the key.\n"
        "\\end{remindbox}\n"
    )
    actual_intro = (
        "\n\\vspace{0.06in}\n"
        "\\noindent\\textbf{Instructions:} Show all work. No notes unless your teacher says so.\n"
    )
    tbase = {"PREFIX": prefix, "UNITINT": unit_int, "UNITTITLE": unit_title}

    ensure(udir / "tests" / "practice_test" / "main.tex",
           render("test.tex", {**tbase, "TESTKIND": "Practice Test --- Study Copy",
                                "TESTINTRO": practice_intro}))
    ensure(udir / "tests" / "actual_test" / "main.tex",
           render("test.tex", {**tbase, "TESTKIND": "Unit Test", "TESTINTRO": actual_intro}))
    ensure(udir / "test_keys" / "practice_test_key" / "main.tex",
           render("test_key.tex", {**tbase, "TESTKIND": "Practice Test --- Study Copy"}))
    ensure(udir / "test_keys" / "actual_test_key" / "main.tex",
           render("test_key.tex", {**tbase, "TESTKIND": "Unit Test"}))

    for d in ("sample_test", "sample_test_key"):
        gitkeep = udir / d / ".gitkeep"
        if not gitkeep.exists():
            gitkeep.parent.mkdir(parents=True, exist_ok=True)
            gitkeep.write_text("", encoding="utf-8")
            print(f"  + {gitkeep.parent}/  (sample-test PDF published here by the tests/ drop)")


def main() -> None:
    p = argparse.ArgumentParser(description="Scaffold a new lesson directory.")
    p.add_argument("--project", default=".", help="path to the curriculum project root "
                                                  "(contains shared/); defaults to the current directory")
    p.add_argument("--unit", required=True, help="unit number, e.g. 03")
    p.add_argument("--lesson", required=True, help="lesson number, e.g. 01")
    p.add_argument("--lesson-id", help="human lesson id for headers, e.g. 3.1 (default: <unit>.<lesson>)")
    p.add_argument("--title", default="TODO: Lesson Title", help="lesson/topic title")
    p.add_argument("--unit-title", default="TODO: Unit Title", help="unit title for the lesson plan")
    p.add_argument("--components", default=",".join(DEFAULT_COMPONENTS),
                   help=f"comma list from {ALL_COMPONENTS}")
    p.add_argument("--prefab", default="", help="comma list of dirs that will hold a dropped-in "
                                                "prefab PDF (placed as <dir>/main.pdf), e.g. warmup,warmup_key")
    p.add_argument("--course", help="course name for cover/slides (default: detected or 'TODO Course')")
    p.add_argument("--meeting-length", default="55 minutes", help="meeting length (used only if not in shared/)")
    p.add_argument("--no-plan", action="store_true", help="do not scaffold the lesson-plan main.tex")
    p.add_argument("--tests", action="store_true", help="also (re)scaffold the unit's test "
                                                        "dirs even if the unit already exists (idempotent)")
    p.add_argument("--no-tests", action="store_true", help="do not scaffold the unit's test dirs")
    p.add_argument("--force", action="store_true", help="overwrite existing files")
    args = p.parse_args()

    project = Path(args.project).expanduser().resolve()
    shared = project / "shared"
    if not shared.is_dir():
        fail(f"{shared} not found")

    prefix = detect_prefix(shared)
    unit_dir = f"unit{int(args.unit):02d}"
    lesson_dir = f"lesson{int(args.lesson):02d}"
    unit_int = str(int(args.unit))
    lesson_id = args.lesson_id or f"{int(args.unit)}.{int(args.lesson)}"

    components = [c.strip() for c in args.components.split(",") if c.strip()]
    bad = [c for c in components if c not in ALL_COMPONENTS]
    if bad:
        fail(f"unknown component(s): {bad}. Allowed: {ALL_COMPONENTS}")
    prefab = {c.strip() for c in args.prefab.split(",") if c.strip()}

    if "slides" in components and not list(shared.glob("*-beamer.sty")):
        fail("slides requested but no <prefix>-beamer.sty in shared/ — this course has no "
             "beamer theme, so the slides component cannot be built. Drop 'slides'.")

    course_name = args.course or detect_course_name(shared) or "TODO Course"
    if shared_defines_coursename(shared):
        course_macros = ""
    else:
        course_macros = (
            f"\\newcommand{{\\CourseName}}{{{course_name}}}\n"
            f"\\newcommand{{\\MeetingLength}}{{{args.meeting_length}}}\n"
        )

    base = {
        "PREFIX": prefix, "UNITINT": unit_int, "LESSONID": lesson_id,
        "TITLE": args.title, "COURSENAME": course_name,
    }

    dest = project / unit_dir / lesson_dir
    print(f"prefix={prefix}  ->  {dest.relative_to(project)}  (course: {course_name}, "
          f"macros {'in shared' if not course_macros else 'inlined in plan'})")

    write(dest / "Makefile", "include ../../shared/lesson.mk\n", args.force)
    (dest / "images").mkdir(parents=True, exist_ok=True)

    # Ensure the build hierarchy above this lesson exists. The root Makefile and the
    # unit Makefile are thin includes of shared/*.mk; create them only if missing so
    # re-scaffolding later lessons never clobbers them.
    unit_makefile = project / unit_dir / "Makefile"
    unit_is_new = not unit_makefile.exists()
    ensure(project / "Makefile", "include shared/root.mk\n")
    ensure(unit_makefile, "include ../shared/unit.mk\n")

    # Scaffold the unit's summative-assessment components when the unit is first created
    # (or when --tests forces it). Skipped with --no-tests. ensure() never clobbers, so
    # authored tests survive re-scaffolding of later lessons.
    scaffold_tests = not args.no_tests and (unit_is_new or args.tests)
    if scaffold_tests:
        scaffold_unit_tests(project, unit_dir, unit_int, args.unit_title, prefix)

    if not args.no_plan:
        # The spiral review is ALWAYS text-only. Warm-up thumbnails via
        # \includegraphics{warmup/main} are not used in this course or any other:
        # they couple the plan to build order, break whenever the warm-up is
        # authored rather than prefab, and add nothing a sentence doesn't say.
        spiral = ("    % TODO: list the prerequisite skills this warm-up reviews,\n"
                  "    % in words. Do not embed a warm-up thumbnail.")
        write(dest / "main.tex",
              render("lesson_plan.tex", {**base, "UNITTITLE": args.unit_title,
                                         "COURSEMACROS": course_macros, "SPIRALWARMUP": spiral}),
              args.force)

    for comp in components:
        name_row = NAME_ROW.get(comp, "")   # namestripped: see NAME_ROW above
        if comp in prefab:
            prefab_dir(dest / comp)
        elif comp == "cover":
            write(dest / "cover" / "main.tex", render("cover.tex", base), args.force)
        elif comp == "slides":
            write(dest / "slides" / "main.tex", render("slides.tex", base), args.force)
        else:  # authored worksheet component
            subs = {**base, "DOCTITLE": DOC_TITLE[comp], "NAMEROW": name_row}
            write(dest / comp / "main.tex", render("worksheet.tex", subs), args.force)
        # answer key for keyed components
        if comp in KEYED:
            key = f"{comp}_key"
            if key in prefab:
                prefab_dir(dest / key)
            else:
                subs = {**base, "DOCTITLE": DOC_TITLE[comp], "NAMEROW": name_row}
                write(dest / key / "main.tex", render("worksheet_key.tex", subs), args.force)

    # Numbered at runtime so the list stays 1..n whatever was scaffolded.
    steps = ["Author the skeletons (see references/components.md)."]
    if prefab:
        steps.append(f"Drop supplied PDFs as main.pdf in: {', '.join(sorted(prefab))}")
    steps.append(f"Build:  make -C {unit_dir}/{lesson_dir} all")
    steps.append(f"Gate it:  make -C {unit_dir}/{lesson_dir} check")
    if scaffold_tests:
        steps.append(f"Author the unit tests in {unit_dir}/tests/ and {unit_dir}/test_keys/,\n"
                     f"     then publish the sample test:  make -C {unit_dir}/tests all && "
                     f"make -C {unit_dir}/test_keys all")
    print("\nnext:")
    for i, step in enumerate(steps, 1):
        print(f"  {i}. {step}")
    print("\n  Homework is DeltaMath: no homework/ was scaffolded. Add ,homework to")
    print("  --components only for a lesson the user has explicitly overridden.")


if __name__ == "__main__":
    main()
