#import "@preview/numera:0.0.1": (
  numera,
  outer-figure-counter-value,
  my-numbering,
)

#show: numera()

// Subfigure numbering: (a) inline, full reference (e.g. 1a) in refs
#show figure.where(kind: "subfigure"): set figure(numbering: (
  ref: false,
  ..nums,
) => {
  if ref {
    // In references: outer figure number + subfigure letter (e.g. "1a")
    let outer-count = outer-figure-counter-value()
    my-numbering("1a", ..outer-count, ..nums)
  } else {
    // Inline display: just "(a)", "(b)", "(c)"
    my-numbering("(a)", ..nums)
  }
})

= Subfigures Example

This example demonstrates side-by-side subfigures using a grid layout.

#figure(
  grid(
    columns: 3,
    gutter: 1.5em,
    align: center,
    [
      #figure("Sub-figure A", caption: "First sub-figure", kind: "subfigure") <sub-a>
    ],
    [
      #figure("Sub-figure B", caption: "Second sub-figure", kind: "subfigure") <sub-b>
    ],
    [
      #figure("Sub-figure C", caption: "Third sub-figure", kind: "subfigure") <sub-c>
    ],
  ),
  caption: "Three sub-figures arranged in a grid",
) <fig-grid>

@sub-a, @sub-b, @sub-c and the parent @fig-grid. 

#figure(
  grid(
    columns: 3,
    gutter: 1.5em,
    align: center,
    [
      #figure("Sub-figure A", caption: "First sub-figure", kind: "subfigure")
    ],
    [
      #figure("Sub-figure B", caption: "Second sub-figure", kind: "subfigure")
    ],
    [
      #figure("Sub-figure C", caption: "Third sub-figure", kind: "subfigure")
    ],
  ),
  caption: "Three sub-figures arranged in a grid",
) <fig-grid2>

Manual references like @fig-grid2 (a), @fig-grid2 (b), @fig-grid2 (c) are also possible.
