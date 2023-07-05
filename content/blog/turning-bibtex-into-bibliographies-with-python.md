---
Title: Turning BibTeX into bibliographies with Python (is a nightmare)
date: "2023-07-04"
---

Academic websites often contain lists of publications, and at least in my field,
keeping references in [BibTeX](https://en.wikipedia.org/wiki/BibTeX) format is
very common as it's needed for nearly every paper we write. I've
[built](https://www.linguistics.rub.de/comphist/) [a lot
of](https://aclanthology.org/) [websites](https://marcel.bollmann.me/) over the
years, mostly using static site generators such as [Hugo](https://gohugo.io/),
so naturally I'd like to build publication lists directly from BibTeX files —
add a new paper to the BibTeX source, render its reference on the website, easy!
My programming language of choice is Python, which has such an enormous
ecosystem of libraries that this should be an easy task, right? …Right?

## Problem statement

Let's spell out what exactly I'm trying to achieve. I want to have a script that
can:

1. Parse the contents of a BibTeX file.
2. Render a formatted bibliography entry (in HTML or Markdown).
3. _Preferably_ provide ways to:
	- Turn the paper's title into a link to its URL.
	- Highlight certain author names (useful for a personal or group website).

In other words, I want to go from this:

```bibtex
@inproceedings{bollmann-sogaard2021-error,
    title = "Error Analysis and the Role of Morphology",
    author = "Bollmann, Marcel  and
      S{\o}gaard, Anders",
    booktitle = "Proceedings of the 16th Conference of the European Chapter of the Association for Computational Linguistics: Main Volume",
    month = apr,
    year = "2021",
    address = "Online",
    publisher = "Association for Computational Linguistics",
    url = "https://aclanthology.org/2021.eacl-main.162",
    doi = "10.18653/v1/2021.eacl-main.162",
    pages = "1887--1900",
}
```

To (something like) this:

- **Marcel Bollmann** and Anders Søgaard. 2021. [Error Analysis and the Role of
  Morphology](https://www.aclweb.org/anthology/2021.eacl-main.162). In
  _Proceedings of the 16th Conference of the European Chapter of the Association
  for Computational Linguistics: Main Volume_, pages 1887–1900,
  Online. Association for Computational Linguistics.

- - -

## Existing Python libraries

Ideally I want to do this in Python, since it's what I and my colleagues know
best. So let's see what libraries are out there that can help us!

### BibtexParser

One of the first search results that come up is
[BibtexParser](https://github.com/sciunto-org/python-bibtexparser), which looks
like an excellent option for addressing the first step, parsing a BibTeX
file. It's actively developed, [reasonably well
documented](https://bibtexparser.readthedocs.io/en/main/), and used by thousands
of public Github repos.

First, if you're planning to use BibtexParser, make sure you're using the beta
v2 version, which the authors explicitly recommend for new projects, but don't
make available on PyPI yet for some reason. Therefore, install it directly from
Github:

```fish
pip install --no-cache-dir --force-reinstall git+https://github.com/sciunto-org/python-bibtexparser@main
```

Using it is quite straightforward: give it a string to parse, and optionally
supply a bunch of "middlewares" which perform additional transformations on the
data, like splitting up author names into their individual components.

```python
import bibtexparser
from bibtexparser import middlewares as mw

library = bibtexparser.parse_string(
    bibdata,
    append_middleware=[
        # transforms {\"o} -> ö, removes curly braces, etc.
        mw.LatexDecodingMiddleware(),
        # transforms apr -> 4 etc.
        mw.MonthIntMiddleware(True),
        # turns author field with multiple authors into a list
        mw.SeparateCoAuthors(),
        # splits author names into {first, von, last, jr}
        mw.SplitNameParts(),
    ],
)
```

In my (limited) experience, this is quite robust to different BibTeX formats and
just generally _works_. With this parsed `library` object, accessing individual
BibTeX entries and the data within them is quite simple:

```python
entry = library.get_as_entry("bollmann-sogaard2021-error")
entry.fields_dict["author"].value
# Gives:
#   [NameParts(first=['Marcel'], von=[], last=['Bollmann'], jr=[]),
#    NameParts(first=['Anders'], von=[], last=['Søgaard'], jr=[])]
```

Unfortunately for our purposes, and as the name of the library suggests,
BibtexParser focuses exclusively on _parsing_ BibTeX, and is not at all
concerned with turning the parsed data into something else.

You might be tempted to write some simple formatting logic yourself. Author
names, paper title, proceedings/journal title, done. And yes, depending on how
many different [bibtypes](https://www.bibtex.com/e/entry-types/) you need to
support, and how you want your formatted bibliography to look, this might be
totally sufficient. It's easy to underestimate though how quickly the formatting
logic can grow quite complex. There's a reason why [even the plain BibTeX style
has hundreds of lines of
definitions](http://mirrors.ctan.org/biblio/bibtex/base/plain.bst). Personally,
I wasn't satisfied with this approach — I'd like the formatting to be done in a
more systematic way as well.


### Pybtex

This is where we find [Pybtex](https://pybtex.org/), a "BibTeX-compatible
bibliography processor written in Python". It's intended to work as a drop-in
replacement for BibTeX, so that you can literally run `pybtex` instead of
`bibtex` when compiling your LaTeX documents. That means it must do both the
parsing _and_ the formatting according to some BibTeX style definition. This
sounds promising!

_(As an aside, how do you pronounce Pybtex? "pie-bee-tek"? "pibe-tek"?
"pip-tek"? I need to know!)_

Turning a BibTeX file into an HTML bibliography with Pybtex is ridiculously
easy:

```python
import pybtex
pybtex.format_from_file("mypapers.bib", style="plain", output_backend="html")
```

Done! If I run this with a file containing my example entry above, I get this:

```html
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
  <head>
    <meta name="generator" content="Pybtex">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Bibliography</title>
  </head>
  <body>
    <dl>
      <dt>1</dt>
      <dd>Marcel Bollmann and Anders S<span class="bibtex-protected">ø</span>gaard.
      Error analysis and the role of morphology.
      In <em>Proceedings of the 16th Conference of the European Chapter of the Association for Computational Linguistics: Main Volume</em>, 1887–1900. Online, April 2021. Association for Computational Linguistics.
      URL: <a href="https://aclanthology.org/2021.eacl-main.162">https://aclanthology.org/2021.eacl-main.162</a>, <a href="https://doi.org/10.18653/v1/2021.eacl-main.162">doi:10.18653/v1/2021.eacl-main.162</a>.</dd>
    </dl>
  </body>
</html>
```

That's pretty good for almost no effort on my part!

Okay, but maybe I want to customize this a little more. The URL is given at the
end instead of using the paper title as the link text; both URL and DOI are
printed; and the author names are not wrapped in `<span>`s so I can't easily
highlight my name. Since Pybtex can work as a drop-in replacement for BibTeX, it
must be able to use any BibTeX style file (`.bst`) for formatting its
bibliographies, right?

Well, yes and no.

See, Pybtex comes with two "formatting engines": a _BibTeX engine_ and a _Python
engine_. The former can process `.bst` styles, but only supports LaTeX
output. The latter can output a variety of formats, namely LaTeX, Markdown,
HTML, or plain text, but requires styles to be [_written in
Python_](https://docs.pybtex.org/api/styles.html).

Pybtex itself only comes with [a minimal set of Pythonic formatting
styles](https://bitbucket.org/pybtex-devs/pybtex/src/master/pybtex/style/formatting/),
and very few people appear to have [made other Pybtex-compatible
styles](https://github.com/search?q=pybtex%20style&type=repositories). So we're
essentially back to where we were with BibtexParser: we'd have to write our own
formatting logic, although this time at least within a predefined framework that
Pybtex gives us.

I'm still wondering if there isn't something better out there, so let's continue
the search.


### Citeproc-py

[Citeproc](https://en.wikipedia.org/wiki/CiteProc) is the name for any tool that
uses [Citation Style Language (CSL)](https://citationstyles.org/) files to
produce formatted bibliographies. CSL is an open-source specification for
citation and bibliography styles; it comes with a repository containing [over
10,000 pre-defined
styles](https://github.com/citation-style-language/styles). Wow! Not all of them
are quite up-to-date — for example, their [ACL style
file](https://github.com/citation-style-language/styles/blob/master/association-for-computational-linguistics.csl)
was last updated in 2013 — but this could still give us a solid starting point.

CSL processors exist [for a variety of programming
languages](https://citationstyles.org/developers/). The most mature
implementation appears to be [Citeproc for
Haskell](https://hackage.haskell.org/package/citeproc), which is used by the
well-known [pandoc](https://pandoc.org/) tool. A Python implementation exists in
the form of [Citeproc-py](https://github.com/brechtm/citeproc-py/);
unfortunately, as of July 2023, it is lacking maintainers. In my experience,
this is particularly an issue when trying to parse BibTeX files with it.

Some of the issues I ran into when trying to parse BibTeX with Citeproc-py:

- BibTeX fields that are not recognized by the parser are discarded, meaning you
  can't access them at all afterwards. Unsupported fields include `"url"` and
  `"doi"`. Yes, you read that right.
- Splitting the `"author"` field into multiple author names is done by
  [splitting on the literal `" and
  "`](https://github.com/brechtm/citeproc-py/blob/fef20586ddca0fac4d0c301119a871625a21926f/citeproc/source/bibtex/bibtex.py#L249). If
  your BibTeX entries have _two_ spaces or newlines before or after "and",
  parsing will fail.
- The code that handles TeX macros [is not compatible with Python
  3.7+](https://github.com/brechtm/citeproc-py/issues/103) and will raise an
  exception there. Python 3.7 has already reached end-of-life; Citeproc-py
  doesn't yet fully support it or any newer versions.

_(To be clear, I'm not blaming the original creators of Citeproc-py
here. Maintaining an open-source project is a lot of effort and requires a lot
of time. This is simply an observation that, from a library user's point of
view, Citeproc-py is incredibly outdated.)_

On the plus side, so far I have not run into any issues with the _formatting_
part of the library. Plugging in a CSL file and generating a bibliography
appears to work just fine — in fact, it's what we're using to generate the
formatted reference strings on the [ACL Anthology](https://aclanthology.org).

Coding-wise though, it's far from _convenient_. Let me elaborate. First of all,
I'm assuming we use both Citeproc-py as well as the supplementary package that
gives access to the [CSL styles
repo](https://github.com/citation-style-language/styles):

```fish
pip install citeproc-py citeproc-py-styles
```

Let's ignore the BibTeX parsing issues for now and assume that we're working
with a very simple `.bib` file that doesn't trigger any of the problems above;
then this is how we'd instantiate our library:

```python
from citeproc.source.bibtex import BibTeX
from citeproc import CitationStylesStyle, CitationStylesBibliography, formatter
from citeproc_styles import get_style_filepath

# Load BibTeX file
bib_src = BibTeX("mypapers.bib", encoding="utf-8")

# Load CSL file — name can be anything that has a .csl file in the repo
stylepath = get_style_filepath("association-for-computational-linguistics")
bib_style = CitationStylesStyle(stylepath, validate=False)

# Instantiate library
library = CitationStylesBibliography(bib_style, bib_src, formatter.html)
```

Quite wordy. Generating individual bibliography entries is also a bit
cumbersome:

```python
from citeproc import Citation, CitationItem

# First, we need to explicitly register a citation to our paper,
# because it won't show up in the bibliography otherwise.
item = CitationItem("bollmann-sogaard2021-error")
library.register(Citation([item]))

# Now, we can render a bibliography containing only this item.
# It's a list of entries, which are lists of strings, so we have
# to do some indexing and concatenating.
text = ''.join(library.style.render_bibliography([item])[0])

# text == 'Bollmann, M., &amp; Søgaard, A.. (2021). Error Analysis and the Role of Morphology. <i>Proceedings of the 16th Conference of the European Chapter of the Association for Computational Linguistics: Main Volume</i>, 1887–1900.'
```

While the interface feels like it could be a lot more intuitive, the flexibility
it gives us with using CSL files is nice. But how, then, to properly feed the
BibTeX data into Citeproc-py, if their own parser has so many issues? Can we use
BibtexParser or Pybtex, then plug the bibliography entries into Citeproc-py for
formatting? Well… yes and no.

Compared to BibTeX, the CSL specification uses different [names for entry types
and
fields](https://docs.citationstyles.org/en/stable/specification.html#appendix-iii-types);
for example, BibTeX's "inproceedings" maps to CSL's "paper-conference"; BibTeX's
"booktitle" or "journal" fields should be named "container_title" in CSL; and so
on. It's therefore not enough to simply _parse_ the BibTeX files; you also have
to _convert_ the BibTeX terminology into the corresponding terms that CSL
expects and recognizes.

In summary, while Citeproc-py handles the formatting part of our problem quite
nicely, now the parsing part suddenly requires a lot more effort.

- - -

## Citation styles and (the lack of) semantic markup

Before I present the solution that I settled with, I need to pause for a moment
to rant about the way that citation styles and formatting libraries handle
markup.

One of my stated "nice-to-have" features was to highlight certain author names;
this can be handy for highlighting your own name in publications on your
personal website, or highlighting group members in the publication list of an
academic research group. If the formatting library itself does not support this
(and I don't know of any that does), we could try to inject some markup into the
_input_ already, for example by adding HTML tags to an author's name; but this
seems incredibly hacky and error-prone, as it could interfere with formatting
rules of the citation style. Modifying the already-formatted _output_ seems like
the safer bet.

At this point, since I'm dealing with HTML, I wish there was a way to get
_semantic markup_ in formatted bibliography strings. Whether it's in the form of
a custom HTML tag or just a span with a CSS class, I feel it would be super
practical to have an HTML string like this:

```html
<div class="bib-entry">
  <span class="bib-author"><span class="name">Marcel Bollmann</span> and <span class="name">Anders Søgaard</span></span>.
  <span class="bib-year">2021</span>.
  <span class="bib-title">Error Analysis and the Role of Morphology</span>.
  In <span class="bib-booktitle">Proceedings of the 16th Conference of the European Chapter of the Association for Computational Linguistics: Main Volume</span>, pages <span class="bib-pages">1887–1900</span>.
  <span class="bib-publisher">Association for Computational Linguistics</span>.
</div>
```

This would allow me to apply additional formatting to some of the elements,
e.g. if I wanted to **bold** my paper titles; and it would be trivial to use a
library like [lxml](https://lxml.de/lxmlhtml.html) to iterate over all names,
see if one of them matches mine, and if so, add another CSS class to the
`<span>` in question.

Alas, since citation styles originate in print, they use visual markup instead,
[setting formatting attributes like "italic", "bold", "underline"
etc. directly](https://docs.citationstyles.org/en/stable/specification.html#formatting),
and I'm not aware of any formatting library that preserves information on which
parts of the output correspond to which field in the input. Pybtex, which allows
defining custom citation styles as Python classes, [has a `Tag`
class](https://docs.pybtex.org/api/styles.html#pybtex.richtext.Tag) that could
in principle be used to render arbitrary HTML tags (although without attributes,
so you'd have to render `<bib-author>` instead of `<span
class="bib-author">`). I'm not sure if that falls under an intended use of this
feature, though, and I haven't tried going this route.

- - -

## Frankensteining a solution

Before I embarked on this journey, I only had an incredibly hacky script that I
used for generating the [publication list on my personal
website](https://marcel.bollmann.me/publications/). In essence, that script used
Citeproc-py for producing the bibliography, and monkey-patched Citeproc-py's
BibTeX parser to not throw away unknown BibTeX fields, so I could use these
fields to modify the generated output later. I was hoping to replace this with
something saner, partly because I wanted to re-use this script for other sites,
like my research group's website.

Well, I failed.

The most "proper" way to do this, I believe, would most likely be to [write a
Pybtex plugin](https://docs.pybtex.org/api/plugins.html). But this would also
involve re-implementing the bibliography style that I want in form of a Python
class for Pybtex, which seemed like too much effort to me. In hindsight, I'm not
so sure, but it is what it is. Alternatively, of course, I could just give up on
doing this in Python, and use a language with better library support for this
kind of thing instead.

But since I'm stubborn, this is the solution I settled for:

- Use [Citeproc-py](https://github.com/brechtm/citeproc-py) for formatting the
  bibliography entries, because it doesn't require me to re-write a citation
  style and bibliography formatting rules from scratch, and even though the
  library on the whole is pretty outdated, the formatting part generally works.
- Use [BibtexParser](https://github.com/sciunto-org/python-bibtexparser) for
  parsing the BibTeX, but frankenstein it into [Citeproc-py's BibTeX
  class](https://github.com/brechtm/citeproc-py/blob/master/citeproc/source/bibtex/bibtex.py)
  to re-use the part of its functionality that isn't broken, and generally make
  it easier to feed the parsed BibTeX entries into citeproc-py for formatting.
- Use regex search-and-replace for wrapping selected names in HTML spans. Yes,
  it feels incredibly hacky, and I wish I had semantic markup to work with
  instead; but unless you write a [paper about Liu Shen
  capsules](https://www.sciencedirect.com/science/article/pii/S1043661820311580)
  and your name also happens to be Liu Shen, it will do the correct thing 99.9%
  of the time.

Since I wanted to use this for multiple projects, I turned it into a small
library and [unleashed it unto the
world](https://github.com/mbollmann/yabibf). I call it
[yabibf](https://github.com/mbollmann/yabibf), for "Yet Another BIBliography
Formatter". I feel it sounds just as inelegant as the solution it implements.
