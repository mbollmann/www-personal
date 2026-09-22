#!/usr/bin/env make -f

SHELL := /bin/bash
HUGO_ENV ?= production

bibsources = $(wildcard bib/*.bib)
websources = $(shell find website -type f '(' -not -path "website/public/*" -not -path "website/resources/*" -not -name "*.lock" ')')

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

cv/cv.pdf: cv/cv.typ bib/anthology.yml $(ymlfiles) $(imgfiles)
	typst compile --root . cv/cv.typ cv/cv.pdf

bib/anthology.bib: pyproject.toml bin/fetch_anthology_bib.py
	uv run python bin/fetch_anthology_bib.py

%.yml: %.bib
	hayagriva $< > $@

# Cleaning up
.PHONY: clean
clean:
	rm -f bib/anthology.bib cv/cv.pdf website/data/bibliography.yaml website/.hugo_build.lock
	find bib -name "*.yml" -exec rm -f {} \;
	rm -rf website/public/
	rm -rf website/resources/
