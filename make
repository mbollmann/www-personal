#!/bin/bash

set -o errexit

python3 ./process_bibtex.py
hugo --minify --cleanDestinationDir
