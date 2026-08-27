SHELL := /usr/bin/env bash

MAIN := main.tex
SECTION_SCRIPT := scripts/new-tex-section

.PHONY: help pdf watch clean distclean section subfile

help:
	@printf '%s\n' \
		'Available targets:' \
		'  make pdf                         Build the complete paper.' \
		'  make watch                       Continuously rebuild the complete paper.' \
		'  make clean                       Remove regenerable build files.' \
		'  make distclean                   Remove all build output, including the PDF.' \
		'  make section SECTION=PATH        Create a normal TeX section file.' \
		'  make subfile SECTION=PATH        Create an independently compilable subfile.' \
		'' \
		'Examples:' \
		'  make section SECTION=sections/03-methods' \
		'  make section SECTION=sections/appendices/proofs.tex' \
		'  make subfile SECTION=sections/03-methods'

pdf:
	latexmk $(MAIN)

watch:
	latexmk -pvc $(MAIN)

clean:
	latexmk -c $(MAIN)

distclean:
	latexmk -C $(MAIN)

section:
	@test -n "$(SECTION)" || { \
		printf '%s\n' 'Error: SECTION is required.' >&2; \
		printf '%s\n' 'Usage: make section SECTION=sections/03-methods' >&2; \
		exit 2; \
	}
	@"$(SECTION_SCRIPT)" "$(SECTION)"

subfile:
	@test -n "$(SECTION)" || { \
		printf '%s\n' 'Error: SECTION is required.' >&2; \
		printf '%s\n' 'Usage: make subfile SECTION=sections/03-methods' >&2; \
		exit 2; \
	}
	@"$(SECTION_SCRIPT)" --subfiles "$(SECTION)"