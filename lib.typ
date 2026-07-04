// we can create some helper functions that do the following:

// one function that does this
#show heading.where(level: 1): it => {
  counter(math.equation).update(0)
  it
}

#set heading(numbering: "1.1")

#let style-equations = it => {
  // then a function that allows updating the numbering-func
  let numbering-func = (location, ..nums, ref: false) => {
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
  }

  set math.equation(numbering: (..nums) => {
    // wrong style chain
    numbering-func(here(), ..nums, ref: false)
  })

  show ref: it => {
    if it.element == none or it.element.func() != math.equation { return it }
    // here the wrong numbering-func would be selected if you could update it.
    link(it.element.location(), numbering-func(it.element.location(), ..counter(math.equation).at(it.element.location()), ref: true))
  }
  it
}

#show: style-equations

#set figure(numbering: "a.a.a") // also gets chapter number

= Test

$ 1 + 1 $ <test1>

$ 1 + 1 $ <test2>

@test1, @test2, @test3, @test4

#set heading(numbering: "I.1")

= Test

$ 1 + 1 $ <test3>

$ 1 + 1 $ <test4>

@test1, @test2, @test3, @test4