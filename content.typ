
#let template(
  title: "Paper Title",
  subtitle: none,
  authors: (),
  abstract: none,
  logo: none,
  heading-numbering: "1.1.1",
  margin: (),
  paper-size: "a4",
  theme: blue.darken(30%),
  date: datetime.today(),
  font-face: "Libertinus Serif",
  bibliography-file: none,
  bibliography-style: "ieee",
  cover-page: false,
  thesis-description: none,
  body
) = {
  let spacer = text(fill: gray)[#h(8pt) | #h(8pt)]

  let dates;
  if (type(date) == datetime) {
    dates = ((title: "Published", date: date),)
  } else if (type(date) == dictionary) {
    dates = (date,)
  } else {
    dates = date
  }
  date = dates.at(0).date

  // Create a short-citation, e.g. Cockett et al., 2023
  let year = if (date != none) { ", " + date.display("[year]") }
  let short-citation = none 
  if (authors.len() == 1) {
    short-citation = authors.at(0).name.split(" ").last() + year
  } else if (shortauthors.len() == 2) {
    short-citation = authors.at(0).name.split(" ").last() + " & " + authors.at(1).name.split(" ").last() + year
  } else if (authors.len() > 2) {
    short-citation = authors.at(0).name.split(" ").last() + " " + emph("et al.") + year
  } else {
    short-citation = none
  }

  // Set document metadata.
  set document(title: title, author: authors.map(author => author.name))

  show link: it => context {
    if type(it.dest) == label {
      let elems = query(it.dest)
      if elems.len() > 0 and elems.first().func() == heading {
        let h = elems.first()
        let levels = counter(heading).at(it.dest)
        let n = calc.min(h.level, levels.len())
        let relevant = levels.slice(0, n)
        let prefix = if h.level == 1 { [Chapter] } else { [Section] }
        link(h.location())[#text(fill: black)[#prefix #numbering(heading-numbering, ..relevant)]]
      } else if elems.len() > 0 and elems.first().func() == math.equation {
        let eq = elems.first()
        let num = counter(math.equation).at(it.dest).first()
        link(eq.location())[#text(fill: black)[(#num)]]
      } else if elems.len() > 0 and elems.first().func() == metadata {
        let meta = elems.first().value
        let num = counter(meta.kind).at(it.dest).first()
        link(elems.first().location())[#text(fill: black)[#meta.supplement~#num]]
      } else {
        text(fill: black)[#it]
      }
    } else {
      text(fill: black)[#it]
    }
  }
  show ref: it => [#text(fill: black)[#it]]

  set page(
    paper-size,
    margin: (left: 3cm, right: 2cm),
    header: context {
      let loc = here()
      if(loc.page() == 1) {
        let headers = (
          if (open-access) {smallcaps[Open Access]},
          if (doi != none) { link("https://doi.org/" + doi, "https://doi.org/" + doi)}
        )
        return align(left, text(size: 8pt, fill: gray, headers.filter(header => header != none).join(spacer)))
      } else {
        return align(right, text(size: 8pt, fill: gray.darken(50%),
          short-citation
        ))
      }
    },
    footer: block(
      width: 100%,
      stroke: (top: 1pt + gray),
      inset: (top: 8pt, right: 2pt),
      context [
        #grid(columns: (75%, 25%),
          align(left, text(size: 9pt, fill: gray.darken(50%),
              (
                if(date != none) {date.display("[month repr:long] [day], [year]")}
              )
          )),
          align(right)[
            #text(
              size: 9pt, fill: gray.darken(50%)
            )[
              #counter(page).display() of #counter(page).final().first()
            ]
          ]
        )
      ]
    )
  )

  // Cover page
  if cover-page {
    page(
      paper-size,
      margin: (x: 3.5cm, y: 3cm),
      header: none,
      footer: none,
      {
        set text(size: 11pt)
        align(center)[
          #if logo != none {
            box(width: 10cm, {
              if type(logo) == content { logo }
              else { image(logo, width: 100%) }
            })
            v(4cm)
          }

          #text(20pt, weight: "bold", title)
          #if subtitle != none {
            v(0.6cm)
            text(15pt, fill: gray.darken(20%), subtitle)
          }

          #v(1fr)

          #if thesis-description != none {
            text(14pt , thesis-description)
            
          }

        ]

        v(2cm)
        table(
          columns: (auto, auto),
          stroke: none,
          row-gutter: 0.3em,
          [Vorgelegt von:],  [#h(1em) #authors.map(a => a.name).join(", ")],
          [Matrikelnummer:], [#h(1em) 2160126],
          [Studiengang:],    [#h(1em) Data Science],
          [Betreuer:],       [#h(1em) Prof. Dr. Fabian Panse],
          [Ausgabedatum:],   [#h(1em) 11.02.2026],
          [Abgabedatum:],    [#h(1em) 11.05.2026],
        )
      }
    )
  }

  // Set the body font.
  if (font-face != none) {
    set text(font: font-face, size: 11pt)
  } else {
    set text(size: 11pt)
  }
  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 1em)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: heading-numbering)
  show heading: it => context {
    let loc = here()
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    set text(10pt, weight: 400)
    if it.level == 1 {
      block(sticky: true, {
        set text(14pt, weight: 700)
        show: smallcaps
        v(20pt, weak: true)
        if it.numbering != none {
          numbering(heading-numbering, ..levels)
          [.]
          h(7pt, weak: true)
        }
        it.body
        v(13.75pt, weak: true)
      })
    } else if it.level == 2 {
      block(sticky: true, {
        set text(12pt, weight: 700)
        v(15pt, weak: true)
        if it.numbering != none {
          numbering(heading-numbering, ..levels)
          [.]
          h(7pt, weak: true)
        }
        it.body
        v(10pt, weak: true)
      })
    } else {
      block(sticky: true, {
        set text(11pt, weight: 700)
        v(15pt, weak: true)
        if it.numbering != none {
          numbering(heading-numbering, ..levels)
          [.]
          h(7pt, weak: true)
        }
        it.body
        v(10pt, weak: true)
      })
    }
  }



  let abstracts
  if (type(abstract) == content or type(abstract) == str) {
    abstracts = ((title: "Abstract", content: abstract),)
  } else {
    abstracts = abstract
  }

if (abstracts != none and abstracts.len() > 0) {
    box(inset: (top: 16pt, bottom: 16pt), width: 100%, stroke: (top: 1pt + gray, bottom: 1pt + gray), {
      abstracts.map(abs => {
        set par(justify: true)
        text(fill: black, weight: "semibold", size: 11pt, abs.title)
        parbreak()
        abs.content
      }).join(parbreak())

    })
    pagebreak()
  }

  v(10pt)

  show par: set par(spacing: 1em, justify: true)
  show quote.where(block: true): set block(above: 1em, below: 1em)
  show table: it => block(breakable: false, it)
  show figure: it => block(breakable: false, it)
  
  outline()
  pagebreak()
    // Display the paper's contents.
  body

  if (bibliography-file != none) {
    pagebreak()
    show bibliography: set text(8pt)
    bibliography(bibliography-file, title: text(10pt, "References"), style: bibliography-style)
  }
}
