#import "../../lib.typ": get-numbering, display, my-numbering, rules

#show: rules

#set math.equation(numbering: (ref: false, ..nums) => {
  let heading = display(heading, ref: ref)
  if heading != none {
    heading += "."
  }
  heading + my-numbering("(1)", ref: ref, ..nums)
})

#set figure(numbering: (ref: false, ..nums) => {
  let heading = display(heading, ref: ref)
  if heading != none {
    heading += "."
  }
  heading + my-numbering("(1)", ref: ref, ..nums)
})

#show heading: it => {
  if it.level <= 1 {
    counter(math.equation).update(0)
  }
  it
}

= Test 1

$ 1 + 1 $ <eq1-1>
#figure("F1.1", caption: "F1.1") <fig1-1>
== Subtitle
$ 1 + 1 $ <eq1-2>
#figure("F1.2", caption: "F1.2") <fig1-2>

See @eq1-1, @eq1-2, @eq2-1, @eq2-2, @eq3-1, @eq3-2, @eq4-1, @eq4-2

See @fig1-1, @fig1-2, @fig2-1, @fig2-2, @fig3-1, @fig3-2, @fig4-1, @fig4-2

#set heading(numbering: "[A.A]")

= Appendix

$ 1 + 1 $ <eq2-1>
#figure("F2.1", caption: "F2.1") <fig2-1>
$ 1 + 1 $ <eq2-2>
#figure("F2.2", caption: "F2.2") <fig2-2>

See @eq1-1, @eq1-2, @eq2-1, @eq2-2, @eq3-1, @eq3-2, @eq4-1, @eq4-2

See @fig1-1, @fig1-2, @fig2-1, @fig2-2, @fig3-1, @fig3-2, @fig4-1, @fig4-2

#set math.equation(numbering: (ref: false, ..nums) => {
  let heading = display(heading, ref: ref)
  if heading != none {
    heading += "-"
  }
  heading + my-numbering("(1)", ref: ref, ..nums)
})

#set math.equation(supplement: "Eq")

= Test 1

$ 1 + 1 $ <eq3-1>
#figure("F3.1", caption: "F3.1") <fig3-1>
$ 1 + 1 $ <eq3-2>
#figure("F3.2", caption: "F3.2") <fig3-2>

See @eq1-1, @eq1-2, @eq2-1, @eq2-2, @eq3-1, @eq3-2, @eq4-1, @eq4-2

See @fig1-1, @fig1-2, @fig2-1, @fig2-2, @fig3-1, @fig3-2, @fig4-1, @fig4-2

#set heading(numbering: "[I.I]")

= Appendix

$ 1 + 1 $ <eq4-1>
#figure("F4.1", caption: "F4.1") <fig4-1>
== Subtitle
$ 1 + 1 $ <eq4-2>
#figure("F4.2", caption: "F4.2") <fig4-2>

See @eq1-1, @eq1-2, @eq2-1, @eq2-2, @eq3-1, @eq3-2, @eq4-1, @eq4-2

See @fig1-1, @fig1-2, @fig2-1, @fig2-2, @fig3-1, @fig3-2, @fig4-1, @fig4-2
