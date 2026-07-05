// In a custom ref rule with display(at: it.element.location()), here() in numbering is the location of the element. But the style context is wrong. Also we can't custom style the numbering in refs as we can't detect whether we are in a ref.

#set math.equation(numbering: (..nums) => {
  let here = here()
  let test = query(<test>).first(default: none)
  if test == none  {
    return "too-early-layout-iteration"
  }
  assert(here == test.location())
  heading.numbering
})

#show ref: it => {
  if it.element == none or it.element.func() != math.equation { return it }
  let here = here()
  let location = it.element.location()
  assert(here != location)
  // The numbering will be executed with a context in which here() resolves to the provided location, so that numberings which involve further counters resolve correctly.
  let rendered = counter(math.equation).display(at: location)
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