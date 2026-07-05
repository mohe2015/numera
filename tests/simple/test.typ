#import "../../lib.typ": get-numbering, display, my-numbering, rules

#show: rules

#set math.equation(numbering: (ref: false, ..nums) => {
  let heading = display(heading, ref: ref)
  if heading != none {
    heading += "."
  }
  heading + my-numbering("(1)", ref: ref, ..nums)
})

= Test 1

$ 1 + 1 $ <eq1>

See @eq1, @eq2

#set heading(numbering: "A")

= Appendix

$ 1 + 1 $ <eq2>

See @eq1, @eq2
