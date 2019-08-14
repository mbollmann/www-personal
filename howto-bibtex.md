# How to prepare the BibTeX

Citeproc's BibTeX parser is, to put it mildly, pretty crappy. In particular:

+ Author names should be separated by ` and `, without additional spaces, so do
  **not** use ` and `.
+ Author names should **not** contain line breaks (as the ACL Anthology BibTeX
  does, and every sane parser should handle).
