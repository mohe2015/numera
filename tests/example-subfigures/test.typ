#import "@preview/numera:0.0.1": (
  my-numbering, numera, outer-figure-counter-value, ref-dependent, subfigure-dependent
)

#show: numera()

// either ref-non ref switch
// and figure subfigure switch (or optionally it just takes a subfigure numbering)
// and then you can combine

// Subfigure numbering: (a) inline, full reference (e.g. 1a) in refs
#show figure: set figure(numbering: subfigure-dependent("1a"))

= Subfigures Example

This example demonstrates side-by-side subfigures using a grid layout.

#figure(
  grid(
    columns: 3,
    gutter: 1.5em,
    align: center,
    [
      #figure(
        "Sub-figure A",
        caption: "First sub-figure",
        kind: "subfigure",
      ) <sub-a>
    ],
    [
      #figure(
        "Sub-figure B",
        caption: "Second sub-figure",
        kind: "subfigure",
      ) <sub-b>
    ],
    [
      #figure(
        "Sub-figure C",
        caption: "Third sub-figure",
        kind: "subfigure",
      ) <sub-c>
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
