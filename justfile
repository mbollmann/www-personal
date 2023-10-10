build: bibtex
  hugo --minify --cleanDestinationDir

serve: bibtex
  hugo server

venv:
  #!/usr/bin/env sh
  if [ ! -d .venv ] ; then
    python3 -m venv .venv
    ./.venv/bin/python3 -m pip install -r requirements.txt
  fi

bibtex: venv
  ./.venv/bin/python3 ./process_bibtex.py

upload: build
  find public/ -type d -exec chmod a+rx {} \;
  find public/ -type f -exec chmod a+r {} \;
  rsync -rvP --delete public/* uberspace:html/
