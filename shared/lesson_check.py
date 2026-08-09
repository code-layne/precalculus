#!/usr/bin/env python3
"""Convention gate for a lesson: fail the build on the things `make` can't see.

A LaTeX compile exits 0 on a key that runs a page longer than its blank, on a
two-page exit ticket, and on a stranded box. Those are the failures that cost a
student packet a padding page, and until now nothing but a human noticed them.
This script is that check, wired into `make check` at the lesson, unit, and root
levels (shared/lesson.mk).

What it enforces, per lesson:

  page parity   every keyed component has the SAME page count as its _key
                (the work rule's observable consequence)
  one-pagers    warmup and exit_ticket are exactly 1 page, blank AND key
  ans-in-math   no \\ans / \\ansline / \\vocabans inside $...$, \\[...\\] or \\(...\\)
                — \\ans is a text-mode macro and the compile error it throws is
                unhelpful, so catch it at the source. (\\vocabans is not defined
                in precalculus-key.sty; it stays in the pattern so the check
                keeps working if the vocab key macro is added later.)
  teachernote   no \\begin{teachernote} in a lesson component's _key (it belongs
                in the lesson plan). tests/ is outside this gate — a unit test's
                scoring notes go on page 2 of unitXX/unit_cover_key/, which is
                merged into the key packet only and is checked by hand.
  namestrip     no live \\namedateperiod / \\namepartnerperiod on a worksheet
                component — the cover carries it, and tests keep it

vocabpar is NOT checked: it is enforced structurally by \\termblanklong, which
opens with its own \\par (see precalculus-article.sty).

The page checks need the components compiled; `make check` depends on the build
stamps, so run it through make rather than directly. Exit status is 1 if any
check fails, so it works as a CI/review gate.

Usage:
    python3 shared/lesson_check.py unit08/lesson03           # one lesson
    python3 shared/lesson_check.py unit08                    # every lesson in a unit
    python3 shared/lesson_check.py --all                     # every lesson in the project
    python3 shared/lesson_check.py unit08/lesson03 --no-pages   # source checks only
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

KEYED = ["warmup", "notes", "activity", "exit_ticket", "homework"]
ONE_PAGE = ["warmup", "exit_ticket"]
WORKSHEETS = KEYED + [f"{c}_key" for c in KEYED]

ANS_MACROS = re.compile(r"\\(?:ansline|ans|vocabans)\b")
NAME_ROW = re.compile(r"\\name(?:dateperiod|partnerperiod)\b")
TEACHERNOTE = re.compile(r"\\begin\{teachernote\}")


class Report:
    """Collects failures so one run reports every problem, not just the first."""

    def __init__(self) -> None:
        self.failures: list[tuple[str, str]] = []

    def fail(self, where: str, msg: str) -> None:
        self.failures.append((where, msg))

    @property
    def ok(self) -> bool:
        return not self.failures


def strip_comments(text: str) -> str:
    """Blank out LaTeX comments, preserving offsets so positions stay meaningful.

    A % starts a comment unless escaped (\\%). Replacing the run with spaces
    rather than deleting it keeps every later index identical to the original.
    """
    out = list(text)
    i, n = 0, len(text)
    while i < n:
        c = text[i]
        if c == "\\":            # skip the escaped character
            i += 2
            continue
        if c == "%":
            j = text.find("\n", i)
            j = n if j < 0 else j
            for k in range(i, j):
                out[k] = " "
            i = j
        else:
            i += 1
    return "".join(out)


def math_spans(text: str) -> list[tuple[int, int]]:
    """Index ranges covered by math mode: $...$, $$...$$, \\[...\\], \\(...\\)."""
    spans: list[tuple[int, int]] = []
    i, n = 0, len(text)
    while i < n:
        c = text[i]
        if c == "\\":
            nxt = text[i + 1 : i + 2]
            if nxt in ("[", "("):
                close = "\\]" if nxt == "[" else "\\)"
                j = text.find(close, i + 2)
                j = n if j < 0 else j + 2
                spans.append((i, j))
                i = j
                continue
            i += 2                       # any other escape, incl. \$
            continue
        if c == "$":
            delim = "$$" if text[i : i + 2] == "$$" else "$"
            j = i + len(delim)
            while j < n:
                if text[j] == "\\":
                    j += 2
                    continue
                if text.startswith(delim, j):
                    j += len(delim)
                    break
                j += 1
            spans.append((i, min(j, n)))
            i = min(j, n)
            continue
        i += 1
    return spans


def line_of(text: str, pos: int) -> int:
    return text.count("\n", 0, pos) + 1


def pages(pdf: Path) -> int | None:
    try:
        out = subprocess.run(["pdfinfo", str(pdf)], capture_output=True, text=True, check=True).stdout
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None
    m = re.search(r"^Pages:\s+(\d+)", out, re.M)
    return int(m.group(1)) if m else None


def check_source(lesson: Path, rel: str, rep: Report) -> None:
    """Source-level checks over every main.tex in the lesson."""
    for tex in sorted(lesson.glob("*/main.tex")) + sorted(lesson.glob("main.tex")):
        comp = tex.parent.name if tex.parent != lesson else "(lesson plan)"
        where = f"{rel}/{comp}"
        raw = tex.read_text(encoding="utf-8", errors="ignore")
        body = strip_comments(raw)
        spans = math_spans(body)

        # ans-in-math: \ans is \textcolor{...}{\textbf{...}}, a text-mode macro.
        for m in ANS_MACROS.finditer(body):
            if any(a <= m.start() < b for a, b in spans):
                rep.fail(where, f"line {line_of(body, m.start())}: {m.group(0)} inside math mode "
                                f"— close the math first, or wrap the fragment: \\ans{{$x$}}")

        # teachernote belongs in the lesson plan, never in a component key.
        if comp.endswith("_key"):
            for m in TEACHERNOTE.finditer(body):
                rep.fail(where, f"line {line_of(body, m.start())}: \\begin{{teachernote}} in a key "
                                f"— move it to the lesson plan as \\begin{{teachernote}}[{comp[:-4]}]")

        # namestrip: the cover carries the name row; worksheet components do not.
        if comp in WORKSHEETS:
            for m in NAME_ROW.finditer(body):
                rep.fail(where, f"line {line_of(body, m.start())}: {m.group(0)} on a worksheet "
                                f"component — the name row belongs on the cover only")


def check_pages(lesson: Path, rel: str, target: Path, rep: Report) -> None:
    """Page-count checks against the compiled per-component PDFs."""
    for comp in KEYED:
        blank_src, key_src = lesson / comp, lesson / f"{comp}_key"
        if not blank_src.is_dir():
            continue

        # A component is either compiled (main.tex → target/) or prefab (main.pdf in place).
        def pdf_for(d: Path) -> Path | None:
            if (d / "main.tex").exists():
                return target / d.name / "main.pdf"
            return d / "main.pdf" if (d / "main.pdf").exists() else None

        bp_path, kp_path = pdf_for(blank_src), pdf_for(key_src) if key_src.is_dir() else None
        bp = pages(bp_path) if bp_path and bp_path.exists() else None
        kp = pages(kp_path) if kp_path and kp_path.exists() else None

        if bp is None:
            rep.fail(f"{rel}/{comp}", "no compiled PDF — run `make all` before `make check`")
            continue

        if kp is not None and bp != kp:
            rep.fail(f"{rel}/{comp}", f"page mismatch: blank={bp}, key={kp} — the shorter one gets "
                                      f"padded, costing the packet a blank page. Use a `work` block "
                                      f"or size \\writelines{{n}} against the key's true length")

        if comp in ONE_PAGE:
            if bp != 1:
                rep.fail(f"{rel}/{comp}", f"{comp} is {bp} pages — it must fit exactly 1")
            if kp is not None and kp != 1:
                rep.fail(f"{rel}/{comp}_key", f"{comp}_key is {kp} pages — it must fit exactly 1")


def lessons_under(root: Path, arg: str | None, everything: bool) -> list[Path]:
    if everything:
        return sorted(p for p in root.glob("unit*/lesson*") if p.is_dir())
    if arg is None:
        return []
    p = (root / arg).resolve()
    if not p.is_dir():
        sys.exit(f"error: {p} is not a directory")
    if p.name.startswith("lesson"):
        return [p]
    return sorted(q for q in p.glob("lesson*") if q.is_dir())


def main() -> None:
    ap = argparse.ArgumentParser(description="Convention gate for lessons (see module docstring).")
    ap.add_argument("path", nargs="?", help="unitXX/lessonYY, or unitXX for every lesson in it")
    ap.add_argument("--project", default=".", help="project root (contains shared/); default cwd")
    ap.add_argument("--all", action="store_true", help="check every lesson in the project")
    ap.add_argument("--no-pages", action="store_true", help="skip checks that need compiled PDFs")
    args = ap.parse_args()

    root = Path(args.project).expanduser().resolve()
    targets = lessons_under(root, args.path, args.all)
    if not targets:
        sys.exit("error: nothing to check — pass unitXX/lessonYY, unitXX, or --all")

    rep = Report()
    for lesson in targets:
        rel = lesson.relative_to(root).as_posix()
        check_source(lesson, rel, rep)
        if not args.no_pages:
            check_pages(lesson, rel, root / "target" / lesson.parent.name / lesson.name, rep)

    scope = f"{len(targets)} lesson{'s' if len(targets) != 1 else ''}"
    if rep.ok:
        print(f"✓  check passed — {scope}, no convention violations")
        return

    print(f"✗  check FAILED — {len(rep.failures)} violation(s) across {scope}\n", file=sys.stderr)
    width = max(len(w) for w, _ in rep.failures)
    for where, msg in rep.failures:
        print(f"   {where:<{width}}  {msg}", file=sys.stderr)
    print("\n   See .claude/skills/lesson-planning/references/conventions.md", file=sys.stderr)
    sys.exit(1)


if __name__ == "__main__":
    main()
