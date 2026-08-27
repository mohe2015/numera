#let equate-sub-numbering-state = state("equate/sub-numbering", false)

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
  patch-numbering(
    query(selector(target).before(location))
      .last(default: (numbering: none))
      .numbering,
    ref: ref,
  )
}

#let display-numbering(target, max-level, ref: false) = {
  let numbering = get-numbering(target, ref: ref)
  if numbering == none {
    return none
  }
  counter(target).display((..nums, ref: ref) => my-numbering(
    numbering,
    ..nums.pos().slice(0, calc.min(2, nums.pos().len())),
    ref: ref,
  ))
}

/// A figure of kind `image`, `table` or `raw` (not a `figure.where(kind: "subfigure")`)
#let normal-figure = (
  figure
    .where(kind: image)
    .or(figure.where(kind: table))
    .or(figure.where(kind: raw))
)

/// Returns the counter of the `normal-figure` containing this `figure.where(kind: "subfigure")` or `none` when applied to the location of a `normal-figure`.
#let outer-figure-counter-value() = (
  if (
    query(selector(figure.where(kind: "subfigure")).within(here())).len() == 0
  ) {
    query(selector(normal-figure).before(here())).last().counter.get()
  } else {
    none
  }
)

#let heading-dependent(max-level, numbering) = {
  (ref: false, ..nums) => {
    (
      display-numbering(heading, max-level, ref: ref)
        + "."
        + my-numbering(numbering, ref: ref, ..nums)
    )
  }
}

// For non-`figure.where(kind: "subfigure")` (usually `normal-figure`) this applies the second numbering with only one number.

#let ref-dependent(inline-numbering, ref-numbering) = {
  (
    ref: false,
    ..nums,
  ) => {
    if ref {
      my-numbering(ref-numbering, ..nums)
    } else {
      my-numbering(inline-numbering, ..nums)
    }
  }
}

#let subfigure-dependent(subfigure-numbering, figure-numbering: none) = {
  (
    ref: false,
    ..nums,
  ) => {
    let outer-figure-counter = outer-figure-counter-value()
    if outer-figure-counter == none {
      // figure
      assert(figure-numbering != none, message: "`subfigure-dependent` used for `normal-figure` numbering, either filter with `.where(kind: \"subfigure\")` or provide `figure-numbering` argument to `subfigure-dependent`")
      my-numbering(figure-numbering, ..nums)
    } else {
      // subfigure
      my-numbering(subfigure-numbering, ..outer-figure-counter, ..nums)
    }
  }
}

#let numera(level: 0) = it => {
  show heading: it => {
    if it.level <= level {
      counter(math.equation).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(figure.where(kind: raw)).update(0)
    }
    it
  }

  show normal-figure: outer => {
    counter(figure.where(kind: "subfigure")).update(0)

    show figure.where(kind: "subfigure"): set figure(
      supplement: outer.supplement,
    )

    outer
  }

  // imitates default show rule but passes (ref: true) to numbering
  show ref: it => {
    if it.element == none or it.element.func() != math.equation { return it }
    let here = here()
    let location = it.element.location()
    assert(here != location)
    let rendered = counter(math.equation).display(
      patch-numbering(it.element.numbering, ref: true),
      at: location,
    )
    let result = if it.element.supplement == [] {
      rendered
    } else {
      [#it.element.supplement~#rendered]
    }
    link(location, result)
  }

  // imitates default show rule but passes (ref: true) to numbering
  show ref: it => {
    if it.element == none or it.element.func() != figure { return it }
    if it.element.kind not in (image, table, raw, "subfigure") { return it }
    let here = here()
    let location = it.element.location()
    assert(here != location)
    let rendered = it.element.counter.display(
      patch-numbering(it.element.numbering, ref: true),
      at: location,
    )
    let result = if it.element.supplement == [] {
      rendered
    } else {
      [#it.element.supplement~#rendered]
    }
    link(location, result)
  }

  // equate compatibility for (ref: true) and correct location context
  // TODO upstream the display(at: ) as that should already fix quite a bit.
  // or rather try refactoring upstream so the numbering function can retrieve this value.
  show ref: it => {
    if it.element == none { return it }
    if it.element.func() != figure { return it }
    if it.element.kind != math.equation { return it }
    if it.element.body == none { return it }
    if it.element.body.func() != metadata { return it }

    let nums = if equate-sub-numbering-state.at(it.element.location()) {
      it.element.body.value
    } else {
      (
        it.element.body.value.first()
          + it.element.body.value.slice(1).sum(default: 1)
          - 1,
      )
    }

    assert(
      it.element.numbering != none,
      message: "cannot reference equation without numbering.",
    )

    let here = here()
    let location = it.element.location()
    assert(here != location)
    let rendered = it.element.counter.display(
      (..) => numbering(
        patch-numbering(it.element.numbering, ref: true),
        ..nums,
      ),
      at: location,
    )
    let result = if it.element.supplement == [] {
      rendered
    } else {
      [#it.element.supplement~#rendered]
    }
    link(location, result)
  }

  it
}
