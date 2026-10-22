# shared/tests.mk — build a unit's summative assessments (blank student copies).
# Included by each unitNN/tests/Makefile (`include ../../shared/tests.mk`).
# Every subdirectory holding a main.tex compiles to target/<unit>/tests/<name>/main.pdf.

PROJECT_ROOT := $(abspath ../..)
UNIT         := $(notdir $(abspath ..))
# The course packages (recursive), then the math-shared submodule for grading.sty
# (NON-recursive: math-shared/examples holds main.tex files; see shared/lesson.mk).
TEXINPUTS    := $(PROJECT_ROOT)/shared//:$(PROJECT_ROOT)/math-shared:
PDF_DIR      := $(PROJECT_ROOT)/target/$(UNIT)/tests
LATEXFLAGS   := -xelatex -interaction=nonstopmode -halt-on-error -file-line-error

TESTS := $(patsubst %/main.tex,%,$(wildcard */main.tex))

# The practice test doubles as the unit "sample test" drop-in: its compiled PDF is
# published to ../sample_test/main.pdf, which shared/unit.mk merges into BOTH the
# student and key packets. The actual test is never published into a packet.
DROP_SRC := practice_test
DROP_DST := ../sample_test/main.pdf

.PHONY: all clean drop manifest roster-packets grading-need-comp $(TESTS)

all: $(TESTS) drop

$(TESTS):
	@mkdir -p $(PDF_DIR)/$@
	cd $@ && TEXINPUTS="$(TEXINPUTS)" latexmk $(LATEXFLAGS) \
	    -outdir="$(PDF_DIR)/$@" main.tex
	@echo "OK  $(UNIT) test -> target/$(UNIT)/tests/$@/main.pdf"

drop: $(DROP_SRC)
	@mkdir -p $(dir $(DROP_DST))
	cp $(PDF_DIR)/$(DROP_SRC)/main.pdf $(DROP_DST)
	@echo "OK  Published practice test -> $(UNIT)/sample_test/main.pdf (student packet)"

clean:
	rm -rf $(PDF_DIR)

# ── Grading (math-shared, the submodule at the project root) ──────────────────
# Entry points to math-shared's grading.mk for ONE test, COMP (a directory here);
# its key is ../test_keys/<COMP>_key:
#
#   make manifest COMP=practice_test
#       blank + key builds, target/<unit>/tests/grading/<COMP>/manifest.json,
#       and the check that the blank and key agree on every graded item.
#   make roster-packets COMP=actual_test ROSTER=~/Rosters/precalculus/roster-map.csv [SECTION=…]
#       one personalized copy of the test per student (QR codes carry the
#       tracking id, the name strip the student's name), each padded to an even
#       page count so every copy starts on a fresh sheet, joined in roster order
#       into target/compiled/<unit>/<COMP>_roster.pdf to print as one job.
#
# The personalized builds carry student names: they stay under target/.
GRADING_MK    := $(PROJECT_ROOT)/math-shared/grading.mk
COMP          ?=
COMPONENT     := $(COMP)
KEY_COMPONENT := ../test_keys/$(COMP)_key
GRADING_OUT   := $(PDF_DIR)/grading/$(COMP)

ifneq ($(wildcard $(GRADING_MK)),)
include $(GRADING_MK)

grading-need-comp:
	@test -n "$(COMP)" || { echo "!  set COMP=<test directory>, e.g. COMP=practice_test"; exit 1; }

manifest: grading-need-comp
	@$(MAKE) --no-print-directory grading-manifest
	@echo "OK  Manifest -> target/$(UNIT)/tests/grading/$(COMP)/manifest.json"

ROSTER_IDS     := $(if $(ROSTER),$(shell $(GRADING_PYTHON) $(GRADING_SCRIPTS)/roster_tex.py \
                    "$(ROSTER)" --ids-only $(if $(SECTION),--section "$(SECTION)")))
ROSTER_PKT_DIR := $(GR_OUT)/packets
ROSTER_OUT     := $(PROJECT_ROOT)/target/compiled/$(UNIT)/$(COMP)_roster.pdf

# An odd-length copy gets one blank verso through shared/paginate.tex, the same
# pass lesson.mk uses, which reprints each page number in its own place.
roster-packets: grading-need-comp grading-need-roster grading-personalized
	@test -n "$(strip $(ROSTER_IDS))" || { echo "!  no students in $(ROSTER)"; exit 1; }
	@mkdir -p "$(ROSTER_PKT_DIR)/.paginate" "$(dir $(ROSTER_OUT))"
	@set -e; pdfs=; \
	for id in $(ROSTER_IDS); do \
	  src="$(GR_STUDENTS)/$$id.pdf"; dst="$(ROSTER_PKT_DIR)/$$id.pdf"; \
	  n=$$(pdfinfo "$$src" | awk '/^Pages/{print $$2}'); \
	  if [ $$((n % 2)) -eq 0 ]; then cp "$$src" "$$dst"; else \
	    TEXINPUTS="$(TEXINPUTS)" xelatex -interaction=nonstopmode -halt-on-error \
	        -output-directory="$(ROSTER_PKT_DIR)/.paginate" -jobname=paginated \
	        '\def\PacketSource{'"$$src"'}\def\PacketPages{1-'"$$n"',{}}\input{paginate}' \
	        > "$(ROSTER_PKT_DIR)/.paginate/paginate.log" 2>&1 \
	      || { echo "!  pagination pass failed — see $(ROSTER_PKT_DIR)/.paginate/paginate.log"; exit 1; }; \
	    mv "$(ROSTER_PKT_DIR)/.paginate/paginated.pdf" "$$dst"; \
	  fi; \
	  pdfs="$$pdfs $$dst"; \
	done; \
	set -- $$pdfs; \
	if [ $$# -eq 1 ]; then cp "$$1" "$(ROSTER_OUT)"; else pdfunite "$$@" "$(ROSTER_OUT)"; fi
	@echo "OK  Roster copies -> target/compiled/$(UNIT)/$(COMP)_roster.pdf ($(words $(ROSTER_IDS)) students, roster order)"
else
manifest roster-packets grading-need-comp:
	@echo "!  math-shared is empty — run: git submodule update --init"; exit 1
endif
