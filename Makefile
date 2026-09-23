#!/usr/bin/env make -f

SHELL := /bin/bash
HUGO_ENV ?= production

bibsources = $(wildcard bib/*.bib)
websources = $(shell find website -type f '(' -not -path "website/public/*" -not -path "website/resources/*" -not -name "*.lock" ')')

.PHONY: all
all: check cv website

# Rules for building the website
.PHONY: website
website: website/public/index.html

website/public/index.html: $(websources) website/data/bibliography.yaml cv/cv.pdf
	cd website/ && hugo -e $(HUGO_ENV) --minify --cleanDestinationDir

website/data/bibliography.yaml: $(bibsources) pyproject.toml bin/process_bibtex.py
	uv run python bin/process_bibtex.py

# Rules for building the CV
.PHONY: cv
cv: cv/cv.pdf

ymlfiles = $(patsubst %.bib,%.yml,$(wildcard bib/*.bib))
imgfiles = $(wildcard cv/*.jpg)

cv/cv.pdf: cv/cv.typ $(ymlfiles) $(imgfiles)
	typst compile --root . cv/cv.typ cv/cv.pdf

%.yml: %.bib
	hayagriva $< > $@

# Running pre-commit checks
.PHONY: check
check:
	uv run pre-commit run --all-files

# Cleaning up
.PHONY: clean
clean:
	rm -f cv/cv.pdf website/data/bibliography.yaml website/.hugo_build.lock
	find bib -name "*.yml" -exec rm -f {} \;
	rm -rf website/public/
	rm -rf website/resources/
