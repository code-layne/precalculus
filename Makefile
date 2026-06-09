# Root Makefile — delegates to unit sub-makes and stitches the full curriculum.

COMPILED_DIR := target/compiled
UNITS := $(patsubst %/Makefile,%,$(sort $(wildcard unit*/Makefile)))

.PHONY: all student full clean distclean $(UNITS)

all: $(UNITS)

$(UNITS):
	$(MAKE) -C $@

student:
	@for u in $(UNITS); do $(MAKE) -C $$u student || exit 1; done
	@mkdir -p $(COMPILED_DIR)
	@pdfs=$$(ls $(COMPILED_DIR)/unit*_student.pdf 2>/dev/null | sort); \
	if [ -n "$$pdfs" ]; then \
	  pdfunite $$pdfs $(COMPILED_DIR)/curriculum_student.pdf; \
	  echo "✓  Curriculum student → target/compiled/curriculum_student.pdf"; \
	fi

full:
	@for u in $(UNITS); do $(MAKE) -C $$u full || exit 1; done
	@mkdir -p $(COMPILED_DIR)
	@pdfs=$$(ls $(COMPILED_DIR)/unit*_full.pdf 2>/dev/null | sort); \
	if [ -n "$$pdfs" ]; then \
	  pdfunite $$pdfs $(COMPILED_DIR)/curriculum_full.pdf; \
	  echo "✓  Curriculum full    → target/compiled/curriculum_full.pdf"; \
	fi

clean:
	@for u in $(UNITS); do $(MAKE) -C $$u clean; done
	rm -f $(COMPILED_DIR)/curriculum_student.pdf $(COMPILED_DIR)/curriculum_full.pdf

distclean: clean
	rm -rf target .stamps
