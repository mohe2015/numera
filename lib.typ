
#let counting-symbols = "1aAiIαΑ一壹あいアイא가ㄱ*١۱१১ক①⓵"
#let non-counting = "[^" + counting-symbols + "]"
#let pattern = regex("^" + non-counting + "*(.*?)" + non-counting + "*$")

#let trim-numbering(s) = s.match(pattern).captures.at(0)

#let get-numbering(target) = {
  query(selector(target).before(here())).last(default: (numbering: none)).numbering
}

#let display(target) = {
  let numbering = get-numbering(target)
  if numbering == none {
    return none
  }
  counter(target).display(numbering)
}

// imitates default show rule with ref: true
#show ref: it => {
  if it.element == none or it.element.func() != math.equation { return it }
  let here = here()
  let location = it.element.location()
  assert(here != location)
  let equation-numbering = query(selector(math.equation).before(location)).last(default: (numbering: none)).numbering
  if type(equation-numbering) == function {
    equation-numbering = equation-numbering.with(ref: true)
  }
  if type(equation-numbering) == str {
    equation-numbering = trim-numbering(equation-numbering)
  }
  let rendered = counter(math.equation).display(equation-numbering, at: location)
  let result = if it.element.supplement == [] {
    rendered
  } else {
    [#it.element.supplement~#rendered]
  }
  link(location, result)
}