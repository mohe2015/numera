// In the builtin ref rule, here() in numbering is the location of the element. But the style context is wrong. Also we can't custom style the numbering in refs as we can't detect whether we are in a ref.

#set math.equation(numbering: (..nums) => {
  let here = here()
  let test = query(<test>).first(default: none)
  if test == none {
    return "too-early-layout-iteration"
  }
  assert(here == test.location())
  heading.numbering
})

#set heading(numbering: "1")

= Test

$ 1 + 1 $ <test>

#set heading(numbering: "a")

= Abc

@test
