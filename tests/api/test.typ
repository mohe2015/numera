#import "@preview/numera:0.0.1": (
  concat, count-counting-symbols, display-numbering, get-numbering,
  heading-dependent, my-numbering, non-ref, normal-figure, numera,
  outer-figure-counter-value, patch-numbering, ref-dependent, ref-only,
  subfigure-counter-dependent, subfigure-dependent, trim-numbering,
)
#import "@preview/numera:0.0.1" as api

// The entrypoint exposes the supported API without leaking implementation state
// or regex details.
#assert("numera" in api)
#assert("trim-numbering" in api)
#assert("ref-only" in api)
#assert("equate-sub-numbering-state" not in api)
#assert("counting-symbols" not in api)
#assert("pattern" not in api)
#assert("link-ref" not in api)

// Counting and trimming cover all supported pattern families and empty wrappers.
#assert.eq(count-counting-symbols("(1.a)"), 2)
#assert.eq(count-counting-symbols("α-A"), 2)
#assert.eq(count-counting-symbols("()"), 0)
#assert.eq(trim-numbering("(1.a)"), "1.a")
#assert.eq(trim-numbering("[α-A]"), "α-A")
#assert.eq(trim-numbering("()"), "")

// Patching preserves none, trims string patterns only for refs, and binds ref on
// function numberings.
#assert.eq(patch-numbering(none), none)
#assert.eq(patch-numbering("(1)"), "(1)")
#assert.eq(patch-numbering("(1)", ref: true), "1")

#let records-ref = (ref: false, ..nums) => (ref, nums.pos())
#assert.eq(patch-numbering(records-ref)(1, 2), (false, (1, 2)))
#assert.eq(
  patch-numbering(records-ref, ref: true)(1, 2),
  (true, (1, 2)),
)

// Reference decorators can be composed without needing a layout context.
#assert.eq(non-ref("inline")(ref: false), "inline")
#assert.eq(non-ref("inline")(ref: true), "")
#assert.eq(ref-only("reference")(ref: false), "")
#assert.eq(ref-only("reference")(ref: true), "reference")

#let decorated = concat(non-ref("inline"), ref-only("reference"))
#assert.eq(decorated(ref: false), "inline")
#assert.eq(decorated(ref: true), "reference")

#let switches = ref-dependent(
  (..nums) => "inline-" + str(nums.pos().first()),
  (..nums) => "reference-" + str(nums.pos().first()),
)
#assert.eq(switches(ref: false, 3), "inline-3")
#assert.eq(switches(ref: true, 3), "reference-3")

// A subfigure-only numbering without a normal-figure fallback must reject use
// outside a subfigure.
#context {
  assert-panic(() => subfigure-dependent("(a)")(1))
  assert-panic(() => subfigure-counter-dependent("(1a)")(1))
}
