---
Title: SimpleNLG for German
description: An adaption of the SimpleNLG library for German.
url: /software/simplenlg.html
---

## SimpleNLG for German

In 2010--2011, I worked on an adaption of the [SimpleNLG
library](https://github.com/simplenlg/simplenlg) for German as part of my
studies for my Master's degree. Since then, I have no longer been working in the
field of natural language generation. Unfortunately, this means that my adaption
has never quite been finished and "polished up" for release; I still decided to
provide what I have for other people who might potentially be interested in it.

If you use SimpleNLG for German in your own work, please cite the following
publication:

+ Marcel Bollmann. 2011. [Adapting SimpleNLG to
  German](http://www.aclweb.org/anthology/W11-2817). In *Proceedings of the 13th
  European Workshop on Natural Language Generation (ENLG 2011)*, pages 133–138,
  Nancy, France.

{{% bootstrap/row %}}
{{% bootstrap/col %}}
### Features

SimpleNLG is a Java library for generation of grammatically correct
sentences. Originally developed for English, I adapted it for German. For more
information, please refer to the [SimpleNLG
tutorial](https://github.com/simplenlg/simplenlg/wiki/Section-0-%E2%80%93-SimpleNLG-Tutorial).

Grammatical features covered by this adaption include, among others:

+ free ordering of sentence constituents, to account for the more flexible word
  order of German;
+ clusters of modal verbs; and
+ support for relative clauses and relative clause extraposition.


### Downloads

<ul>
<li><a class="btn btn-primary my-1" href="/pub/simplenlg-20140721.zip"><i class="fas fa-file-archive mr-2"></i>SimpleNLG for German (2014-07-21)</a></li>
<li><a class="btn btn-primary my-1" href="/pub/quick-guide.pdf"><i class="fas fa-file-pdf mr-2"></i>Quick guide (PDF)</a></li>
</ul>

{{% /bootstrap/col %}}
{{% bootstrap/col %}}
### Limitations

As I'm not able to devote time to the development of SimpleNLG for German
anymore, this release still has some considerable limitations. The most
important ones are:

+ it is based on the older version 3 architecture of SimpleNLG, which is now
  obsolete and also has a more restrictive license;
+ there is no proper lexicon---only a "toy lexicon" of around 100 entries is
  available---and lexicon lookup is quite slow and inefficient; and
+ it hasn't been thoroughly tested for bugs.


### Questions?

If you have any questions specific to my adaption of SimpleNLG for German,
please feel free to contact me. For questions about the original SimpleNLG,
please refer to the [SimpleNLG discussion
list](https://groups.google.com/forum/#!forum/simplenlg) instead.

If you would like to continue or contribute to the development of this software
package (e.g., porting it to the newer version 4 architecture), I'd be happy to
hear from you!

{{% /bootstrap/col %}}
{{% /bootstrap/row %}}
