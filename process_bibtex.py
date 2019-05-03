#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright 2019 Marcel Bollmann <marcel@bollmann.me>

"""Usage: process_bibtex.py [options]

Converts all entries in a bibliography file to YAML.

Options:
  --bib=BIBFILE            Bibliography file to read from. [default: {scriptdir}/assets/personal.bib]
  --yaml=YAMLFILE          YAML file to write to. [default: {scriptdir}/data/bibliography.yaml]
  --csl=STYLE              Citation style to use. [default: association-for-computational-linguistics]
  --highlight-name=NAME    Author name to wrap in highlighted span. [default: Marcel Bollmann]
  --debug                  Output debug-level log messages.
  -h, --help               Display this helpful text.
"""

from docopt import docopt
import logging as log
import os
import yaml
from citeproc.source.bibtex import BibTeX as CiteprocBibTeX
from citeproc import CitationStylesStyle, CitationStylesBibliography
from citeproc import formatter
from citeproc import Citation, CitationItem
from citeproc_styles import get_style_filepath


class BibTeX(CiteprocBibTeX):
    # Custom hack of citeproc-py's BibTeX class to make it NOT discard
    # unrecognized fields (like 'url' and 'doi', but also internal ones we want
    # to use, like 'hugo_attach')
    def _bibtex_to_csl(self, bibtex_entry):
        csl_dict = {}
        for field, value in bibtex_entry.items():
            try:
                value = value.strip()
            except AttributeError:
                pass
            try:
                csl_field = self.fields[field]
            except KeyError:
                if field in ('year', 'month', 'filename'):
                    continue
                csl_field = field
            if field in ('number', 'volume'):
                try:
                    value = int(value)
                except ValueError:
                    pass
            elif field == 'pages':
                value = self._bibtex_to_csl_pages(value)
            elif field in ('author', 'editor'):
                value = [name for name in self._parse_author(value)]
            else:
                try:
                    value = self._parse_string(value)
                except TypeError:
                    value = str(value)
            csl_dict[csl_field] = value
        return csl_dict


def decorate_name(text, name):
    name = str(name)
    if name in text:
        span = '<span class="bibitem-highlight-name">{}</span>'.format(name)
        text = text.replace(name, span)
    return text


def infer_url(item):
    url = item.get_field("url")
    if url is None:
        if item.get_field("doi") is not None:
            url = "https://dx.doi.org/{}".format(item.get_field("doi"))
    return url


def decorate_title(text, item):
    url = infer_url(item)
    title = item.get_field("title")
    if title in text:
        if url is not None:
            span = '<a href="{}" class="bibitem-title">{}</a>'.format(url, title)
        else:
            span = '<span class="bibitem-title">{}</span>'.format(title)
        text = text.replace(title, span)
    else:
        log.error("Couldn't find title string in: {}".format(item.get_field("key")))
    return text


def parse_bibliography(bibfile, cslstyle):
    log.debug("Loading BibTeX")
    bib_src = BibTeX(bibfile, encoding="utf-8")
    log.debug("Instantiating CSL classes")
    bib_style = CitationStylesStyle(cslstyle, validate=False)
    bibliography = CitationStylesBibliography(bib_style, bib_src, formatter.html)
    for key in bib_src:
        log.debug("Registering key: {}".format(key))
        bibliography.register(Citation([CitationItem(key)]))
    return bibliography


def parse_raw_bibtex(bibfile):
    log.debug("Loading BibTeX (raw)")
    bib = {}
    key = ""
    entry = []
    with open(bibfile, "r", encoding="utf-8") as f:
        for line in f:
            line = line.rstrip()
            if not line:
                continue
            if line.lstrip().startswith("hugo_"):
                # internal field that should not appear in BibTeX output
                continue
            entry.append(line)
            if line == "}":
                bib[key] = "\n".join(entry)
                entry = []
            elif line.startswith("@"):
                key = line.split("{")[-1].split(",")[0]
    return bib


if __name__ == "__main__":
    args = docopt(__doc__)
    scriptdir = os.path.dirname(os.path.abspath(__file__))
    if "{scriptdir}" in args["--bib"]:
        args["--bib"] = os.path.abspath(args["--bib"].format(scriptdir=scriptdir))
    if "{scriptdir}" in args["--yaml"]:
        args["--yaml"] = os.path.abspath(args["--yaml"].format(scriptdir=scriptdir))

    log_level = log.DEBUG if args["--debug"] else log.INFO
    log.basicConfig(format="%(levelname)-8s %(message)s", level=log_level)

    cslstyle = get_style_filepath(args["--csl"])

    log.info("Reading file: {}".format(args["--bib"]))
    bib = parse_bibliography(args["--bib"], cslstyle)
    raw = parse_raw_bibtex(args["--bib"])

    log.info("Generating entries")
    yaml_dict = {}
    for item in bib.items:
        key = item.get_field("key")
        log.debug("Generating entry for key: {}".format(key))
        text = str(bib.style.render_bibliography([item])[0])
        text = decorate_name(text, args["--highlight-name"])
        text = decorate_title(text, item)
        yaml_dict[key] = {
            'raw': raw[key],
            'html': text,
            'year': item.reference.get("issued").year,
            'title': item.get_field("title")
        }
        if item.get_field("hugo_pdf") is not None:
            hugo_pdf = item.get_field("hugo_pdf")
            if hugo_pdf == "infer":
                hugo_pdf = infer_url(item)
            yaml_dict[key]["hugo_pdf"] = hugo_pdf
        for field in ("url", "doi", "hugo_attach"):
            if item.get_field(field) is not None:
                yaml_dict[key][field] = item.get_field(field)

    log.info("Writing YAML to {}".format(args["--yaml"]))
    with open(args["--yaml"], "w") as f:
        f.write(yaml.dump(yaml_dict))
