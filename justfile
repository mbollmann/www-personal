@_default:
    just -l

# Compile the CV to a PDF
cv:
    make cv

# Build the website
website:
    make website

# Build and serve the website locally
[working-directory: 'website']
serve: website
    hugo server

# Fetch the latest Anthology BibTeX
fetch-anthology-bib:
	uv run python bin/fetch_anthology_bib.py
