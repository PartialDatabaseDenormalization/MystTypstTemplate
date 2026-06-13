#import "content.typ": *
#show: template.with(
  title: "[-doc.title-]",
[# if parts.abstract or parts.summary #]
  abstract: (
[# if parts.abstract #]
    (
      title: "Abstract",
      content: [
[-parts.abstract-]
      ]
    ),
[# endif #]
  ),
[# endif #]
[# if doc.subtitle #]
  subtitle: "[-doc.subtitle-]",
[# endif #]
[# if options.short_citation #]
  short-citation: "[-options.short_citation-]",
[# endif #]
[# if options.heading_numbering #]
  heading-numbering: "[-options.heading_numbering-]",
[# endif #]
[# if doc.date #]
  date: datetime(
    year: [-doc.date.year-],
    month: [-doc.date.month-],
    day: [-doc.date.day-],
  ),
[# endif #]
[# if doc.bibtex #]
  bibliography-file: "[-doc.bibtex-]",
[# endif #]
  authors: (
[# for author in doc.authors #]
    (
      name: "[-author.name-]",
    ),
[# endfor #]
  ),
[# if options.logo #]
  logo: "[-options.logo-]",
[# endif #]
[# if options.cover_page #]
  cover-page: [-options.cover_page-],
[# endif #]
[# if options.thesis_description #]
  thesis-description: [[-options.thesis_description-]],
[# endif #]
[# if options.matrikelnummer #]
  matrikelnummer: "[-options.matrikelnummer-]",
[# endif #]
[# if options.studiengang #]
  studiengang: "[-options.studiengang-]",
[# endif #]
[# if options.betreuer #]
  betreuer: "[-options.betreuer-]",
[# endif #]
[# if options.ausgabedatum #]
  ausgabedatum: "[-options.ausgabedatum-]",
[# endif #]
[# if options.abgabedatum #]
  abgabedatum: "[-options.abgabedatum-]",
[# endif #]
)

[-IMPORTS-]

[-CONTENT-]
