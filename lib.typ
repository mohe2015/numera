#let equation-heading-level = state("equation-heading-level", 0)

#let equation-numbering-func = state("equation-numbering-func", (..) => {
  "SHOULD NEVER BE SHOWN"
})

#let counting-symbols = "1aAiIαΑ一壹あいアイא가ㄱ*١۱१১ক①⓵"
#let non-counting = "[^" + counting-symbols + "]"
#let pattern = regex("^" + non-counting + "*(.*?)" + non-counting + "*$")

#let trim-numbering(s) = s.match(pattern).captures.at(0)

#let my-numbering(the-numbering) = {
  if type(the-numbering) == str {
    (heading-numbering: none, heading-nums: none, ..nums, ref: false) => {
      if ref {
        numbering(trim-numbering(the-numbering), ..nums)
      } else {
        numbering(the-numbering, ..nums)
      }
    }
  } else {
    the-numbering
  }
}

#let set-equation-numbering(the-numbering) = {
  equation-numbering-func.update(old => my-numbering(the-numbering))
}

#let style-equations = it => {
  show heading: outer => {
    if outer.level <= equation-heading-level.get() {
      counter(math.equation).update(0)
    }
    outer
  }

  set math.equation(numbering: (..nums) => {
    let location = here()
    let heading-numbering = query(selector(heading).before(location)).last(default: (numbering: none)).numbering
    let heading-nums = counter(heading).at(location)
    equation-numbering-func.at(location)(heading-numbering: heading-numbering, heading-nums: heading-nums, ..nums, ref: false)
  })

  show ref: it => {
    // TODO supplement
    if it.element == none or it.element.func() != math.equation { return it }
    let location = it.element.location()
    let heading-numbering = query(selector(heading).before(location)).last(default: (numbering: none)).numbering
    let heading-nums = counter(heading).at(location)
    let nums = counter(math.equation).at(location)
    let rendered = equation-numbering-func.at(location)(heading-numbering: heading-numbering, heading-nums: heading-nums, ..nums, ref: true)
    let result = if it.element.supplement == [] {
      rendered
    } else {
      [#it.element.supplement~#rendered]
    }
    link(location, result)
  }
  it
}

#equation-heading-level.update(0)

#show: style-equations

#set-equation-numbering("(A)")

$ 1 + 1 $ <test-1>

#set heading(numbering: "1.1")

$ 1 + 1 $ <test0>

#set math.equation(supplement: none)

#set-equation-numbering((heading-numbering: none, heading-nums: none, ..nums, ref: false) => {
  let subnumbering = numbering("1", ..nums)
  let result = if heading-numbering == none {
    subnumbering
  } else {
    numbering(heading-numbering, ..heading-nums) + "." + subnumbering
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

#set-equation-numbering((heading-numbering: none, heading-nums: none, ..nums, ref: false) => {
  let subnumbering = numbering("A", ..nums)
  let result = if heading-numbering == none {
    subnumbering
  } else {
    numbering(heading-numbering, ..heading-nums) + "." + subnumbering
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
