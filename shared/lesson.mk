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
UNIT         := $(notdir $(abspath ..))
LESSON       := $(notdir $(CURDIR))

SHARED_STYS  := $(wildcard $(PROJECT_ROOT)/shared/*.sty)
TEXINPUTS    := $(PROJECT_ROOT)/shared//:
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
STUDENT_ORDER := cover warmup notes activity exit_ticket homework
KEYED_PAIRS   := warmup notes activity exit_ticket homework

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
PAGINATE_DIR := $(PDF_DIR)/.paginate

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

# ── Targets ───────────────────────────────────────────────────────────────────
# `slides` and `pptx` are .PHONY, so the slides/ directory never shadows them.
.PHONY: all plan slides pptx student key clean

all: plan slides pptx student key

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