// This theme is based on "Clean" theme, which contains ideas from the former "bristol" theme, contributed by
// https://github.com/MarkBlyth

#import "@preview/polylux:0.3.1": *

#let clean-footer = state("clean-footer", [])
#let clean-short-title = state("clean-short-title", none)
#let clean-color = state("clean-color", blue)
#let clean-title-color = state("clean-title-color", rgb(192, 0, 0))
#let clean-logo = state("clean-logo", none)


#let clean-theme(
  aspect-ratio: "16-9",
  footer: [],
  short-title: none,
  logo: none,
  color: blue,
  title-color: rgb(192, 0, 0),
  body
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    margin: 0em,
    header: none,
    footer: none,
  )
  set text(size: 25pt)
  show footnote.entry: set text(size: .6em)

  clean-footer.update(footer)
  clean-color.update(color)
  clean-title-color.update(title-color)
  clean-short-title.update(short-title)
  clean-logo.update(logo)

  body
}


#let title-slide(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  watermark: none,
  secondlogo: none,
) = {
  let content = locate( loc => {
    let color = clean-color.at(loc)
    let title-color = clean-title-color.at(loc)
    let logo = clean-logo.at(loc)
    let authors = if type(authors) in ("string", "content") {
      ( authors, )
    } else {
      authors
    }

    if watermark != none {
      set image(width: 100%)
      place(watermark)
    }

    v(5%)
    grid(columns: (5%, 1fr, 1fr, 5%),
      [],
      if secondlogo != none {
        set align(bottom + left)
        set image(height: 3em)
        secondlogo
      } else { [] },
      if logo != none {
        set align(bottom + right)
        set image(height: 3em)
        logo
      } else { [] },
      []
    )

    v(-10%)
    align(center + horizon)[
      #block(
        inset: 1em,
        breakable: false,
        [
          #set text(fill: title-color)
          #text(1.8em)[*#title*] \
          #{
            if subtitle != none {
              parbreak()
              text(.9em)[#subtitle]
            }
          }
        ]
      )
      #set text(size: .8em)
      #grid(
        columns: (1fr,) * calc.min(authors.len(), 3),
        column-gutter: 1em,
        row-gutter: 1em,
        ..authors
      )
      // #v(1em)
      #date
    ]
  })
  logic.polylux-slide(content)
}

#let slide(title: none, body) = {
  let header = align(top, locate( loc => {
    let color = clean-color.at(loc)
    let title-color = clean-title-color.at(loc)
    let logo = clean-logo.at(loc)
    let short-title = clean-short-title.at(loc)

    show: block.with(stroke: (bottom: 1mm + color), width: 100%, inset: (y: .3em))
    

    grid(
      columns: (1fr, 3fr, 1fr),
      {
        set text(size: .5em)
        if short-title != none {
          align(horizon + left, grid(
            columns: 1, rows: 1em, gutter: .5em,
            short-title,
            utils.current-section
          ))
        } else {
          align(horizon + left, utils.current-section)
        }
      },
      
      // omit `set text(size: .5em)` for title
      if title != none {
        set text(fill: title-color)
        align(horizon + center, heading(level: 1, title))
      } else { [] },

      if logo != none {
        set text(size: .5em)
        set align(right)
        set image(height: 4em)
        logo
      } else { [] },
    )
  }))

  let footer = locate( loc => {
    block(
      width: 100%, inset: ( y: .3em ),
      text(.5em, {
        clean-footer.display()
        h(1fr)
        logic.logical-slide.display()
      })
    )
  })

  set page(
    margin: ( top: 4em, bottom: 2em, x: 1em ),
    header: header,
    footer: footer,
    footer-descent: 1em,
    header-ascent: 1.5em,
  )

  let body = pad(x: .5em, y: .5em, body)
  
  logic.polylux-slide(body)
}

#let focus-slide(background: teal, foreground: white, body) = {
  set page(fill: background, margin: 2em)
  set text(fill: foreground, size: 1.5em)
  let content = { v(.1fr); body; v(.1fr) }
  // logic.polylux-slide(align(horizon, body))
  logic.polylux-slide(content)
}

#let new-section-slide(name) = {
  set page(margin: 2em)
  let content = locate( loc => {
    let color = clean-color.at(loc)
    set align(center + horizon)
    show: block.with(stroke: ( bottom: 1mm + color ), inset: 1em,)
    set text(size: 1.5em)
    strong(name)
    utils.register-section(name)
  })
  logic.polylux-slide(content)
}