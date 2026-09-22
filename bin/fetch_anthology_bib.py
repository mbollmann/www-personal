# Copyright 2026 Marcel Bollmann <marcel@bollmann.me>

"""Usage: fetch_anthology_bib.py [options]

Writes all BibTeX entries for a given ACL Anthology user into a file.

Options:
  --out=OUTFILE       Data file to write to. [default: {scriptdir}/../bib/anthology.bib]
  --user=USERID       Anthology user ID. [default: marcel-bollmann]
  --debug             Output debug-level log messages + log messages from other libraries.
  -h, --help          Display this helpful text.
"""

from acl_anthology import Anthology
from acl_anthology.exceptions import NameSpecResolutionWarning
from acl_anthology.utils import setup_rich_logging
from docopt import docopt

import logging
import os
import rich
import warnings

if __name__ == "__main__":
    args = docopt(__doc__)
    scriptdir = os.path.dirname(os.path.abspath(__file__))
    for file_arg in ("--out",):
        if "{scriptdir}" in args[file_arg]:
            args[file_arg] = os.path.abspath(args[file_arg].format(scriptdir=scriptdir))

    log_level = logging.DEBUG if args["--debug"] else logging.INFO
    setup_rich_logging(level=log_level)

    with warnings.catch_warnings(action="ignore", category=NameSpecResolutionWarning):
        anthology = Anthology.from_repo()
        papers = anthology.get_person(args["--user"]).papers()

    with open(args["--out"], "w") as f:
        for paper in sorted(papers, key=lambda p: (p.year, p.title.as_text())):
            rich.print(f"Exporting [bold yellow]{paper.bibkey}[/]")
            print(paper.to_bibtex(), file=f)
            print(file=f)
