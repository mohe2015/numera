#let equation-numbering-func = state("equation-numbering-func", (location: none, ..nums, ref: false) => "Z")

// the ref: true/ref: false stuff doesn't work here
#let set-equation-numbering(the-numbering) = {
  equation-numbering-func.update(old => the-numbering)
}

#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

#let style-equations = it => {
  set math.equation(numbering: (..nums) => {
    equation-numbering-func.get()(location: here(), ..nums, ref: false)
  })

  show ref: it => {
    if it.element == none or it.element.func() != math.equation { return it }
    link(it.element.location(), equation-numbering-func.at(it.element.location())(location: it.element.location(), ..counter(math.equation).at(it.element.location()), ref: true))
  }
  it
}

#show: style-equations

#set-equation-numbering((location: none, ..nums, ref: false) => "(A)")

$ 1 + 1 $ <test-1>

#set heading(numbering: "1.1")

$ 1 + 1 $ <test0>

#set-equation-numbering((location: none, ..nums, ref: false) => {
  let heading-numbering = query(selector(heading).before(location)).last(default: none)
  let result = if heading-numbering == none or heading-numbering.numbering == none {
    numbering("1", ..nums)
  } else {
    numbering(heading-numbering.numbering, ..counter(heading).at(location)) + "." + numbering("1", ..nums)
  }
  if ref {
    result
  } else {
    "(" + result + ")"
  }
})

= Test

$ 1 + 1 $ <test1>

== Subheading

$ 1 + 1 $ <test2>

@test-1, @test0, @test1, @test2, @test3, @test4, @test5, @test6, @test7, @test8

= Test

$ 1 + 1 $ <test3>

== Subheading

$ 1 + 1 $ <test4>

@test-1, @test0, @test1, @test2, @test3, @test4, @test5, @test6, @test7, @test8

#set heading(numbering: "I.1")

#equation-numbering-func.update(old => (location: none, ..nums, ref: false) => {
  let heading-numbering = query(selector(heading).before(location)).last(default: none)
  let result = if heading-numbering == none or heading-numbering.numbering == none {
    numbering("A", ..nums)
  } else {
    counter(selector(heading).before(location)).display(at: location) + "." + numbering("1", ..nums)
  }
  if ref {
    result
  } else {
    "(" + result + ")"
  }
})

= Test

$ 1 + 1 $ <test5>

== Subheading

$ 1 + 1 $ <test6>

@test-1, @test0, @test1, @test2, @test3, @test4, @test5, @test6, @test7, @test8

= Test

$ 1 + 1 $ <test7>

== Subheading

$ 1 + 1 $ <test8>

@test-1, @test0, @test1, @test2, @test3, @test4, @test5, @test6, @test7, @test8
