#import "@preview/numera:0.0.1": (
  display-numbering,
  my-numbering,
  normal-figure,
  numera,
)

#set heading(numbering: "1")
#show: numera(level: 1)

#set math.equation(numbering: (ref: false, ..nums) => {
  let chapter = display-numbering(heading, ref: ref)
  if chapter != none {
    chapter += "."
  }
  "(" + chapter + my-numbering("1", ref: ref, ..nums) + ")"
})

#show normal-figure: set figure(numbering: (ref: false, ..nums) => {
  let chapter = display-numbering(heading, ref: ref)
  if chapter != none {
    chapter += "."
  }
  chapter + my-numbering("1", ref: ref, ..nums)
})

= Chapter

$ 1 + 1 $ <eq1>
#figure("Image", caption: "Figure") <fig1>

See @eq1 and @fig1.
