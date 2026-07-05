// The numbering is able to detect whether it was called from an equation or ref context to render the numbering differently. Unfortunately the wrong equation numbering is now used for refs.

#set math.equation(numbering: (..nums, location: none, ref: false) => {
  if location == none { location = here() }
  let test1 = query(<test1>).first(default: none)
  let test2 = query(<test2>).first(default: none)
  if test1 == none or test2 == none {
    return "too-early-layout-iteration"
  }
  assert(location == test1.location() or location == test2.location())
  repr(ref) + "+" + heading.numbering
})

#show ref: it => {
  if it.element == none or it.element.func() != math.equation { return it }
  let here = here()
  let location = it.element.location()
  assert(here != location)
  let nums = counter(math.equation).at(location)
  let rendered = (math.equation.numbering)(..nums, location: location, ref: true)
  let result = if it.element.supplement == [] {
    rendered
  } else {
    [#it.element.supplement~#rendered]
  }
  link(location, result)
}

#set heading(numbering: "1")

= Test

$ 1 + 1 $ <test1>

#set heading(numbering: "a")

= Abc

@test1 <ref11> @test2 <ref12>

#set math.equation(numbering: (..nums, location: none, ref: false) => {
  if location == none { location = here() }
  let test1 = query(<test1>).first(default: none)
  let test2 = query(<test2>).first(default: none)
  if test1 == none or test2 == none {
    return "too-early-layout-iteration"
  }
  assert(location == test1.location() or location == test2.location())
  repr(ref) + "-" + heading.numbering
})

#set heading(numbering: "1")

= Test

$ 1 + 1 $ <test2>

#set heading(numbering: "a")

= Abc

@test1 <ref21> @test2 <ref22>
