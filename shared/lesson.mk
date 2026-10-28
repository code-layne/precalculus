# shared/lesson.mk — included by every lesson-level Makefile.
# Auto-detects PROJECT_ROOT, UNIT, and LESSON from CURDIR.
#
# A lesson builds FIVE work products into target/compiled/$(UNIT)/:
#   lessonYY_plan.pdf     the teacher-facing lesson plan (the lesson-root main.tex)
#   lessonYY_slides.pdf   the Beamer deck, PRINTED: 3 slides per page in a two-
#                         column layout, each slide with a ruled note area beside it
#   lessonYY_slides.pptx  the same deck wrapped for PowerPoint, full-page (page image
#                         per slide) — the projected form
#
# The two slide products are the deck's two forms: the PDF is what you print and
# hand out, the PPTX is what you project. Both come from the one Beamer deck
# compiled at target/$(UNIT)/$(LESSON)/slides/main.pdf, which is the source of
# truth — never edit either product, edit slides/main.tex and rebuild.
#   lessonYY_student.pdf  cover + blank components, paginated packet-wide
#   lessonYY_key.pdf      the same packet answered, page for page with the student one
#
# A component subdirectory may provide EITHER:
#   - main.tex  → compiled with latexmk to target/.../<comp>/main.pdf, or
#   - main.pdf  → a prefab PDF, used as-is straight from the source tree.
# Either form is discovered and merged into the packet by pdfunite.

PROJECT_ROOT := $(abspath ../..)
# override: a LESSON= given to the root or unit `make roster-packets` reaches
# this make through MAKEFLAGS, and must not replace the lesson's own name.
override UNIT   := $(notdir $(abspath ..))
override LESSON := $(notdir $(CURDIR))

