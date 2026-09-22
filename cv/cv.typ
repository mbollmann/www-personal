#import "@preview/neat-cv:1.2.0": *

#set text(lang: "en")

#let entry-alt(
  /// Entry title
  /// -> string | none
  title: none,
  /// Date or range
  /// -> string
  date: "",
  /// Institution or companyemployee
  /// -> string
  institution: "",
  /// Subtitle
  /// -> string
  subtitle: "",
  /// Description/details
  /// -> content
  description,
) = {
  context block(above: 1em, below: 0.65em)[
    #let theme = __st-theme.final()

    #grid(
      columns: (ENTRY_LEFT_COLUMN_WIDTH, auto),
      align: (right, left),
      column-gutter: .8em,
      [
        #text(
          size: ENTRY_DATE_FONT_SIZE_SCALE * 1em,
          fill: theme.font-color.lighten(50%),
          date,
        )
      ],
      [
        #set text(size: ENTRY_CONTENT_FONT_SIZE_SCALE * 1em)

        #text(weight: "semibold", title)

        #text(size: 0.9em, smallcaps([
          #if institution != "" or subtitle != "" [
            #subtitle
            #h(1fr)
            #if institution != "" [
              #fa-icon("school", size: 0.85em, fill: theme.accent-color)
              #institution
            ]
          ]
        ]))

        #text(size: 0.9em, description)
      ],
    )
  ]
}

