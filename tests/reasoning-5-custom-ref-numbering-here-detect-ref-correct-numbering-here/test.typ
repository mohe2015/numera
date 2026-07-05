// The numbering is able to detect whether it was called from an equation or ref context to render the numbering differently. here() works again. Plain numberings don't trim for refs.

#set math.equation(numbering: (..nums, ref: false) => {
  let location = here()
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
  let equation-numbering = query(selector(math.equation).before(location)).last(default: (numbering: none)).numbering
  if type(equation-numbering) == function {
    equation-numbering = equation-numbering.with(ref: true)
  }
  let rendered = counter(math.equation).display(equation-numbering, at: location)
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

@test1 <ref11> @test2 <ref12> @test3 <ref13>

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

@test1 <ref21> @test2 <ref22> @test3 <ref23>

#set math.equation(numbering: "(I)")

#set heading(numbering: "1")

= Test

$ 1 + 1 $ <test3>

#set heading(numbering: "a")

= Abc

@test1 <ref31> @test2 <ref32> @test3 <ref33>