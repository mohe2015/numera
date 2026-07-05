// In a custom ref rule, here() in numbering is the location of the element or the ref

#set math.equation(numbering: (..nums) => {
  let here = here()
  let test = query(<test>).first(default: none)
  let ref = query(<ref>).first(default: none)
  if test == none or ref == none {
    return "too-early-layout-iteration"
  }
  assert(here == test.location() or here == ref.location())
  "OK"
})

#show ref: it => {
  if it.element == none or it.element.func() != math.equation { return it }
  let here = here()
  let location = it.element.location()
  assert(here != location)
  let nums = counter(math.equation).at(location)
  let rendered = numbering(math.equation.numbering, ..nums)
  let result = if it.element.supplement == [] {
    rendered
  } else {
    [#it.element.supplement~#rendered]
  }
  link(location, result)
}

#set heading(numbering: "1")

= Test

$ 1 + 1 $ <test>

#set heading(numbering: "a")

= Abc

@test <ref>