#import "@preview/numera:0.0.1": numera

#set heading(numbering: "1.1")
#set math.equation(supplement: "Eq.", numbering: "(1)")
#set figure(supplement: "Fig.", numbering: "1")

#show: numera(level: 1)

= Chapter 1

$ 1 + 1 $ <eq1>
#figure("Image", caption: "First") <fig1>

See @eq1 and @fig1.

= Chapter 2

$ 2 + 2 $ <eq2>
#figure("Image", caption: "Second") <fig2>

See @eq2 and @fig2.
