---
Title: Projects
description: Links to software, datasets, and other resources on historical text normalization, morphological representations, and natural language generation.
date: "2019-05-06"
menu:
  main:
    weight: 40
---

## Projects

An overview of projects I worked on, with pointers to software, datasets, and
other associated resources.

{{% bootstrap/row %}}
{{% bootstrap/col %}}
### Historical Text Normalization

I've worked extensively on machine learning approaches to historical
text/spelling normalization, which ultimately became the topic of my PhD thesis.

<img src="/img/wordcloud-frau.svg" title="Historical spelling variants of German 'Frau'" class="img-fluid px-2 px-md-3 px-lg-4 px-xl-5" />

{{% info_card
    title="Tools & Resources for Historical Text Normalization"
    href="https://github.com/coastalcph/histnorm" %}}
A repository containing **datasets**, **utility scripts**, and **instructions** on how to use various tools to perform normalization.
{{% /info_card %}}

{{% info_card
    title="CorA (Corpus Annotator)"
    href="https://github.com/comphist/cora" %}}

A **web-based annotation tool** for word-level annotation of historical and
other non-standard language data. It was originally developed to annotate
historical texts for the
[Anselm](https://www.linguistics.rub.de/comphist/projects/anselm/) and
[ReF](https://www.linguistics.rub.de/comphist/projects/ref/) corpora, but has
since been used for a variety of other projects, including the [annotation of
social media
data](https://sites.google.com/site/empirist2015/home/shared-task-data).  {{%
/info_card %}}

{{% info_card
    title="Norma (Normalization Tool)"
    href="https://github.com/comphist/norma" %}}

A tool for **automatic spelling normalization** of non-standard language
data. It was originally developed for use with historical documents in the
[Anselm
project](https://www.linguistics.rub.de/comphist/projects/anselm/). Originally
written by me in Python, it was later ported to C++ (with optional bindings for
Python 2.x) with the help of Florian Petran.  {{% /info_card %}}

{{% /bootstrap/col %}}

{{% bootstrap/col %}}
### Morphological Representations

In 2019, I've been awarded an [MSCA Individual
Fellowship](https://ec.europa.eu/research/mariecurieactions/actions/individual-fellowships_en)
to work on "Morphologically-Informed Representations for NLP" (MorphIRe).  More
information will be published here over time.

### Websites

I've designed and maintained several websites, as the intersection of design and
technology has always been an interest of mine.

{{% info_card
    title="ACL Anthology"
    href="https://aclweb.org/anthology" %}}

I'm **Site Development Lead** for the ACL Anthology and have implemented the
recent static rewrite, including some design and layout changes.
{{% /info_card %}}

{{% info_card
    title="Research Projects & Conferences" %}}

I've built several websites for research projects and conferences:

- [Computational Historical Linguistics](https://www.linguistics.rub.de/comphist/)
- [St. Anselmi Fragen an Maria](https://www.linguistics.rub.de/anselm/)
- [Reference Corpus of Middle High German](https://www.linguistics.rub.de/rem/)
- [KONVENS 2016](https://www.linguistics.rub.de/konvens16/)
{{% /info_card %}}

### Text Generation

I worked briefly on natural language generation during my Master's studies.

{{% info_card
    title="SimpleNLG for German"
    relref="simplenlg.md"
%}}

An adaption of the [SimpleNLG library](https://github.com/simplenlg/simplenlg)
for natural language generation, written in Java, and created as part of my
studies for my Master's degree.
It is in dire need of an update for the current SimpleNLG v4 framework, and
also needs a lexical resource (not provided) for proper inflection of words.
{{% /info_card %}}

{{% /bootstrap/col %}}
{{% /bootstrap/row %}}

#### But wait, there's more...

Occasionally, I contribute to other open-source software projects or publish
some of my own.  You can [visit my GitHub
profile](https://github.com/mbollmann/) to see all my contributions.
