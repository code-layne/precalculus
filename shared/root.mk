# shared/root.mk — included by the project-root Makefile (just `include shared/root.mk`).
# Delegates to the unit sub-makes and stitches the whole-curriculum packets.
#
# Only the student and key packets aggregate to this level. Each lesson's other
# three products (plan, the 3-up slides PDF, the full-page slides PPTX) stay in
# target/compiled/unitXX/ — they are per-lesson teacher artifacts.
#
# Grading, from the root:
#   make roster-packets LESSON=unit03/lesson01 ROSTER=~/Mathematics/rosters/roster-map.csv [SECTION=…]
#   make roster-packets COMP=unit01/tests/actual_test ROSTER=… [SECTION=…]   (a test)
#   make manifest COMP=unit03/lesson01/homework   (or COMP=unit01/tests/actual_test)

PROJECT_ROOT := $(CURDIR)
COMPILED_DIR := $(PROJECT_ROOT)/target/compiled

# Auto-discover units that have a Makefile, in sorted order.
UNITS := $(patsubst %/Makefile,%,$(sort $(wildcard unit*/Makefile)))

.PHONY: all student key check clean distclean manifest roster-packets $(UNITS)

all: $(UNITS)

$(UNITS):
	$(MAKE) -C $@

# Whole-curriculum convention gate. Builds every unit first, then checks every
# lesson in one pass so the report covers the project rather than stopping at the
# first violation. See shared/lesson_check.py.
check: $(UNITS)
	@python3 $(PROJECT_ROOT)/shared/lesson_check.py --project $(PROJECT_ROOT) --all

student:
	@for u in $(UNITS); do $(MAKE) -C $$u student || exit 1; done
	@mkdir -p $(COMPILED_DIR)
	@unit_pdfs=$$(ls $(COMPILED_DIR)/unit*_student.pdf 2>/dev/null | sort); \
	if [ -n "$$unit_pdfs" ]; then \
	  pdfunite $$unit_pdfs $(COMPILED_DIR)/curriculum_student.pdf; \
	  echo "✓  Curriculum student packet → target/compiled/curriculum_student.pdf"; \
	else \
	  echo "  (no unit student PDFs found)"; \
	fi

key:
	@for u in $(UNITS); do $(MAKE) -C $$u key || exit 1; done
	@mkdir -p $(COMPILED_DIR)
	@unit_pdfs=$$(ls $(COMPILED_DIR)/unit*_key.pdf 2>/dev/null | sort); \
	if [ -n "$$unit_pdfs" ]; then \
	  pdfunite $$unit_pdfs $(COMPILED_DIR)/curriculum_key.pdf; \
	  echo "✓  Curriculum key packet     → target/compiled/curriculum_key.pdf"; \
	else \
	  echo "  (no unit key PDFs found)"; \
	fi

# LESSON (unitXX/lessonYY) or COMP (unitXX/<path below the unit>) names what to
# build; the call goes to that unit's Makefile, which hands it on. ROSTER may
# start with ~/ and may be relative to this directory.
ROSTER_ABS = $(abspath $(patsubst ~/%,$(HOME)/%,$(ROSTER)))
GRADING_TARGET_PATH = $(patsubst %/,%,$(or $(LESSON),$(COMP)))
GRADING_UNIT = $(firstword $(subst /, ,$(GRADING_TARGET_PATH)))
GRADING_REST = $(patsubst $(GRADING_UNIT)/%,%,$(GRADING_TARGET_PATH))

manifest roster-packets:
	@test -n "$(GRADING_TARGET_PATH)" || { echo "!  set LESSON=unitXX/lessonYY (roster-packets) or COMP=unitXX/<component>, e.g."; \
	  echo "     make roster-packets LESSON=unit03/lesson01 ROSTER=~/Mathematics/rosters/roster-map.csv"; \
	  echo "     make manifest COMP=unit03/lesson01/homework"; exit 1; }
	@test "$(GRADING_REST)" != "$(GRADING_TARGET_PATH)" -a -f "$(GRADING_UNIT)/Makefile" \
	  || { echo "!  $(GRADING_TARGET_PATH) is not unitXX/<something> with a unit Makefile"; exit 1; }
	@$(MAKE) --no-print-directory -C $(GRADING_UNIT) $@ $(if $(LESSON),LESSON=$(GRADING_REST) COMP=,COMP=$(GRADING_REST)) \
	    $(if $(ROSTER),ROSTER="$(ROSTER_ABS)") $(if $(SECTION),SECTION="$(SECTION)")

clean:
	@for u in $(UNITS); do $(MAKE) -C $$u clean; done
	rm -f $(COMPILED_DIR)/curriculum_student.pdf $(COMPILED_DIR)/curriculum_key.pdf \
	      $(COMPILED_DIR)/curriculum_full.pdf

distclean: clean
	rm -rf $(PROJECT_ROOT)/target $(PROJECT_ROOT)/.stamps
