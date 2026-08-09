# shared/unit.mk — included by every unit-level Makefile.
# Auto-detects PROJECT_ROOT and UNIT from CURDIR.
#
# A unit aggregates only the two packets that concatenate meaningfully: the
# student packet and the key packet. The other three lesson products (plan,
# 3-up slides PDF, slides PPTX) stay per-lesson in target/compiled/$(UNIT)/ —
# they are teacher artifacts, not something to hand out as one bound document.

PROJECT_ROOT := $(abspath ..)
UNIT         := $(notdir $(CURDIR))
COMPILED_DIR := $(PROJECT_ROOT)/target/compiled

# Auto-discover lessons that have a Makefile, in sorted order.
LESSONS := $(patsubst %/Makefile,%,$(sort $(wildcard lesson*/Makefile)))

# Optional unit-level bookend components.
#
# unit_cover_key is the teacher's form of the cover: the same page 1 (both
# wrappers \input unit_cover/body.tex, so they cannot drift) plus a page 2 of
# exam scoring notes lifted out of the test keys. It goes into the KEY packet
# only — the practice test is bound into the student packet, so its rationale
# and scoring must never ride along there. A unit with no unit_cover_key falls
# back to the plain cover in both packets, exactly as before.
HAS_UNIT_COVER      := $(wildcard unit_cover/main.tex)
HAS_UNIT_COVER_KEY  := $(wildcard unit_cover_key/main.tex)
HAS_SAMPLE_TEST     := $(wildcard sample_test/main.pdf)
HAS_SAMPLE_TEST_KEY := $(wildcard sample_test_key/main.pdf)

UNIT_COVER_PDF      := $(if $(HAS_UNIT_COVER),$(COMPILED_DIR)/$(UNIT)/unit_cover.pdf)
UNIT_COVER_KEY_PDF  := $(if $(HAS_UNIT_COVER_KEY),$(COMPILED_DIR)/$(UNIT)/unit_cover_key.pdf)
SAMPLE_TEST_PDF     := $(if $(HAS_SAMPLE_TEST),$(COMPILED_DIR)/$(UNIT)/sample_test.pdf)
SAMPLE_TEST_KEY_PDF := $(if $(HAS_SAMPLE_TEST_KEY),$(COMPILED_DIR)/$(UNIT)/sample_test_key.pdf)

.PHONY: all student key check clean $(LESSONS) _unit_cover _unit_cover_key _sample_test _sample_test_key

all: $(LESSONS)

$(LESSONS):
	$(MAKE) -C $@

# Build every lesson first (the page checks read compiled per-component PDFs),
# then gate the whole unit in one pass so a single run reports every violation
# rather than stopping at the first lesson that fails.
check: $(LESSONS)
	@python3 $(PROJECT_ROOT)/shared/lesson_check.py --project $(PROJECT_ROOT) $(UNIT)

# ── Optional bookend rules ────────────────────────────────────────────────────

_unit_cover:
ifdef HAS_UNIT_COVER
	@mkdir -p $(COMPILED_DIR)/$(UNIT)
	cd unit_cover && TEXINPUTS="$(PROJECT_ROOT)/shared//:" \
	    latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error \
	    -outdir="$(PROJECT_ROOT)/target/$(UNIT)/unit_cover" main.tex
	cp $(PROJECT_ROOT)/target/$(UNIT)/unit_cover/main.pdf $(UNIT_COVER_PDF)
	@echo "✓  Unit cover        → target/compiled/$(UNIT)/unit_cover.pdf"
endif

_unit_cover_key:
ifdef HAS_UNIT_COVER_KEY
	@mkdir -p $(COMPILED_DIR)/$(UNIT)
	cd unit_cover_key && TEXINPUTS="$(PROJECT_ROOT)/shared//:" \
	    latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error \
	    -outdir="$(PROJECT_ROOT)/target/$(UNIT)/unit_cover_key" main.tex
	cp $(PROJECT_ROOT)/target/$(UNIT)/unit_cover_key/main.pdf $(UNIT_COVER_KEY_PDF)
	@echo "✓  Unit cover (key)  → target/compiled/$(UNIT)/unit_cover_key.pdf"
