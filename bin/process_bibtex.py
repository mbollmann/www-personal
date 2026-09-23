# Copyright 2023 Marcel Bollmann <marcel@bollmann.me>

"""Usage: process_bibtex.py [options]

Converts all entries in a bibliography file to a data file (intended for static
site generation), currently in YAML format.

Options:
  --bib=DIRECTORY     Directory with .bib files to read from. [default: {scriptdir}/../bib]
  --out=OUTFILE       Data file to write to. [default: {scriptdir}/../website/data/bibliography.yaml]
  --names=NAMEFILE    File with names that will be marked up in the generated bibliography.
                      [default: {scriptdir}/../bib/groupmember-names.txt]
  --style=STYLE       Name of citation style to use; must be a filename or name of a style
                      findable by citeproc-py-styles.
                      [default: {scriptdir}/../bib/association-for-computational-linguistics.csl]
  --debug             Output debug-level log messages + log messages from other libraries.
  -h, --help          Display this helpful text.
"""

import logging
import os
import sys
from pathlib import Path

import yaml
from docopt import docopt
from rich.logging import RichHandler
from yabibf import BibTeX, CiteprocFormatter, LinkTitleDecorator, NameDecorator


def load_names_list(namefile: str) -> list[str]:
    with open(namefile, "r") as f:
        names = [line.strip() for line in f if line[0] != "#"]
    return names


def main(args):
    log = logging.getLogger("process_bibtex")

    bibfiles = list(Path(args["--bib"]).glob("*.bib"))
    library = BibTeX(bibfiles)
    for block in library.library.failed_blocks:
        if type(block).__name__ == "DuplicateBlockKeyBlock":
            log.warning(
                f"Duplicate key: [yellow]{block.key}[/]",
                extra={"markup": True, "highlighter": None},
            )
        else:
            raw = block.raw.split("\n")[0][:50]
            log.error(f"Parsing error: [italic]{raw}...[/]", extra={"markup": True})
    log.debug(
        f"Parsed {(n := len(library.entries))} entr{'y' if n == 1 else 'ies'} "
        f"in {(m := len(bibfiles))} file{'' if m == 1 else 's'}."
    )

    highlight_names = load_names_list(args["--names"])
    log.debug(
        f"Found {(n := len(highlight_names))} name{'' if n == 1 else 's'} to highlight."
    )

    style = str(args["--style"])
    formatter = CiteprocFormatter(style, library)
    formatter.decorators = [
        NameDecorator(highlight_names),
        LinkTitleDecorator(),
    ]

    data = {}
    for entry in library.entries:
        data[entry.key] = {
            "year": entry["year"],
            "html": formatter.render(entry),
            "raw": entry.raw,
        }
        if "hugo_attach" in entry:
            data[entry.key]["hugo_attach"] = entry["hugo_attach"]

    with open(args["--out"], "wt") as f:
        yaml.dump(data, stream=f)

    log.info(f"Wrote {len(data)} entries to {args['--out']}")


if __name__ == "__main__":
    args = docopt(__doc__)
    scriptdir = os.path.dirname(os.path.abspath(__file__))
    for file_arg in ("--bib", "--names", "--out", "--style"):
        if "{scriptdir}" in args[file_arg]:
            args[file_arg] = os.path.abspath(args[file_arg].format(scriptdir=scriptdir))

    log_level = logging.DEBUG if args["--debug"] else logging.INFO
    handler = RichHandler()
    if not args["--debug"]:
        handler.addFilter(logging.Filter("process_bibtex"))
    logging.basicConfig(
        format="%(message)s", datefmt="[%X]", level=log_level, handlers=[handler]
    )

    sys.exit(main(args))
