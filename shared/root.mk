# shared/root.mk — included by the project-root Makefile (just `include shared/root.mk`).
# Delegates to the unit sub-makes and stitches the whole-curriculum packets.
#
# Only the student and key packets aggregate to this level. Each lesson's other
# three products (plan, the 3-up slides PDF, the full-page slides PPTX) stay in
# target/compiled/unitXX/ — they are per-lesson teacher artifacts.

PROJECT_ROOT := $(CURDIR)
COMPILED_DIR := $(PROJECT_ROOT)/target/compiled

# Auto-discover units that have a Makefile, in sorted order.
UNITS := $(patsubst %/Makefile,%,$(sort $(wildcard unit*/Makefile)))

.PHONY: all student key check clean distclean $(UNITS)

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

clean:
	@for u in $(UNITS); do $(MAKE) -C $$u clean; done
	rm -f $(COMPILED_DIR)/curriculum_student.pdf $(COMPILED_DIR)/curriculum_key.pdf \
	      $(COMPILED_DIR)/curriculum_full.pdf

distclean: clean
	rm -rf $(PROJECT_ROOT)/target $(PROJECT_ROOT)/.stamps