#let format-publication-entry(
  pub
) = {
  let as-editor = false

  if ("author" not in pub) {
    pub.author = pub.editor
    as-editor = true
  }

  // Make sure that author is an array
  if (type(pub.author) == str) {
    pub.author = (pub.author,)
  }

  let highlighted-authors = ("Bollmann, Marcel",).map(a => __author-name(
    a,
    pub.__id,
  ))
  let __format-author(author, pub_id) = (
     __author-name(author, pub_id).split(", ").rev().join(" ")
  )
  let has-output-after-fullstop = false

  for (i, author) in pub.author.enumerate() {
    //let author = __author-name(author, pub.__id)

    let author-display = __format-author(author, pub.__id)
    let author-highlighted = __author-highlighted(
      author,
      highlighted-authors,
      pub.__id,
    )

    if author-highlighted {
      text(weight: "medium", author-display)
    } else {
      author-display
    }

    if i < pub.author.len() - 1 {
      if i == pub.author.len() - 2 {
        [, and ]
      } else {
        [, ]
      }
    }
  }

  if as-editor {
    if pub.author.len() > 1 {
      [ (Eds.)]
    } else {
      [ (Ed.)]
    }
  }
  [.]
  has-output-after-fullstop = false

  if "date" in pub {
    [ #str(pub.date).split("-").at(0).]

  }

  if "url" in pub and pub.url != none and type(pub.url) == str {
    [ #link(pub.url)["#pub.title.replace(regex("[{}]"), "")"].]
  } else {
    [ "#pub.title.replace(regex("[{}]"), "")".]
  }

  // TODO: handle cases where parent is missing gracefully
  // at the moment we could assert its presence like this:
  // assert("parent" in pub,
  //     message: "Missing 'parent' field for publication:\n" +
  //     repr(pub) +
  //     "\nPlease ensure that the 'parent' field is provided.")
  // Alternative is to implement the Hayagriva spec more fully
  // Below is only a partial implementation

  if (not "parent" in pub) {
    if "publisher" in pub {
      if (type(pub.publisher) == dictionary) {
        [ _#pub.publisher.name.replace(regex("[{}]"), "")_]
      } else {
        [ _#pub.publisher.replace(regex("[{}]"), "")_]
      }
      has-output-after-fullstop = true
    }
  } else {
    let parent = pub.parent

    if parent.type == "proceedings" {
      [ In ]
    }

    [ _#parent.title.replace(regex("[{}]"), "")_]
    has-output-after-fullstop = true

    if "volume" in parent and parent.volume != none {
      [ _#(parent.volume)_]
    }

    if "issue" in parent and parent.issue != none {
      [_(#parent.issue)_]
    }
  }

  if has-output-after-fullstop and "page-range" in pub and pub.page-range != none {
    [_:#(pub.page-range)_]
  }

  if "serial-number" in pub and "doi" in pub.serial-number {
    if has-output-after-fullstop [,]
    [ #smallcaps("doi:") #link("https://doi.org/" + pub.serial-number.doi)[_#(pub.serial-number.doi)_]]
    has-output-after-fullstop = true
  }

  if "url" in pub and pub.url != none and type(pub.url) == str {
    if has-output-after-fullstop [,]
    [ #smallcaps("url:") #link(pub.url)[#(pub.url)]]
    has-output-after-fullstop = true
  }

  if has-output-after-fullstop [.]
}

#let talk-title(title) = ["#title"]
#let ext-link(url, title) = [#title (#link(url))]

#show: cv.with(
  author: (
    firstname: "Marcel",
    lastname: "Bollmann",
    email: "marcel@bollmann.me",
    // address: [],
    phone: "+46 (0)13-28 1572",
    position: ("Associate Professor in Computer Science & Natural Language Processing"),

    website: "https://marcel.bollmann.me/",
    github: "mbollmann",
    // scholar: "l3pm9QkAAAAJ",
    orcid: "0000-0003-2598-8150",
    custom-links: (
      (
        icon-name: "google-scholar", // Font Awesome icon name
        label: "Google Scholar",
        url: "https://scholar.google.com/citations?user=l3pm9QkAAAAJ",
      ),
      (
        icon-name: "book",
        label: "Semantic Scholar",
        url: "https://www.semanticscholar.org/author/Marcel-Bollmann/34887843",
      ),
    ),
  ),

  profile-picture: image("employee_image_marbo59.jpg"),
  accent-color: rgb("#4682b4"),
  // font-color: rgb("#333333"),
  header-color: rgb("#38678f"),
  // date: auto,
  // heading-font: "Fira Sans",
  // body-font: ("Noto Sans", "Roboto"),
  // body-font-size: 10.5pt,
  paper-size: "a4",
  // layout-overrides: (side-width: 4cm, header-padding: auto, header-body-gap: 3mm, page-margin-x: 12mm, page-margin-y: 15mm),
  // gdpr: false,
  // footer: auto,
)

#cv-with-side[
  = Contact
  #contact-info()

  /*= About me
  My research interests revolve around natural language processing (NLP) and machine learning (ML) in challenging scenarios, such as lesser-resourced languages, multilinguality, or historical documents.
  */

  = Personal
  Citizenship: German

  Born: 5 September 1984

  = Links
  #social-links()

  //#v(1fr)
  = Languages
  #item-with-level("German", 5, subtitle: "Native")
  #item-with-level("English", 5, subtitle: "C1/C2")
  #item-with-level("Swedish", 4, subtitle: "B2/C1")
  #item-with-level("Danish", 2, subtitle: "A2/B1")
  // #item-with-level("French", 1, subtitle: "Elementary")
  // #item-with-level("Japanese", 1, subtitle: "Elementary")

  #colbreak()

  = Reviewing

  === #text(fill: luma(55%))[Conferences]

  - KONVENS 2018–2024
  - ACL 2019–2023
  - IJCAI 2021–2023
  - COLING 2018–2022
  - ICCC 2022
  - NoDaLiDa 2019–2021
  - EACL 2021
  - EMNLP 2020
  - NAACL 2018–2019

  === #text(fill: luma(55%))[Journals]

  - Computational Linguistics
  - Language Resources and Evaluation (LREV)
  - Natural Language Engineering (NLE)
  - Northern European Journal for Language Technology (NEJLT)
  - Information Processing & Management
  - Data in Brief (DIB)

  === #text(fill: luma(55%))[Workshops]

  - LT4HALA 2020–2022
  - UDW 2020
  - NLP-OSS 2020

  === #text(fill: luma(55%))[Others]

  - Cambridge University Press, Book Review (2025)


  #colbreak()

  /*
  = Skills

  #item-pills((
    "Python",
    "Git",
  ))
  */

][

  = About me

  #pad(top: .5em,
    text(size: 0.8em)[
      I am a researcher and teacher in computational linguistics~(CL) and natural language processing~(NLP), with a background in linguistics.
      My research interests revolve around NLP for lesser-resourced languages, incl. multilingual models, tokenization, and interpretability.
      I am also interested in NLP applications within the digital humanities or computational social sciences.
    ]
  )

  = Employment

  #entry(
    title: [Associate Professor / _Universitetslektor_],
    institution: [Department of Computer and Information Science (IDA),\ Linköping University],
    location: "Linköping, Sweden",
    date: "2023 – present",
    [
      - Member of the #ext-link("https://liu-nlp.ai/")[LiU NLP Group]
      - Researcher and WP lead within "TrustLLM: Democratize Trustworthy and Efficient Large Language Model Technology for Europe" _(from 11/2023)_, funded by the European Union's Horizon Europe programme (#link("https://trustllm.eu/"))
      - Coordinator of Linköping University's node within #ext-link("https://sprakbanken-clarin.lingfil.uu.se/")[Språkbanken CLARIN]
      - Teaching and supervision within computer science and natural language processing (Bachelor, Master, PhD)
    ],
  )

  #entry(
    title: [Assistant Professor / _Universitetslektor_],
    institution: "Jönköping University",
    location: "Jönköping, Sweden",
    date: "2021 – 2023",
    [
      - Member of the Jönköping Artificial Intelligence Lab (JAIL)
      - Teaching in data science, AI, and natural language processing (Bachelor, Master)
    ],
  )

  #entry(
    title: [Postdoctoral Researcher & Marie Skłodowska-Curie Fellow],
    institution: "University of Copenhagen",
    location: "Copenhagen, Denmark",
    date: "2018 – 2021",
    [
      - Research on deep learning for NLP, cross-lingual learning, and multi-task learning
      - Marie Skłodowska-Curie fellow (MSCA-IF) in project on "Morphologically-informed representations for natural language processing" (MorphIRe) _(2019–2021)_
    ],
  )

  #entry(
    title: [Research Assistant & PhD Student],
    institution: "Ruhr-Universität Bochum",
    location: "Bochum, Germany",
    date: "2011 – 2017",
    [
      - Research in projects within #link("https://linguistics.rub.de/comphist/")[computational historical linguistics]
        - "St. Anselmi Fragen an Maria" _("Saint Anselm's questions to the Virgin Mary")_
        - "Reference Corpus Early New High German"
        - "Reference Corpus Middle High German"
      - Research on historical text normalization using supervised machine learning
      - Development of open-source software tools for text normalization and linguistic annotation
    ],
  )

  = Education

  #entry(
    title: "Dr. phil. (PhD) in Computational Linguistics",
    institution: "Ruhr-Universität Bochum",
    location: "Bochum, Germany",
    date: "06/2018",
    [
      - Thesis: "Normalization of historical texts with neural network models"
      - Grade: *summa cum laude* _(highest distinction)_
    ]
  )

  #entry(
    title: "Master of Arts (M.A.) in Linguistics (Focus: Computational Linguistics)",
    institution: "Ruhr-Universität Bochum",
    location: "Bochum, Germany",
    date: "12/2012",
    [
      - Thesis: "Automatic normalization for linguistic annotation of historical language data"
        // - Won an award for best student thesis 2011–2013 by the German Society for Computational Linguistics & Language Technology (GSCL).
      - Grade: *with distinction*
    ]
  )

  #entry(
    title: "Bachelor of Arts (B.A.) in Linguistics and Mathematics",
    institution: "Ruhr-Universität Bochum",
    location: "Bochum, Germany",
    date: "07/2009",
    [
      - Thesis: "Comparing semantic distance measures on WordNet and GermaNet"
    ]
  )

  #colbreak()

  = Service

  #entry(
    title: [Editor-in-Chief],
    institution: [Northern European Association for Language Technology (NEALT)],
    date: "2024 – 2027",
    [
      - Elected position in the executive committee of #ext-link("https://nealt-org.github.io/")[NEALT]
      - Responsible for the #ext-link("https://nealt-org.github.io/proceedings/")[NEALT Proceedings Series] and #ext-link("https://www.nejlt.org/")[NEJLT journal]
    ]
  )

  #entry(
    title: [Site Development Lead],
    institution: [ACL Anthology],
    date: "2019 – present",
    [
      - Development of software infrastructure for the main archive of research papers in computational linguistics & natural language processing (#link("https://aclanthology.org/"))
      - Full re-implementation of the website backend in 2019; work performed "to extremely high standards" (#link("https://www.aclweb.org/adminwiki/index.php?title=2019Q1_Reports:_Anthology_Director"))
    ]
  )

  #entry(
    title: [Area Chair],
    institution: [ACL Rolling Review (ARR)],
    date: "2024 – present",
    []
  )

  #entry(
    title: [Steering Group Member],
    institution: [Nationella Språkbanken],
    date: "2023 – 2024",
    [
      - Representative of Linköping University in the steering group of Nationella Språkbanken, a national infrastructure for research on language data
    ]
  )

  #entry(
    title: [Local Organizer],
    institution: [Conference on Natural Language Processing (KONVENS)],
    date: "2016",
    [
      - Implementation and design of conference handbook & website
    ]
  )

  = Teaching

  #entry-alt(
    title: "Language and Computers (729G49)",
    subtitle: "Course Coordinator & Examiner (only 2024), Teacher",
    institution: "Linköping University",
    date: "2024 – present",
    [
      - #link("https://liu-nlp.ai/729g49/")
      - Lecture series on Swedish linguistics _(taught in Swedish from 2025)_
    ]
  )

  #entry-alt(
    title: "Language and Technology (729G17, 729G86, 729G93, TDP030)",
    subtitle: "Course Coordinator, Examiner, Teacher",
    institution: "Linköping University",
    date: "2024 – present",
    [
      - #link("https://liu-nlp.ai/lang-tech/")
    ]
  )

  #entry-alt(
    title: "Text Mining (732A81, TDDE16)",
    subtitle: "Course Coordinator, Examiner, Teacher",
    institution: "Linköping University",
    date: "2023 – present",
    [
      - #link("https://liu-nlp.ai/text-mining/")
    ]
  )

  #entry-alt(
    title: [Deep Learning (732A82)],
    subtitle: "Guest Lecturer",
    institution: "Linköping University",
    date: "2023 – present",
    [
      Topic: "Recurrent Neural Networks"
    ]
  )

  #entry-alt(
    title: "Natural Language Processing and Text Mining (TSTS22)",
    subtitle: "Course Coordinator, Examiner, Teacher",
    institution: "Jönköping University",
    date: "2022",
    [
      New course; included full preparation of teaching materials from scratch
    ]
  )

  #entry-alt(
    title: "Data Science Programming (TDPS22)",
    subtitle: "Course Coordinator, Examiner, Teacher",
    institution: "Jönköping University",
    date: "2022",
    [
      New course; included full preparation of teaching materials from scratch
    ]
  )

  #entry-alt(
    title: "State of the Art in AI Research (TSFS22)",
    subtitle: [Course Coordinator, Examiner, Teacher (2021–2022)\ Guest Lecturer (2023–2025)],
    institution: "Jönköping University",
    date: "2021 – 2025",
    []
  )

  #entry-alt(
    title: [Research Methods for Intelligent Systems (TRIS22)],
    subtitle: "Guest Lecturer",
    institution: "Jönköping University",
    date: "2021",
    [Topics: "Data Visualization" & "Experimental Design"]
  )

  #entry-alt(
    title: [Programming Techniques (TPTG11)],
    subtitle: "Tutor",
    institution: "Jönköping University",
    date: "2021",
    [
      Lab exercises in C programming
    ]
  )

  #entry-alt(
    title: [Natural Language Processing],
    subtitle: "Guest Lecturer",
    institution: "University of Copenhagen",
    date: "2018 – 2019",
    [
      Topics: "Sequence Labelling" & "Machine Translation"
    ]
  )

  #colbreak()

  #entry-alt(
    title: [Aspects of Natural Language Generation],
    subtitle: "Lecturer, Seminar Chair",
    institution: "Ruhr-Universität Bochum",
    date: "2013 & 2015",
    [New course; included full preparation of teaching materials from scratch]
  )

  #entry-alt(
    title: [Non-standard Language Data],
    subtitle: "Lecturer, Seminar Chair",
    institution: "Ruhr-Universität Bochum",
    date: "2014",
    [New course; included full preparation of teaching materials from scratch]
  )

  #entry-alt(
    title: [Tools & Techniques],
    subtitle: "Teacher",
    institution: "Ruhr-Universität Bochum",
    date: "2010 – 2012",
    [Optional one-week tutorial; included full preparation of teaching materials]
  )

  /*
  #entry(
    title: "Language and Computers (729G49)",
    institution: "Linköping University",
    location: "Linköping, Sweden",
    date: "2024 – present",
    [
      - Course Coordinator & Examiner _(only 2024)_
      - Teacher for lecture series on Swedish Linguistics _(2024 – present)_
    ]
  )

  #entry(
    title: "Language and Technology (729G17, 729G86, 729G89, TDP030)",
    institution: "Linköping University",
    location: "Linköping, Sweden",
    date: "2024 – present",
    [
      Course Coordinator, Examiner, Teacher
    ]
  )

  #entry(
    title: "Text Mining (732A81, TDDE16)",
    institution: "Linköping University",
    location: "Linköping, Sweden",
    date: "2023 – present",
    [
      Course Coordinator, Examiner, Teacher
    ]
  )

  #entry(
    title: [_Guest Lecture:_ Recurrent Neural Networks (in "Deep Learning" course)],
    institution: "Linköping University",
    location: "Linköping, Sweden",
    date: "2023 – present",
    []
  )

  #entry(
    title: "Natural Language Processing and Text Mining (TSTS22)",
    institution: "Jönköping University",
    location: "Jönköping, Sweden",
    date: "2022",
    [
      Course Coordinator, Examiner, Teacher
      - included full preparation of teaching materials from scratch
    ]
  )

  #entry(
    title: "Data Science Programming (TDPS22)",
    institution: "Jönköping University",
    location: "Jönköping, Sweden",
    date: "2022",
    [
      Course Coordinator, Examiner, Teacher
      - included full preparation of teaching materials from scratch
    ]
  )

  #entry(
    title: "State of the Art in AI Research (TSAS20)",
    institution: "Jönköping University",
    location: "Jönköping, Sweden",
    date: "2021 – 2025",
    [
      - Course Coordinator, Examiner, Teacher _(2021 – 2022)_
      - Guest Lecturer _(2023 – 2025)_
    ]
  )

  #entry(
    title: [_Guest Lectures:_ Data Visualization & Experimental Design],
    institution: "Jönköping University",
    location: "Jönköping, Sweden",
    date: "2021",
    []
  )


  #entry(
    title: [Introduction to C Programming _(Programmeringsteknik)_],
    institution: "Jönköping University",
    location: "Jönköping, Sweden",
    date: "2021",
    [
      Tutor for exercises in programming with C
    ]
  )
  */

  = Training

  #entry-alt(
    title: [Introduction to University Pedagogy],
    subtitle: "80 hours, 3 CP",
    institution: "University of Copenhagen",
    date: "2021",
    []
  )

  #entry-alt(
    title: [Higher Education Pedagogy for New Teachers],
    subtitle: "120 hours, 4.5 CP",
    institution: "Linköping University",
    date: "2024",
    []
  )

  #entry-alt(
    title: [Higher Education Pedagogy for PhD Supervisors],
    subtitle: "110 hours, 4 CP",
    institution: "Linköping University",
    date: "2024",
    []
  )

  #entry-alt(
    title: [Higher Education Pedagogy for Teachers Responsible for Courses],
    subtitle: "120 hours, 4.5 CP",
    institution: "Linköping University",
    date: "2025",
    []
  )

  #entry-alt(
    title: [Peer Visit],
    subtitle: "20 hours, 0.75 CP",
    institution: "Linköping University",
    date: "2025",
    []
  )

  #entry-alt(
    title: [Starting to Supervise Independent (Degree) Projects],
    subtitle: "20 hours, 0.75 CP",
    institution: "Linköping University",
    date: "2026",
    []
  )

  #entry-alt(
    title: [Examiner in Higher Education – Roles and Responsibilities],
    subtitle: "20 hours, 0.75 CP",
    institution: "Linköping University",
    date: "2026",
    [_(taken in Swedish)_]
  )

  = PhD supervision

  #entry-alt(
    title: "Romina Oji",
    subtitle: "Co-supervisor",
    institution: "Linköping University",
    date: "2024 – present",
    []
  )

  #entry-alt(
    title: "Noah-Manuel Michael",
    subtitle: "Co-supervisor",
    institution: "Linköping University",
    date: "2024 – 2025",
    []
  )

  #entry-alt(
    title: "Kevin Glocker",
    subtitle: "Co-supervisor",
    institution: "Linköping University",
    date: "2024 – 2025",
    []
  )

  #entry-alt(
    title: "Oskar Holmström",
    subtitle: "Co-supervisor",
    institution: "Linköping University",
    date: "2023 – 2026",
    []
  )


  = Grants & Awards

  #entry(
    title: "Distinguished Teacher Award",
    institution: "Department of Computer and Information Science, Linköping University",
    date: "2025",
    [Category "Students' Top 20" for "Text Mining" course],
    // "With outstanding clarity in lectures, well-structured and educationally purposeful labs, and an interactive approach that adapts to students' needs, Marcel has set a gold standard for teaching by fostering deep understanding, engagement, and enthusiasm for learning."
  )
  #entry(
    title: "Best Paper Award",
    institution: "Conference of the European Chapter of the ACL (EACL)",
    //location: "Bochum, Germany",
    date: "2021",
    [For paper: "#link("https://www.aclweb.org/anthology/2021.eacl-main.162")[Error Analysis and the Role of Morphology]", with Anders Søgaard]
  )
  #entry(
    title: "Marie Skłodowska-Curie Individual Fellowship (MSCA-IF)",
    institution: "European Commission",
    //location: "Copenhagen, Denmark",
    date: "2019",
    [
      - Title of project: #link("https://cordis.europa.eu/project/id/845995/factsheet")["Morphologically-informed representations for natural language processing — MorphIRe"]
      - Grant No. 845995, grant amount: € 207,312
      - Proposal evaluated with score of 100% (top 0.55% in "Information Science and Engineering" panel, top 0.09% overall)
    ]
  )
  #entry(
    title: "Nvidia GPU Grant (GeForce Titan Xp)",
    institution: "Nvidia Corporation",
    //location: "Bochum, Germany",
    date: "2018",
    []
  )
  #entry(
    title: "Travel Grant",
    institution: "German Academic Exchange Service (DAAD)",
    //location: "Bochum, Germany",
    date: "2017",
    [For presenting at the ACL conference in Vancouver, Canada]
  )
  #entry(
    title: "Best Student Thesis Award",
    institution: "German Society for Computational Linguistics & Language Technology (GSCL)",
    //location: "Bochum, Germany",
    date: "2013",
    [For Master's thesis on "Automatic normalization for linguistic annotation of historical language data"]
  )

  = Invited talks

  #entry(
    title: talk-title[Embracing uncertainty: What language technology can provide for digital humanities],
    institution: "Linköping University",
    location: "Linköping, Sweden",
    date: "2026",
    [Invited seminar talk within the (Un)Certainties Project]
  )

  #entry(
    title: talk-title[Increasing language diversity in NLP: Insights from CreoleVal],
    institution: "22nd Workshop on Treebanks and Linguistic Theories (TLT 2024)",
    location: "Hamburg, Germany",
    date: "2024",
    [Invited speaker at the workshop, all expenses paid],
  )

  #entry(
    title: talk-title[Large language models for everyone],
    institution: "Jönköping University",
    location: "Jönköping, Sweden",
    date: "2023",
    [Open guest lecture at the Department of Computing]
  )

  #entry(
    title: talk-title[NLP beyond English: Do we need to think more about linguistics?],
    institution: "University of Gothenburg",
    location: "Gothenburg, Sweden",
    date: "2023",
    [Invited talk at the Centre for Linguistic Theory and Studies and Probability (CLASP)]
  )

  #entry(
    title: talk-title[From historical texts to creoles: NLP for challenging domains],
    institution: "Linköping University",
    location: "Linköping, Sweden",
    date: "2022",
    [Invited talk at the Department of Computer and Information Science]
  )

  #entry(
    title: talk-title[State of the art in natural language processing],
    institution: "AI@JKPG",
    location: "Jönköping, Sweden",
    date: "2022",
    [Invited talk at a company networking event],
  )

  #entry(
    title: talk-title[Historical text normalization with neural networks],
    institution: "Inria",
    location: "Paris, France",
    date: "2018",
    [Invited talk at Almanach Seminar Series, all expenses paid]
  )

  = Committees

  #entry(
    title: [External Examiner, PhD],
    institution: "Ruhr-Universität Bochum",
    location: "Bochum, Germany",
    date: "2026",
    []
  )

  #entry(
    title: [External Examiner, PhD],
    institution: "University of Galway",
    location: "Galway, Ireland",
    date: "2026",
    []
  )

  #entry(
    title: [Assessment Committee for Associate Professorship],
    institution: "University of Copenhagen",
    location: "Copenhagen, Denmark",
    date: "2024",
    []
  )

  #entry(
    title: [Interim Evaluation Committee for Horizon 2020 Project],
    institution: "European Commission",
    location: "Remote",
    date: "2022",
    [],
  )

  = Outreach

  #entry(
    title: ["Equity in natural language processing"],
    institution: "research*eu magazine, European Commission",
    date: "2020",
    [Article about my MSCA-IF-funded “MorphIRe” project\ (https://cordis.europa.eu/article/id/421665-equity-in-natural-language-processing)]
  )
]


