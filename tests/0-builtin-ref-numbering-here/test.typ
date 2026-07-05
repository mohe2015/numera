// In the builtin ref rule, here() in numbering is the location of the element

#set math.equation(numbering: (..nums) => {
  let here = here()
  let test = query(<test>).first(default: none)
  if test == none {
    return "too-early-layout-iteration"
  }
  assert(here == test.location())
  "OK"
})

#set heading(numbering: "1")

= Test

$ 1 + 1 $ <test>

#set heading(numbering: "a")

= Abc

@test