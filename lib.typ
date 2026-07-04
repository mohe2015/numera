#let equation-numbering-func = state("equation-numbering-func", (location, ..nums, ref: false) => {
  let heading-numbering = query(selector(heading).before(location)).last(default: none)
  let result = if heading-numbering == none {
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

#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

#set heading(numbering: "1.1")

#let style-equations = it => {
  set math.equation(numbering: (..nums) => {
    // wrong style chain
    equation-numbering-func.get()(here(), ..nums, ref: false)
  })

  show ref: it => {
    if it.element == none or it.element.func() != math.equation { return it }
    // here the wrong numbering-func would be selected if you could update it.
    link(it.element.location(), equation-numbering-func.at(it.element.location())(it.element.location(), ..counter(math.equation).at(it.element.location()), ref: true))
  }
  it
}

#show: style-equations

#set figure(numbering: "a.a.a") // also gets chapter number

= Test

$ 1 + 1 $ <test1>

$ 1 + 1 $ <test2>

@test1, @test2, @test3, @test4, @test5, @test6, @test7, @test8

#set heading(numbering: "I.1")

= Test

$ 1 + 1 $ <test3>

$ 1 + 1 $ <test4>

@test1, @test2, @test3, @test4, @test5, @test6, @test7, @test8

#equation-numbering-func.update(old => (location, ..nums, ref: false) => {
  let heading-numbering = query(selector(heading).before(location)).last(default: none)
  let result = if heading-numbering == none {
    numbering("A", ..nums)
  } else {
    numbering(heading-numbering.numbering, ..counter(heading).at(location)) + "." + numbering("A", ..nums)
  }
  if ref {
    result
  } else {
    "(" + result + ")"
  }
})

= Test

$ 1 + 1 $ <test5>

$ 1 + 1 $ <test6>

@test1, @test2, @test3, @test4, @test5, @test6, @test7, @test8

#set heading(numbering: "I.1")

= Test

$ 1 + 1 $ <test7>

$ 1 + 1 $ <test8>

@test1, @test2, @test3, @test4, @test5, @test6, @test7, @test8