endif

_sample_test:
ifdef HAS_SAMPLE_TEST
	@mkdir -p $(COMPILED_DIR)/$(UNIT)
	cp sample_test/main.pdf $(SAMPLE_TEST_PDF)
	@echo "✓  Sample test       → target/compiled/$(UNIT)/sample_test.pdf"
endif

_sample_test_key:
ifdef HAS_SAMPLE_TEST_KEY
	@mkdir -p $(COMPILED_DIR)/$(UNIT)
	cp sample_test_key/main.pdf $(SAMPLE_TEST_KEY_PDF)
	@echo "✓  Sample test key   → target/compiled/$(UNIT)/sample_test_key.pdf"
endif

# ── student / key targets ─────────────────────────────────────────────────────
#
# The unit key packet mirrors the unit student packet piece for piece: the unit
# cover (in its key form, if the unit has one — same page 1, plus a page of exam
# scoring notes), each lesson's key packet in place of its student packet (those
# are equal-length and equal-paginated by lesson.mk), and the sample test key in
# place of the sample test. Only the cover and that last pair can differ in
# length; both sit at an end, so the lesson packets in between still line up.

student: _unit_cover $(LESSONS) _sample_test
	@for l in $(LESSONS); do $(MAKE) -C $$l student || exit 1; done
	@mkdir -p $(COMPILED_DIR)/$(UNIT) $(COMPILED_DIR)
	@lesson_pdfs=$$(ls $(COMPILED_DIR)/$(UNIT)/lesson*_student.pdf 2>/dev/null | sort); \
	all_pdfs="$(UNIT_COVER_PDF) $$lesson_pdfs $(SAMPLE_TEST_PDF)"; \
	all_pdfs=$$(echo $$all_pdfs | tr ' ' '\n' | grep -v '^$$'); \
	if [ -n "$$all_pdfs" ]; then \
	  pdfunite $$all_pdfs $(COMPILED_DIR)/$(UNIT)_student.pdf; \
	  echo "✓  Unit student packet → target/compiled/$(UNIT)_student.pdf"; \
	else \
	  echo "  (no student PDFs found for $(UNIT))"; \
	fi

key: _unit_cover _unit_cover_key $(LESSONS) _sample_test _sample_test_key
	@for l in $(LESSONS); do $(MAKE) -C $$l key || exit 1; done
	@mkdir -p $(COMPILED_DIR)/$(UNIT) $(COMPILED_DIR)
	@lesson_pdfs=$$(ls $(COMPILED_DIR)/$(UNIT)/lesson*_key.pdf 2>/dev/null | sort); \
	all_pdfs="$(or $(UNIT_COVER_KEY_PDF),$(UNIT_COVER_PDF)) $$lesson_pdfs $(or $(SAMPLE_TEST_KEY_PDF),$(SAMPLE_TEST_PDF))"; \
	all_pdfs=$$(echo $$all_pdfs | tr ' ' '\n' | grep -v '^$$'); \
	if [ -n "$$all_pdfs" ]; then \
	  pdfunite $$all_pdfs $(COMPILED_DIR)/$(UNIT)_key.pdf; \
	  echo "✓  Unit key packet     → target/compiled/$(UNIT)_key.pdf"; \
	else \
	  echo "  (no key PDFs found for $(UNIT))"; \
	fi

clean:
	@for l in $(LESSONS); do $(MAKE) -C $$l clean; done
	rm -rf $(PROJECT_ROOT)/target/$(UNIT)/unit_cover $(PROJECT_ROOT)/target/$(UNIT)/unit_cover_key
	rm -f $(UNIT_COVER_PDF) $(UNIT_COVER_KEY_PDF) $(SAMPLE_TEST_PDF) $(SAMPLE_TEST_KEY_PDF)
	rm -f $(COMPILED_DIR)/$(UNIT)_student.pdf $(COMPILED_DIR)/$(UNIT)_key.pdf \
	      $(COMPILED_DIR)/$(UNIT)_full.pdf
