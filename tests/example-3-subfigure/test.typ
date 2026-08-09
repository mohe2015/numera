#import "@preview/numera:0.0.1": (
  display-numbering,
  my-numbering,
  normal-figure,
  numera,
  outer-figure-counter-value,
)

#set heading(numbering: "1")
#show: numera(level: 1)

#show normal-figure: set figure(numbering: (ref: false, ..nums) => {
  let chapter = display-numbering(heading, ref: ref)
  if chapter != none {
    chapter += "."
  }
  chapter + my-numbering("1", ref: ref, ..nums)
})

#show figure.where(kind: "subfigure"): set figure(numbering: (ref: false, ..nums) => {
  let outer-count = outer-figure-counter-value()
  let chapter = display-numbering(heading, ref: ref)
  if chapter != none {
    chapter += "."
  }
  chapter + my-numbering("1a", ref: ref, ..outer-count, ..nums)
})

= Chapter

#figure(
  [
    #figure("Sub A", kind: "subfigure", caption: "Sub A") <sub-a>
    #figure("Sub B", kind: "subfigure", caption: "Sub B") <sub-b>
  ],
  caption: "Group",
) <fig1>

See @fig1, @sub-a, and @sub-b.
