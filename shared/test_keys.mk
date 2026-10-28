# shared/test_keys.mk — build a unit's summative assessment answer keys.
# Included by each unitNN/test_keys/Makefile (`include ../../shared/test_keys.mk`).
# Every subdirectory holding a main.tex compiles to target/<unit>/test_keys/<name>/main.pdf.

PROJECT_ROOT := $(abspath ../..)
UNIT         := $(notdir $(abspath ..))
# The course packages (recursive), then the math-shared submodule for grading.sty
# (NON-recursive: math-shared/examples holds main.tex files; see shared/lesson.mk).
TEXINPUTS    := $(PROJECT_ROOT)/shared//:$(PROJECT_ROOT)/math-shared:
PDF_DIR      := $(PROJECT_ROOT)/target/$(UNIT)/test_keys
LATEXFLAGS   := -xelatex -interaction=nonstopmode -halt-on-error -file-line-error

KEYS := $(patsubst %/main.tex,%,$(wildcard */main.tex))

# The practice test key doubles as the unit "sample test key" drop-in: its compiled
# PDF is published to ../sample_test_key/main.pdf, which shared/unit.mk merges into
# the FULL packet only. The actual test key is never published into a packet.
DROP_SRC := practice_test_key
DROP_DST := ../sample_test_key/main.pdf

.PHONY: all clean drop $(KEYS)

all: $(KEYS) drop

$(KEYS):
	@mkdir -p $(PDF_DIR)/$@
	cd $@ && TEXINPUTS="$(TEXINPUTS)" latexmk $(LATEXFLAGS) \
	    -outdir="$(PDF_DIR)/$@" main.tex
	@echo "OK  $(UNIT) test key -> target/$(UNIT)/test_keys/$@/main.pdf"

drop: $(DROP_SRC)
	@mkdir -p $(dir $(DROP_DST))
	cp $(PDF_DIR)/$(DROP_SRC)/main.pdf $(DROP_DST)
	@echo "OK  Published practice test key -> $(UNIT)/sample_test_key/main.pdf (unit key packet)"

clean:
	rm -rf $(PDF_DIR)

# `make manifest COMP=<name>` and `make roster-packets COMP=<name> ROSTER=<path>`
# run shared/tests.mk's grading targets for ../tests/<name> (a trailing _key is
# dropped, so the key directory's own name works too). See shared/tests.mk.
# ROSTER may start with ~/ and may be relative to this directory.
.PHONY: manifest roster-packets
manifest roster-packets:
	@$(MAKE) --no-print-directory -C ../tests $@ COMP=$(patsubst %_key,%,$(COMP)) \
	    $(if $(ROSTER),ROSTER="$(abspath $(patsubst ~/%,$(HOME)/%,$(ROSTER)))") $(if $(SECTION),SECTION="$(SECTION)")
