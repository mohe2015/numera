#import "../../lib.typ": get-numbering, display

#set math.equation(numbering: (..nums, ref: false) => {
  let heading = display(heading)
  if heading != none {
    heading += "."
  }
  heading + numbering("(1)", ..nums)
})

= Test 1

$ 1 + 1 $ <eq1>

See <eq1>, <eq2>

#set heading(numbering: "A")

= Appendix

$ 1 + 1 $ <eq2>

See <eq1>, <eq2>