#pagebreak()


#let render-publications(
  pubs,
  keys,
) = (
  context {
    for key in keys {
      let data = pubs.at(key)
      data.__id = key

      list([
        #set text(size: ENTRY_CONTENT_FONT_SIZE_SCALE * 1em)
        #format-publication-entry(data)
      ])
    }
  }
)

#cv-thin-side[
  #thin-label("Bibliography")
  #v(1em)
  #thin-metrics((
    (label: "i10-index", value: "19"),
    (label: "h-index", value: "16"),
    (label: "Citations", value: "819"),
  ))
][
  = Conference papers

  #let pub-files = ("../bib/other.yml", "../bib/anthology.yml")
  #let publications = pub-files.map(yaml).sum()

  #render-publications(
    publications,
    (
      "kunz-etal-2026-dataset",
      "tatariya-etal-2026-good",
      "bollmann-sogaard-2021-error",
      "bollmann-elliott-2020-forgetting",
      "flachs-etal-2019-historical",
      "beloucif-etal-2019-naive",
      "bollmann-2019-large",
      "bollmann-etal-2017-learning",
      "bollmann-sogaard-2016-improving",
      "bollmann-etal2011-applying",
    )
  )

  = Journal articles

  #render-publications(
    publications,
    (
      "lent-etal-2024-creoleval",
      "tjongkimsang-etal2017-clin27",
      "petran-etal2016-rem",
      "bollmann-etal2014-applying",
    )
  )

  = Workshop papers

  #render-publications(
    publications,
    (
      "bollmann-etal-2023-two",
      "aralikatte-etal-2021-far",
      "bollmann-etal-2021-moses",
      "bollmann-etal-2019-shot",
      "bollmann-etal-2018-multi",
      "bollmann-etal-2016-evaluating",
      "bollmann-etal-2014-cora",
      "bollmann-2013-pos",
      "bollmann-etal2012-manual",
      "bollmann2012-semi",
      "bollmann-etal-2011-rule",
      "bollmann-2011-adapting",
    )
  )

  = Preprints and reports (not peer-reviewed)

  #render-publications(
    publications,
    (
      "holmström2026systematiccomparisonmultilingualinterpretability",
      "oji2026probingfactualknowledgetransfer",
      "glocker2025growmergescalingstrategies",
      "bollmann2018-normalization",
      "krasselt-etal2015-guidelines",
      "bollmann2013-automatic",
    )
  )

  = As editor

  #render-publications(
    publications,
    (
      "nejlt-2025-1",
      "nejlt-2024-1",
    )
  )

]
