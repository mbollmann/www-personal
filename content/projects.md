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

<img src="/img/wordcloud-frau.svg" title="Historical spelling variants of German 'Frau'" class="img-fluid px-2 px-md-3 px-lg-4 px-xl-5 mb-4" />

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
Python 2.x) with the help of Florian Petran.
{{% /info_card %}}

### Text Generation

I worked briefly on natural language generation during my Master's studies.

{{% info_card
    title="SimpleNLG for German"
    relref="simplenlg.md"
%}}

An adaption of the [SimpleNLG library](https://github.com/simplenlg/simplenlg)
for natural language generation, written in Java, and created as part of my
studies for my Master's degree.  It has been superseded by [this SimpleNLG-DE
library](https://github.com/sebischair/SimpleNLG-DE), but my original adaption
is still provided here for archival reasons.
{{% /info_card %}}

{{% /bootstrap/col %}}

{{% bootstrap/col %}}
### Morphological Representations

In 2019, I've been awarded an [MSCA Individual
Fellowship](https://ec.europa.eu/research/mariecurieactions/actions/individual-fellowships_en)
to work on "Morphologically-Informed Representations for NLP" (MorphIRe).

<img src="/img/morph_seg.png" title="Different strategies for constructing word representations in NLP" class="img-fluid px-2 px-md-3 mb-3" />

This resulted in a large-scale analysis of [the role of morphology for error analysis in NLP](https://www.aclweb.org/anthology/2021.eacl-main.162/), which was awarded "Best Long Paper" at EACL 2021.  I have also worked on word segmentation algorithms in highly multilingual settings <i>(forthcoming)</i>, and contributed to a [meta-study of how NLP researchers cite older literature](https://www.aclweb.org/anthology/2020.acl-main.699).

<p><img src="/img/Flag_of_Europe.svg" title="Flag of Europe" class="float-right py-1 px-2 px-md-3" width="135" />
The project was funded from the European Union's Horizon&nbsp;2020 research and innovation programme under the Marie Skłodowska-Curie grant agreement No.&nbsp;845995.
</p>


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


#### ...and even more

Occasionally, I contribute to other open-source software projects or publish
some of my own.  You can [visit my GitHub
profile](https://github.com/mbollmann/) to see all my contributions.

{{% /bootstrap/col %}}
{{% /bootstrap/row %}}
