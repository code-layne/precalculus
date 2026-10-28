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
# The course packages (recursive), then the math-shared submodule for grading.sty
# (NON-recursive: math-shared/examples holds main.tex files; see shared/lesson.mk).
TEXINPUTS    := $(PROJECT_ROOT)/shared//:$(PROJECT_ROOT)/math-shared:

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

.PHONY: all student key check clean manifest roster-packets $(LESSONS) _unit_cover _unit_cover_key _sample_test _sample_test_key

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
	cd unit_cover && TEXINPUTS="$(TEXINPUTS)" \
	    latexmk -xelatex -interaction=nonstopmode -halt-on-error -file-line-error \
	    -outdir="$(PROJECT_ROOT)/target/$(UNIT)/unit_cover" main.tex
	cp $(PROJECT_ROOT)/target/$(UNIT)/unit_cover/main.pdf $(UNIT_COVER_PDF)
	@echo "✓  Unit cover        → target/compiled/$(UNIT)/unit_cover.pdf"
endif

_unit_cover_key:
ifdef HAS_UNIT_COVER_KEY
	@mkdir -p $(COMPILED_DIR)/$(UNIT)
	cd unit_cover_key && TEXINPUTS="$(TEXINPUTS)" \
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

# ── Grading (math-shared) ─────────────────────────────────────────────────────
# Unit-level entry points, given relative to the unit directory. Each hands the
# call to the Makefile that builds it — shared/lesson.mk for a lesson,
# shared/tests.mk for a test — so the outputs land where that directory's own
# `make manifest` / `make roster-packets` puts them:
#
#   make roster-packets LESSON=lesson03 ROSTER=~/Mathematics/rosters/roster-map.csv [SECTION=…]
#       (COMP=lesson03 works the same) the lesson packet with each student's
#       name on the lesson cover and her copy of every graded component.
#   make manifest COMP=lesson03/homework
#   make manifest COMP=tests/practice_test      (or the bare name, COMP=practice_test)
#   make roster-packets COMP=tests/actual_test ROSTER=… [SECTION=…]   (or COMP=actual_test)
#       math-shared's tear-off name sheet in front of each student's copy.
# ROSTER may start with ~/ and may be relative to this directory.
UNIT_GR_PATH   = $(patsubst %/,%,$(or $(LESSON),$(COMP)))
# The lesson named: LESSON=lessonYY, COMP=lessonYY, or COMP=lessonYY/<component>.
UNIT_GR_LESSON = $(filter $(firstword $(subst /, ,$(UNIT_GR_PATH))),$(LESSONS))
UNIT_GR_COMP   = $(patsubst $(UNIT_GR_LESSON)/%,%,$(filter $(UNIT_GR_LESSON)/%,$(UNIT_GR_PATH)))
# Anything else: a bare name is a unit test (tests/<COMP>).
UNIT_GR_OTHER  = $(if $(findstring /,$(UNIT_GR_PATH)),$(UNIT_GR_PATH),tests/$(UNIT_GR_PATH))
UNIT_GR_ROSTER = $(abspath $(patsubst ~/%,$(HOME)/%,$(ROSTER)))

manifest roster-packets:
	@test -n "$(UNIT_GR_PATH)" || { echo "!  set LESSON=lessonYY (roster-packets) or COMP=<dir>/<component>, e.g. COMP=lesson03/homework or COMP=tests/actual_test"; exit 1; }
ifneq ($(UNIT_GR_LESSON),)
	@test "$@" = roster-packets -o -n "$(UNIT_GR_COMP)" || { echo "!  manifest works on one component: COMP=$(UNIT_GR_LESSON)/homework"; exit 1; }
	@$(MAKE) --no-print-directory -C $(UNIT_GR_LESSON) $@ LESSON= COMP=$(UNIT_GR_COMP) \
	    $(if $(ROSTER),ROSTER="$(UNIT_GR_ROSTER)") $(if $(SECTION),SECTION="$(SECTION)")
else ifneq ($(LESSON),)
	@echo "!  $(UNIT)/$(LESSON) is not a lesson with a Makefile"; exit 1
else
	@test -f "$(dir $(UNIT_GR_OTHER))Makefile" || { echo "!  no Makefile in $(UNIT)/$(dir $(UNIT_GR_OTHER))"; exit 1; }
	@$(MAKE) --no-print-directory -C $(dir $(UNIT_GR_OTHER)) $@ COMP=$(notdir $(UNIT_GR_OTHER)) \
	    $(if $(ROSTER),ROSTER="$(UNIT_GR_ROSTER)") $(if $(SECTION),SECTION="$(SECTION)")
endif
