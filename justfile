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

# Upload the website to the server
[working-directory: 'website']
upload: website
    find public/ -type d -exec chmod a+rx {} \;
    find public/ -type f -exec chmod a+r {} \;
    rsync -rvP --delete public/* uberspace:html/
