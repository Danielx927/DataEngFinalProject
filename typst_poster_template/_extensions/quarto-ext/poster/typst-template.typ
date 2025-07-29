#show link: set text(fill: rgb("#DC3C22"))


#set table(
  columns: 3, 
  align: left, 
  stroke: 1pt + rgb("#5A4632"),
  inset: 5pt,
  row-gutter: 0pt,
  column-gutter: 0pt,
  fill: (x, y) => if y == 0 { rgb("#E3B68C") } else { rgb("#F8EFC9") },
)


#let poster(
  // The poster's size.
  size: "'36x24' or '48x36''",

  // The poster's title.
  title: "Paper Title",

  // A string of author names.
  authors: "Author Names (separated by commas)",

  // Department name.
  departments: "Department",

  // University logo.
  univ_logo: "Logo Path",

  // Footer text.
  // For instance, Name of Conference, Date, Location.
  // or Course Name, Date, Instructor.
  footer_text: "Footer Text",

  // Any URL, like a link to the conference website.
  footer_url: "Footer URL",

  // Email IDs of the authors.
  footer_email_ids: "Team XX",

  // Color of the footer.
  footer_color: "Hex Color Code",

  // DEFAULTS
  // ========
  // For 3-column posters, these are generally good defaults.
  // Tested on 36in x 24in, 48in x 36in, and 36in x 48in posters.
  // For 2-column posters, you may need to tweak these values.
  // See ./examples/example_2_column_18_24.typ for an example.

  // Any keywords or index terms that you want to highlight at the beginning.
  keywords: (),

  // Number of columns in the poster.
  num_columns: "3",

  // University logo's scale (in %).
  univ_logo_scale: "90",

  // University logo's column size (in in).
  univ_logo_column_size: "10",

  // Title and authors' column size (in in).
  title_column_size: "14",

  // Poster title's font size (in pt).
  title_font_size: "70",

  // Authors' font size (in pt).
  authors_font_size: "30",

  // Footer's URL and date font size (in pt).
  footer_url_font_size: "30",

  // Footer's text font size (in pt).
  footer_text_font_size: "25",

  // The poster's content.
  body
) = {
  // Set the body font.
  set text(font: "STIX Two Text", size: 18pt, fill: rgb("#5A4632"))
  let sizes = size.split("x")
  let width = int(sizes.at(0)) * 1in
  let height = int(sizes.at(1)) * 1in
  univ_logo_scale = int(univ_logo_scale) * 1%
  title_font_size = int(title_font_size) * 1pt
  authors_font_size = int(authors_font_size) * 1pt
  num_columns = int(num_columns)
  univ_logo_column_size = int(univ_logo_column_size) * 1in
  title_column_size = int(title_column_size) * 1in
  footer_url_font_size = int(footer_url_font_size) * 1pt
  footer_text_font_size = int(footer_text_font_size) * 1pt


  // Configure the page.
  // This poster defaults to 36in x 24in.
  set page(
    width: width,
    height: height,
    margin: 
      (top: 1in, left: 1in, right: 1in, bottom: 2in),
    background: box(
      fill: rgb("#FBF5DE"),
      width: 100%,
      height: 100%),
    footer: [
      #set align(center)
      #set text(32pt, fill: rgb("#FBF5DE"))
      #block(
        fill: rgb("DC3C22"),
        width: 100%,
        inset: 10pt,
        radius: 10pt,
        [
          #h(1fr) 
          #text(size: footer_text_font_size, smallcaps(footer_text)) 
          #h(1fr) 
          #text(font: "Courier", size: footer_url_font_size, footer_email_ids)
        ]
      )
    ]
  )

  // Configure equation numbering and spacing.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 15pt)
  set list(indent: 10pt, body-indent: 20pt)

  // Configure headings.
  set heading(numbering: "I.A.1.")
  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    let deepest = if levels != () {
      levels.last()
    } else {
      1
    }

    set text(24pt, weight: 400)
    if it.level == 1 [
      // First-level headings are centered smallcaps.
      #set align(center)
      #set text(35pt, weight: 700, font: "Times New Roman", fill: rgb("#DC3C22"))
      #show: smallcaps
      #v(50pt, weak: true)
      #if it.numbering != none {
        numbering("1.", deepest)
        h(7pt, weak: true)
      }
      #it.body
      #v(35.75pt, weak: true)
      #line(length: 100%)
    ] else if it.level == 2 [
      // Second-level headings are run-ins.
      #set text(30pt, font: "Times New Roman", style: "italic", fill: rgb("#DC3C22"))
      #v(32pt, weak: true)
      #if it.numbering != none {
        numbering("a )", deepest)
        h(7pt, weak: true)
      }
      #it.body
      #v(20pt, weak: true)
    ] else [
      // Third level headings are run-ins too, but different.
      #if it.level == 3 {
        numbering("i.)", deepest)
        [ ]
      }
      _#(it.body):_
    ]
  })

  // Arranging the logo, title, authors, and department in the header.
  grid(
    columns: (univ_logo_column_size, title_column_size),
    column-gutter: 15pt,
    align(
      center,
      image(univ_logo, width: univ_logo_scale)
    ),
    align(
      center,
      stack(
        spacing: 6pt,
        text(title_font_size, fill: rgb("#DC3C22"), font: "Times New Roman", title),
        text(authors_font_size, fill: rgb("#E7C29C"), font: "Fira Sans", emph(authors) + departments),
      )
    )
  )

  // Start three column mode and configure paragraph properties.
  show: columns.with(num_columns, gutter: 64pt)
  set par(justify: true, first-line-indent: 0em)
  show par: set block(spacing: 0.65em)

  // Display the keywords.
  if keywords != () [
      #set text(100pt, weight: 400)
      #show "Keywords": smallcaps
      *Keywords* --- #keywords.join(", ")
  ]

  // Display the poster's contents.
  body
}