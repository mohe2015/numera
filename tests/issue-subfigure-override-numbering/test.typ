// only this way uses the correct numbering but we need to get the outer figure
// show set rules with it are not replacing themselves correctly.

#show figure.where(kind: "subfigure"): set figure(numbering: (..nums) => {
  "X"
})

#figure(figure(
  "Subfigure",
  kind: "subfigure",
  supplement: "Subfigure",
  caption: "Subfigure",
))

#show figure.where(kind: "subfigure"): set figure(numbering: (..nums) => {
  "Y"
})

#figure(figure(
  "Subfigure",
  kind: "subfigure",
  supplement: "Subfigure",
  caption: "Subfigure",
))

#show figure.where(kind: "subfigure"): set figure(numbering: (..nums) => {
  "Z"
})

#figure(figure(
  "Subfigure",
  kind: "subfigure",
  supplement: "Subfigure",
  caption: "Subfigure",
))
