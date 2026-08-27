/// A numbering function is anything `(ref: false, ..nums) => string` where `ref` is false when the numbering is called from the element itself and true if it is called from a ref.

#let equate-sub-numbering-state = state("equate/sub-numbering", false)

#let counting-symbols = "1aAiIαΑ一壹あいアイא가ㄱ*١۱१১ক①⓵"
#let non-counting = "[^" + counting-symbols + "]"
#let pattern = regex("^" + non-counting + "*(.*?)" + non-counting + "*$")

#let trim-numbering(s) = s.match(pattern).captures.at(0)

#let counting-pattern = regex("[" + counting-symbols + "]")

/// Returns the number of counting symbols in the provided numbering pattern
#let count-counting-symbols(s) = s.matches(counting-pattern).len()

/// Produces a numbering pattern/function that trims numbering patterns if `(ref: true)` is passed.
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

/// Produces a numbering that trims numbering patterns if `(ref: true)` is passed.
#let my-numbering(the-numbering, ref: false, ..nums) = {
  numbering(patch-numbering(the-numbering, ref: ref), ..nums)
}

/// Gets numbering pattern/function for `target` element type at `here()`
#let get-numbering(target, ref: false) = {
  patch-numbering(
    query(selector(target).before(here()))
      .last(default: (numbering: none))
      .numbering,
    ref: ref,
  )
}

/// Displays numbering for `target` with truncated counter to `max-level`.
#let display-numbering(target, max-level, ref: false) = {
  let the-numbering = get-numbering(target, ref: ref)
  if the-numbering == none or max-level == 0 {
    return none
  }
  counter(target).display((..nums, ref: ref) => my-numbering(
    the-numbering,
    ..nums.pos().slice(0, calc.min(max-level, nums.pos().len())),
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

/// Returns numbering function that concatenates displayed `heading` numbering with truncated counter to `max-level` with `separator` and the passed `numbering`.
#let heading-dependent(max-level, the-numbering, separator: ".") = {
  (ref: false, ..nums) => {
    let the-heading = display-numbering(heading, max-level, ref: ref)
    if the-heading != none {
      the-heading += separator
    }
    (
      the-heading + my-numbering(the-numbering, ref: ref, ..nums)
    )
  }
}

/// Returns a numbering function that uses the first numbering for non-`ref` numberings and the second numbering for `ref` numberings.
#let ref-dependent(inline-numbering, ref-numbering) = {
  (
    ref: false,
    ..nums,
  ) => {
    if ref {
      my-numbering(ref-numbering, ref: ref, ..nums)
    } else {
      my-numbering(inline-numbering, ref: ref, ..nums)
    }
  }
}

/// Returns a numbering function that uses the first numbering for `figure.where(kind: "subfigure")` and, if provided, the second numbering for `normal-figure`. Use `figure-numbering: auto` to use the same numbering for `normal-figure`. Does NOT add the parent figure number for subfigures!
#let subfigure-dependent(subfigure-numbering, figure-numbering: none) = {
  (
    ref: false,
    ..nums,
  ) => {
    if outer-figure-counter-value() == none {
      // figure
      assert(
        figure-numbering != none,
        message: "`subfigure-dependent` used for `normal-figure` numbering, either filter with `.where(kind: \"subfigure\")` or provide `figure-numbering` argument to `subfigure-dependent`",
      )
      my-numbering(
        if figure-numbering == auto { subfigure-numbering } else {
          figure-numbering
        },
        ref: ref,
        ..nums,
      )
    } else {
      // subfigure
      my-numbering(subfigure-numbering, ref: ref, ..nums)
    }
  }
}

/// Returns a numbering function that uses the first numbering for `figure.where(kind: "subfigure")` and, if provided, the second numbering for `normal-figure`. Use `figure-numbering: auto` to use the same numbering for `normal-figure`. ADDS the parent figure number for subfigures!
#let subfigure-counter-dependent(
  subfigure-numbering,
  figure-numbering: none,
) = {
  (
    ref: false,
    ..nums,
  ) => {
    let outer-figure-counter = outer-figure-counter-value()
    if outer-figure-counter == none {
      // figure
      assert(
        figure-numbering != none,
        message: "`subfigure-dependent` used for `normal-figure` numbering, either filter with `.where(kind: \"subfigure\")` or provide `figure-numbering` argument to `subfigure-dependent`",
      )
      my-numbering(
        if figure-numbering == auto { subfigure-numbering } else {
          figure-numbering
        },
        ref: ref,
        ..nums,
      )
    } else {
      // subfigure
      my-numbering(
        subfigure-numbering,
        ref: ref,
        ..outer-figure-counter,
        ..nums,
      )
    }
  }
}

/// Returns a numbering function that concatenates the passed numbering patterns/functions
#let concat(..numberings) = {
  (
    ref: false,
    ..nums,
  ) => {
    numberings.pos().map(numbering-fn => numbering-fn(ref: ref, ..nums)).join()
  }
}

/// Returns a numbering function that produces the provided string for non-`ref` uses and an empty string otherwise.
#let non-ref(string) = {
  (
    ref: false,
    ..nums,
  ) => {
    if ref {
      ""
    } else {
      string
    }
  }
}

/// Returns a numbering function that produces the provided string for `ref` uses and an empty string otherwise.
#let ref-only(string) = {
  (
    ref: false,
    ..nums,
  ) => {
    if ref {
      string
    } else {
      ""
    }
  }
}

#let link-ref(it, counter, render) = {
  let here = here()
  let location = it.element.location()
  assert(
    here != location,
    message: "cannot reference an element from its own location",
  )
  let rendered = counter.display(render, at: location)
  let result = if it.element.supplement == [] {
    rendered
  } else {
    [#it.element.supplement~#rendered]
  }
  link(location, result)
}

/// Resets the equation and figure counters at the specified heading level. Level 0 means not resetting at all. Also handles subfigures and ref.
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
    link-ref(it, counter(math.equation), patch-numbering(
      it.element.numbering,
      ref: true,
    ))
  }

  // imitates default show rule but passes (ref: true) to numbering
  show ref: it => {
    if it.element == none or it.element.func() != figure { return it }
    if it.element.kind not in (image, table, raw, "subfigure") { return it }
    link-ref(it, it.element.counter, patch-numbering(
      it.element.numbering,
      ref: true,
    ))
  }

  // equate compatibility for (ref: true) and correct location context
  // TODO upstream the display(at: ) as that should already fix quite a bit.
  // or rather try refactoring upstream so the numbering function can retrieve this value.
  show ref: it => {
    if it.element == none or it.element.func() != figure { return it }
    if it.element.kind != math.equation { return it }
    if it.element.body == none or it.element.body.func() != metadata {
      return it
    }
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
    link-ref(it, it.element.counter, (..) => numbering(
      patch-numbering(it.element.numbering, ref: true),
      ..nums,
    ))
  }

  it
}
