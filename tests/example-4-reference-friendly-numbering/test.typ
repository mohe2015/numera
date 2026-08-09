#import "@preview/numera:0.0.1": (
  my-numbering,
  normal-figure,
  numera,
)

#set heading(numbering: "1")
#show: numera(level: 1)

#set math.equation(
  supplement: "Eq.",
  numbering: (ref: false, ..nums) => my-numbering("(1)", ref: ref, ..nums),
)

#show normal-figure: set figure(
  supplement: "Fig.",
  numbering: (ref: false, ..nums) => my-numbering("(1)", ref: ref, ..nums),
)

= Chapter

$ E = m c^2 $ <eq1>
#figure("Image", caption: "Figure") <fig1>

See @eq1 and @fig1.
