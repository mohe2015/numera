#let counting-symbols = "1aAiIαΑ一壹あいアイא가ㄱ*١۱१১ক①⓵"
#let non-counting = "[^" + counting-symbols + "]"
#let pattern = regex("^" + non-counting + "*(.*?)" + non-counting + "*$")

#let trim-numbering(s) = s.match(pattern).captures.at(0)

#let patch-numbering(the-numbering, ref: false) = {
  if the-numbering == none {
    none
  } else if type(the-numbering) == str {
    if ref {
      trim-numbering(the-numbering)
    } else {
      the-numbering
    }
  } else {
    the-numbering.with(ref: ref)
  }
}

#let my-numbering(the-numbering, ref: false, ..nums) = {
  numbering(patch-numbering(the-numbering, ref: ref), ..nums)
}

#let get-numbering(target, ref: false, location: none) = {
  if location == none {
    location = here()
  }
  patch-numbering(query(selector(target).before(location)).last(default: (numbering: none)).numbering, ref: ref)
}

#let display(target, ref: false) = {
  let numbering = get-numbering(target, ref: ref)
  if numbering == none {
    return none
  }
  counter(target).display(numbering)
}

#let rules(it) = {
  // imitates default show rule with ref: true
  show ref: it => {
    if it.element == none or it.element.func() != math.equation { return it }
    let here = here()
    let location = it.element.location()
    assert(here != location)
    let rendered = counter(math.equation).display(patch-numbering(it.element.numbering, ref: true), at: location)
    let result = if it.element.supplement == [] {
      rendered
    } else {
      [#it.element.supplement~#rendered]
    }
    link(location, result)
  }

  show ref: it => {
    if it.element == none or it.element.func() != figure { return it }
    let here = here()
    let location = it.element.location()
    assert(here != location)
    let rendered = counter(figure).display(patch-numbering(it.element.numbering, ref: true), at: location)
    let result = if it.element.supplement == [] {
      rendered
    } else {
      [#it.element.supplement~#rendered]
    }
    link(location, result)
  }
  it
}