SHARED_STYS  := $(wildcard $(PROJECT_ROOT)/shared/*.sty)
# TeX search path: the course packages (recursive), then math-shared (the
# submodule at the project root, for grading.sty). math-shared is listed
# NON-recursively and lives outside shared/ because math-shared/examples holds
# main.tex files: kpathsea resolves even the main file through TEXINPUTS, so a
# recursive path reaching them would make a component build compile an
# example's main.tex instead of its own.
TEXINPUTS    := $(PROJECT_ROOT)/shared//:$(PROJECT_ROOT)/math-shared:
LATEXMK      = latexmk
LATEXFLAGS   = -xelatex \
               -interaction=nonstopmode \
               -halt-on-error \
               -file-line-error

STAMP_DIR    := $(PROJECT_ROOT)/.stamps/$(UNIT)/$(LESSON)
PDF_DIR      := $(PROJECT_ROOT)/target/$(UNIT)/$(LESSON)
COMPILED_DIR := $(PROJECT_ROOT)/target/compiled/$(UNIT)

# ── Component helpers ─────────────────────────────────────────────────────────
# A component "exists" if its directory holds a main.tex or a prefab main.pdf.
#   comp-present $1 → the dir name if usable, else empty
#   comp-pdf     $1 → the PDF to feed pdfunite: compiled target if main.tex,
#                     otherwise the source main.pdf used as-is
#   comp-stamp   $1 → a build stamp ONLY for tex components (prefab PDFs don't compile)
comp-present = $(if $(or $(wildcard $1/main.tex),$(wildcard $1/main.pdf)),$1)
comp-pdf     = $(if $(wildcard $1/main.tex),$(PDF_DIR)/$1/main.pdf,$1/main.pdf)
comp-stamp   = $(if $(wildcard $1/main.tex),$(STAMP_DIR)/$1/main.stamp)

# ── Component discovery (in pedagogical order) ────────────────────────────────
STUDENT_ORDER := cover warmup notes activity exit_ticket ap_practice homework
KEYED_PAIRS   := warmup notes activity exit_ticket ap_practice homework

STUDENT_COMPS := $(foreach c,$(STUDENT_ORDER),$(call comp-present,$(c)))

# Key packet: the student packet with every blank component swapped for its key.
# Derived from STUDENT_COMPS (not KEYED_PAIRS) so the two packets pair up 1:1,
# component for component — that pairing is what lets the pagination pass give
# both packets identical page boundaries. A component with no _key sibling
# (cover) appears unchanged in both.
key-of        = $(or $(call comp-present,$1_key),$1)
KEY_COMPS     := $(foreach c,$(STUDENT_COMPS),$(call key-of,$(c)))

# Root lesson plan and slides may also be prefab PDFs.
# comp-dep is the prerequisite that guarantees the PDF exists: the build stamp
# for a compiled component, or the source PDF itself for a prefab (which has no
# rule to build it). Using comp-pdf as a prerequisite would break the prefab
# case — a compiled target under target/ has no rule of its own.
comp-dep      = $(if $(wildcard $1/main.tex),$(STAMP_DIR)/$1/main.stamp,$(wildcard $1/main.pdf))

HAS_ROOT      := $(or $(wildcard main.tex),$(wildcard main.pdf))
ROOT_STAMP    := $(if $(wildcard main.tex),$(STAMP_DIR)/main.stamp)
ROOT_PDF      := $(if $(HAS_ROOT),$(if $(wildcard main.tex),$(PDF_DIR)/main.pdf,main.pdf))
ROOT_DEP      := $(if $(wildcard main.tex),$(STAMP_DIR)/main.stamp,$(wildcard main.pdf))

HAS_SLIDES    := $(call comp-present,slides)
SLIDES_STAMP  := $(call comp-stamp,slides)
SLIDES_PDF    := $(if $(HAS_SLIDES),$(call comp-pdf,slides))
SLIDES_DEP    := $(if $(HAS_SLIDES),$(call comp-dep,slides))

# ── Stamp and PDF lists ───────────────────────────────────────────────────────
# Stamps drive compilation (tex only); PDF lists drive the pdfunite merge.
STUDENT_STAMPS := $(foreach c,$(STUDENT_COMPS),$(call comp-stamp,$(c)))
STUDENT_PDFS   := $(foreach c,$(STUDENT_COMPS),$(call comp-pdf,$(c)))

KEY_STAMPS     := $(foreach c,$(KEY_COMPS),$(call comp-stamp,$(c)))
KEY_PDFS       := $(foreach c,$(KEY_COMPS),$(call comp-pdf,$(c)))

# ── The five work products ────────────────────────────────────────────────────
PLAN_OUT     := $(if $(HAS_ROOT),$(COMPILED_DIR)/$(LESSON)_plan.pdf)
SLIDES_OUT   := $(if $(HAS_SLIDES),$(COMPILED_DIR)/$(LESSON)_slides.pdf)
PPTX_OUT     := $(if $(HAS_SLIDES),$(COMPILED_DIR)/$(LESSON)_slides.pptx)
STUDENT_OUT  := $(COMPILED_DIR)/$(LESSON)_student.pdf
KEY_OUT      := $(COMPILED_DIR)/$(LESSON)_key.pdf

# PDF → PPTX: one full-bleed page image per slide, no external dependencies
# beyond the poppler tools the build already uses. Override PPTX_DPI to trade
# file size against projected sharpness. Fed the RAW deck, not the printed
# handout — a PowerPoint of 3-up handout pages would be useless to project.
PPTX_SCRIPT  := $(PROJECT_ROOT)/shared/pdf2pptx.py
PPTX_DPI     ?= 300

# Deck → printed handout: 3 slides per page, notes column beside each.
HANDOUT_TEX  := $(PROJECT_ROOT)/shared/handout.tex
HANDOUT_DIR  := $(PDF_DIR)/.handout

# Both packets are laid out against each other, so either target needs every
# component of both compiled before it can be paginated.
ALIGN_STAMPS   := $(sort $(STUDENT_STAMPS) $(KEY_STAMPS))

# ── Deck → printed handout ────────────────────────────────────────────────────
# Re-frames the compiled deck as a printable: three slides per letter page in
# the left column, a ruled note area beside each in the right. Only the framing
# is new — every slide is placed with \includegraphics, so TikZ figures and math
# render exactly as they do on the projector.
#
# The page count is passed in because LaTeX cannot count the pages of an
# external PDF; pdfinfo is already a build dependency. See shared/handout.tex.
#   $1 = the deck PDF (absolute path).
#   $2 = the handout PDF to write.
define handout
	@mkdir -p $(HANDOUT_DIR) $(dir $2)
	@set -e; \
	n=$$(pdfinfo "$1" | awk '/^Pages/{print $$2}'); \
	TEXINPUTS="$(TEXINPUTS)" xelatex -interaction=nonstopmode -halt-on-error \
	    -output-directory="$(HANDOUT_DIR)" -jobname=handout \
	    '\def\DeckSource{'"$1"'}\def\DeckPages{'"$$n"'}\input{handout}' \
	    > $(HANDOUT_DIR)/handout.log 2>&1 \
	  && mv $(HANDOUT_DIR)/handout.pdf $2 \
	  || { echo "!  handout pass failed — see $(HANDOUT_DIR)/handout.log"; \
	       grep -E "^(!|l\.)" $(HANDOUT_DIR)/handout.log | head -10; exit 1; }
endef

# ── Packet-wide pagination + recto starts + student/key alignment ─────────────
# Each component is its own document, so each numbers its pages from 1. After
# the merge, this pass rebuilds the packet so page numbers run across the whole
# document AND every component starts on an odd (right-hand) page: blank versos
# are inserted after a component that would otherwise leave the next one on a
# verso, including after the last, so the packet itself is even and one lesson
# never pushes the next one onto a verso. (unit.mk's own unit_cover/sample_test
# are NOT padded, so a unit packet is not recto-correct end to end.)
#
# The student and key packets are also kept page-for-page in step: each
# component occupies the SAME slot size in both — max(blank pages, key pages)
# rounded up to even — so page 7 of the key is page 7 of the student packet.
# The shorter of the two is padded with blank versos to fill its slot. Both
# targets compute the same slot sizes from the same two PDF lists, so they stay
# aligned whether built together or separately. See shared/paginate.tex.
#   $1 = merged PDF, rewritten in place.
#   $2 = the component PDFs that were merged, in the same order.
#   $3 = the counterpart packet's component PDFs, in the same order (1:1 with $2).
#
# One scratch dir per packet: `student` and `key` run concurrently under -j, and
# the pass writes a fixed paginated.pdf into its dir, so a shared one let each
# packet clobber the other's output mid-run.
PAGINATE_DIR := $(PDF_DIR)/.paginate
student: PAGINATE_DIR := $(PDF_DIR)/.paginate-student
key:     PAGINATE_DIR := $(PDF_DIR)/.paginate-key

define paginate
	@mkdir -p $(PAGINATE_DIR)
	@set -e; \
	set -- $3; \
	spec=; first=1; \
	for f in $2; do \
	  n=$$(pdfinfo "$$f" | awk '/^Pages/{print $$2}'); \
	  slot=$$n; \
	  if [ $$# -gt 0 ]; then \
	    m=$$(pdfinfo "$$1" | awk '/^Pages/{print $$2}'); \
	    shift; \
	    if [ $$m -gt $$slot ]; then slot=$$m; fi; \
	  fi; \
	  slot=$$(( (slot + 1) / 2 * 2 )); \
	  last=$$((first + n - 1)); \
	  spec="$$spec,$$first-$$last"; \
	  pad=$$((slot - n)); \
	  while [ $$pad -gt 0 ]; do spec="$$spec,{}"; pad=$$((pad - 1)); done; \
	  first=$$((last + 1)); \
	done; \
	spec=$${spec#,}; \
	TEXINPUTS="$(TEXINPUTS)" xelatex -interaction=nonstopmode -halt-on-error \
	    -output-directory="$(PAGINATE_DIR)" -jobname=paginated \
	    '\def\PacketSource{'"$1"'}\def\PacketPages{'"$$spec"'}\input{paginate}' \
	    > $(PAGINATE_DIR)/paginate.log 2>&1 \
	  && mv $(PAGINATE_DIR)/paginated.pdf $1 \
	  || { echo "!  pagination pass failed — see $(PAGINATE_DIR)/paginate.log"; \
	       grep -E "^(!|l\.)" $(PAGINATE_DIR)/paginate.log | head -10; exit 1; }
endef

# ── Convention gate ───────────────────────────────────────────────────────────
# A LaTeX compile exits 0 on a key that runs a page longer than its blank, on a
# two-page exit ticket, and on \ans buried in math. `check` is what turns those
# into build failures. It depends on ALIGN_STAMPS because the page-parity and
# one-page checks read the compiled per-component PDFs — comparing the merged
# packets would prove nothing, since the pagination pass has already padded them
# to match. See shared/lesson_check.py for the full list of checks.
CHECK_SCRIPT := $(PROJECT_ROOT)/shared/lesson_check.py

# ── Targets ───────────────────────────────────────────────────────────────────
# `slides` and `pptx` are .PHONY, so the slides/ directory never shadows them.
.PHONY: all plan slides pptx student key check clean

all: plan slides pptx student key

check: $(ALIGN_STAMPS)
	@python3 $(CHECK_SCRIPT) --project $(PROJECT_ROOT) $(UNIT)/$(LESSON)

# ── plan / slides / pptx ──────────────────────────────────────────────────────

plan: $(PLAN_OUT)
ifeq ($(strip $(HAS_ROOT)),)
	@echo "  (no lesson plan in $(UNIT)/$(LESSON))"
endif

slides: $(SLIDES_OUT)
ifeq ($(strip $(HAS_SLIDES)),)
	@echo "  (no slides in $(UNIT)/$(LESSON))"
endif

pptx: $(PPTX_OUT)
ifeq ($(strip $(HAS_SLIDES)),)
	@echo "  (no slides in $(UNIT)/$(LESSON) — nothing to convert)"
endif

$(COMPILED_DIR)/$(LESSON)_plan.pdf: $(ROOT_DEP)
	@mkdir -p $(COMPILED_DIR)
	@cp $(ROOT_PDF) $@
	@echo "✓  Lesson plan    → target/compiled/$(UNIT)/$(LESSON)_plan.pdf"

$(COMPILED_DIR)/$(LESSON)_slides.pdf: $(SLIDES_DEP) $(HANDOUT_TEX)
	@mkdir -p $(COMPILED_DIR)
	$(call handout,$(abspath $(SLIDES_PDF)),$@)
	@echo "✓  Slides (PDF)   → target/compiled/$(UNIT)/$(LESSON)_slides.pdf (3 per page, notes column)"

# Built from the raw deck, not from the handout above.
$(COMPILED_DIR)/$(LESSON)_slides.pptx: $(SLIDES_DEP) $(PPTX_SCRIPT)
	@mkdir -p $(COMPILED_DIR)
	@python3 $(PPTX_SCRIPT) $(SLIDES_PDF) $@ --dpi $(PPTX_DPI) --title "$(UNIT) $(LESSON) slides"
	@echo "✓  Slides (PPTX)  → target/compiled/$(UNIT)/$(LESSON)_slides.pptx (full page, projectable)"

# ── student / key packets ─────────────────────────────────────────────────────

student: $(ALIGN_STAMPS)
ifneq ($(strip $(STUDENT_PDFS)),)
	@mkdir -p $(COMPILED_DIR)
	pdfunite $(STUDENT_PDFS) $(COMPILED_DIR)/$(LESSON)_student.pdf
	$(call paginate,$(COMPILED_DIR)/$(LESSON)_student.pdf,$(STUDENT_PDFS),$(KEY_PDFS))
	@echo "✓  Student packet → target/compiled/$(UNIT)/$(LESSON)_student.pdf (paginated $(LESSON)-wide, components start recto)"
else
	@echo "  (no student components in $(UNIT)/$(LESSON))"
endif

key: $(ALIGN_STAMPS)
ifneq ($(strip $(KEY_PDFS)),)
	@mkdir -p $(COMPILED_DIR)
	pdfunite $(KEY_PDFS) $(COMPILED_DIR)/$(LESSON)_key.pdf
	$(call paginate,$(COMPILED_DIR)/$(LESSON)_key.pdf,$(KEY_PDFS),$(STUDENT_PDFS))
	@echo "✓  Key packet     → target/compiled/$(UNIT)/$(LESSON)_key.pdf (page-for-page with the student packet)"
else
	@echo "  (no keyed components in $(UNIT)/$(LESSON))"
endif

# ── Pattern rule: compile a component subdirectory (tex components only) ───────
$(STAMP_DIR)/%/main.stamp: %/main.tex $(SHARED_STYS)
	@mkdir -p $(dir $@) $(PDF_DIR)/$*
	cd $* && TEXINPUTS="$(TEXINPUTS)" $(LATEXMK) $(LATEXFLAGS) \
		-outdir="$(PDF_DIR)/$*" main.tex
	@touch $@

# ── Rule: compile root-level main.tex ────────────────────────────────────────
$(STAMP_DIR)/main.stamp: main.tex $(SHARED_STYS)
	@mkdir -p $(dir $@) $(PDF_DIR)
	TEXINPUTS="$(TEXINPUTS)" $(LATEXMK) $(LATEXFLAGS) \
		-outdir="$(PDF_DIR)" main.tex
	@touch $@

clean:
	rm -rf $(STAMP_DIR) $(PDF_DIR)
	rm -f $(COMPILED_DIR)/$(LESSON)_plan.pdf \
	      $(COMPILED_DIR)/$(LESSON)_slides.pdf $(COMPILED_DIR)/$(LESSON)_slides.pptx \
	      $(COMPILED_DIR)/$(LESSON)_student.pdf $(COMPILED_DIR)/$(LESSON)_key.pdf \
	      $(COMPILED_DIR)/$(LESSON)_full.pdf

# ── Grading (math-shared, the submodule at the project root) ──────────────────
# A component is graded when its main.tex loads grading.sty (\gradedblank items).
# In a lesson packet that is ap_practice and homework; PACKET_GRADED finds them
# by grepping each packet component's main.tex, so nothing here names them.
#
#   make manifest COMP=homework
#       blank + key builds, target/<unit>/<lesson>/grading/<COMP>/manifest.json,
#       and the check that the blank and key agree on every graded item.
#   make roster-packets ROSTER=~/Mathematics/rosters/roster-map.csv [SECTION=…]
#       per student, in roster order: one copy of the lesson's student packet
#       with her name printed on the lesson cover and EVERY graded component
#       replaced by her personalized copy (QR codes and the id strip carry only
#       her tracking id). Paginated exactly like `make student`, so each
#       component starts on a recto and fills whole sheets: she tears the graded
#       sheets out and turns them in, and the cover with her name stays in the
#       packet. Joined into target/compiled/<unit>/lessonYY_roster.pdf to print
#       duplex as one collated job. Every packet has an even page count, so each
#       student's cover starts on an odd page. It first builds each graded
#       component's manifest.json (as `make manifest` does), which
#       `grading ingest` reads, so the packets and the answer keys the grader
#       uses come from one build.
#   make roster-packets COMP=<dir> ROSTER=…
#       a graded component NOT in the packet gets math-shared's own run per
#       student (name sheet, blank back, the component padded to even) →
#       lessonYY_<COMP>_roster.pdf, after its manifest. A COMP that IS in the
#       packet is ignored: the packet build personalizes every graded component.
#
# A lesson packet has NO separate name sheet: the lesson cover carries the name
# (2026-10-28). Only tests get math-shared's tear-off name sheet (shared/tests.mk).
# A lesson with graded components and no cover/main.tex is an error. The roster
# PDFs carry names, so they stay under target/, which is never committed;
# math-shared's check_names.py fails the build if a roster name reaches a graded
# copy.
GRADING_MK  := $(PROJECT_ROOT)/math-shared/grading.mk
COMP        ?=
COMPONENT   := $(COMP)
GRADING_OUT := $(PDF_DIR)/grading/$(COMP)

.PHONY: manifest roster-packets roster-copies roster-force roster-need-ids grading-need-comp

ifneq ($(wildcard $(GRADING_MK)),)
include $(GRADING_MK)

grading-need-comp:
	@test -n "$(COMP)" || { echo "!  set COMP=<component directory>, e.g. COMP=homework"; exit 1; }

manifest: grading-need-comp
	@$(MAKE) --no-print-directory grading-manifest
	@echo "✓  Manifest       → target/$(UNIT)/$(LESSON)/grading/$(COMP)/manifest.json"

# ROSTER may start with ~/ (make does not expand it) and may be relative.
ifneq ($(ROSTER),)
override ROSTER := $(abspath $(patsubst ~/%,$(HOME)/%,$(ROSTER)))
endif

# Roster order and tracking ids, read only when ROSTER is given.
ROSTER_IDS := $(if $(ROSTER),$(shell $(GRADING_PYTHON) $(GRADING_SCRIPTS)/roster_tex.py \
                "$(ROSTER)" --ids-only $(GR_SELECT)))

roster-need-ids: grading-need-roster
	@test -n "$(strip $(ROSTER_IDS))" || { echo "!  no students in $(ROSTER)$(if $(SECTION), for section $(SECTION))"; exit 1; }

# The graded components of the student packet, in packet order: those whose
# main.tex loads grading outside a comment (a prefab main.pdf never does).
PACKET_GRADED := $(strip $(foreach c,$(STUDENT_COMPS),$(if $(shell grep -lE \
                   '^[^%]*\\usepackage(\[[^]]*\])?\{grading\}' $c/main.tex 2>/dev/null),$c)))

# A COMP outside the packet takes math-shared's run; anything else, the packet.
COMP_OUTSIDE := $(if $(COMP),$(if $(filter $(COMP),$(STUDENT_COMPS)),,$(COMP)))

ifneq ($(COMP_OUTSIDE),)
roster-packets: roster-need-ids manifest grading-personalized
	@mkdir -p $(COMPILED_DIR)
	@cp "$(GR_OUT)/personalized.pdf" $(COMPILED_DIR)/$(LESSON)_$(COMP)_roster.pdf
	@echo "✓  Roster runs    → target/compiled/$(UNIT)/$(LESSON)_$(COMP)_roster.pdf ($(words $(ROSTER_IDS)) students, roster order)"
else
ROSTER_PKT_DIR  := $(PDF_DIR)/grading/roster
ROSTER_NAME_DIR := $(ROSTER_PKT_DIR)/covers
ROSTER_PACKETS  := $(foreach id,$(ROSTER_IDS),$(ROSTER_PKT_DIR)/$(id).pdf)
ROSTER_OUT      := $(COMPILED_DIR)/$(LESSON)_roster.pdf

roster-packets: roster-need-ids
	@test -f cover/main.tex || { echo "!  $(UNIT)/$(LESSON) has no cover/main.tex: a lesson packet prints the name on its cover"; exit 1; }
	@test -n "$(PACKET_GRADED)" || { echo "!  $(UNIT)/$(LESSON) has no graded component in its packet"; exit 1; }
	$(if $(COMP),@echo "   COMP=$(COMP) ignored: the packet personalizes every graded component")
	@for c in $(PACKET_GRADED); do \
	  echo "   graded component: $$c"; \
	  $(MAKE) --no-print-directory manifest COMP=$$c || exit 1; \
	  $(MAKE) --no-print-directory roster-copies COMP=$$c || exit 1; \
	done
	@$(MAKE) --no-print-directory $(ROSTER_PACKETS)
	@mkdir -p $(COMPILED_DIR)
	@if [ $(words $(ROSTER_PACKETS)) -eq 1 ]; then cp $(ROSTER_PACKETS) $(ROSTER_OUT); \
	 else pdfunite $(ROSTER_PACKETS) $(ROSTER_OUT); fi
	@echo "✓  Roster packets → target/compiled/$(UNIT)/$(LESSON)_roster.pdf ($(words $(ROSTER_IDS)) students, roster order; graded: $(PACKET_GRADED))"

# Every student's copy of ONE graded component (COMP), from her tracking id
# alone, into $(GR_STUDENTS)/<id>.pdf; then math-shared's check that no roster
# name reached a graded build.
roster-copies: grading-need-component grading-need-roster
	@mkdir -p "$(GR_STUDENTS)"
	@set -e; for id in $(ROSTER_IDS); do \
	  echo "   $(COMP) $$id"; \
	  $(grading-one-student); \
	done
	@$(GRADING_PYTHON) "$(GRADING_SCRIPTS)/check_names.py" "$(GR_OUT)" "$(ROSTER)"

# One student's packet: the student packet's PDF list with the master cover
# replaced by her named cover and each graded master by her copy, paginated
# against the same key-packet list `make student` uses, so its page boundaries
# are identical to the printed key's.
#
# The cover is compiled with
#   \def\StudentName{Preferred Last}
# ahead of it (roster_tex.py's TeX-safe names, as on math-shared's name sheet),
# so \namedateperiod prints her name on the Name line. Only cover/ is compiled
# with a name; every graded component is built from ids alone. roster-force runs
# this rule on every build and -g makes latexmk recompile: latexmk does not track
# -usepretex, so without it a changed name would leave the old cover in place.
roster-pdf = $(if $(filter $(PDF_DIR)/cover/main.pdf,$1),$(ROSTER_NAME_DIR)/$2.pdf,$(or $(strip \
               $(foreach c,$(PACKET_GRADED),$(if $(filter $(PDF_DIR)/$c/main.pdf,$1),$(PDF_DIR)/grading/$c/students/$2.pdf))),$1))
ROSTER_PKT_PDFS = $(foreach f,$(STUDENT_PDFS),$(call roster-pdf,$f,$*))

$(ROSTER_PKT_DIR)/%.pdf: PAGINATE_DIR = $(ROSTER_PKT_DIR)/.paginate-$*
$(ROSTER_PKT_DIR)/%.pdf: roster-force $(ALIGN_STAMPS)
	@mkdir -p $(ROSTER_NAME_DIR)
	@set -e; \
	row=$$($(GRADING_PYTHON) $(GRADING_SCRIPTS)/roster_tex.py "$(ROSTER)" --id $*); \
	pref=$$(printf '%s\n' "$$row" | cut -f2); last=$$(printf '%s\n' "$$row" | cut -f3); \
	( cd cover && TEXINPUTS="$(TEXINPUTS)" $(LATEXMK) $(LATEXFLAGS) -g -jobname=$* \
	    -usepretex="\def\StudentName{$$pref $$last}" \
	    -outdir="$(ROSTER_NAME_DIR)" main.tex > "$(ROSTER_NAME_DIR)/$*.out" 2>&1 ) \
	  || { echo "!  LaTeX failed for the named cover of $* — see $(ROSTER_NAME_DIR)/$*.log"; \
	       grep -E "^(!|l\.|.*:[0-9]+: )" "$(ROSTER_NAME_DIR)/$*.log" | head -10; exit 1; }
	@for f in $(ROSTER_PKT_PDFS); do test -f "$$f" || { echo "!  missing $$f"; exit 1; }; done
	@pdfunite $(ROSTER_PKT_PDFS) $@
	$(call paginate,$@,$(ROSTER_PKT_PDFS),$(KEY_PDFS))
endif

roster-force:
else
manifest roster-packets roster-copies roster-need-ids grading-need-comp:
	@echo "!  math-shared is empty — run: git submodule update --init"; exit 1
endif
