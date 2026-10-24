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

.PHONY: all clean drop manifest roster-packets grading-need-comp roster-need-ids $(TESTS)

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
#       math-shared's grading-personalized: per student, in roster order, the
#       name cover sheet, its blank back, then the personalized test (QR codes
#       and the id strip carry only the tracking id) padded to an even page
#       count, copied to target/compiled/<unit>/<COMP>_roster.pdf to print as
#       one job.
#
# Graded pages carry no names; only the cover sheets do, and grading-personalized
# ends with math-shared's name check on the graded builds. Everything stays
# under target/.
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
                    "$(ROSTER)" --ids-only $(GR_SELECT)))
ROSTER_OUT     := $(PROJECT_ROOT)/target/compiled/$(UNIT)/$(COMP)_roster.pdf

roster-need-ids: grading-need-roster
	@test -n "$(strip $(ROSTER_IDS))" || { echo "!  no students in $(ROSTER)$(if $(SECTION), for section $(SECTION))"; exit 1; }

roster-packets: grading-need-comp roster-need-ids grading-personalized
	@mkdir -p "$(dir $(ROSTER_OUT))"
	@cp "$(GR_OUT)/personalized.pdf" "$(ROSTER_OUT)"
	@echo "OK  Roster copies -> target/compiled/$(UNIT)/$(COMP)_roster.pdf ($(words $(ROSTER_IDS)) students, roster order)"
else
manifest roster-packets grading-need-comp roster-need-ids:
	@echo "!  math-shared is empty — run: git submodule update --init"; exit 1
endif
