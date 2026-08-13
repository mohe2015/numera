#import "@preview/numera:0.0.1": (
  display-numbering, get-numbering, my-numbering, normal-figure, numera,
  outer-figure-counter-value,
)

#show: numera(level: 2)
#set heading(numbering: "1.1.1")

#set math.equation(numbering: (ref: false, ..nums) => {
  let numbering = get-numbering(heading, ref: ref)
  if numbering == none {
    return none
  }
  let last = query(heading.where(level: 2).before(here())).last(default: none)
  if last == none {
    return none
  }
  let heading = counter(heading).display(numbering, at: last.location())
  if heading != none {
    heading += "."
  }
  heading + my-numbering("1", ref: ref, ..nums)
})

= Chapter 1
$ E = m c^2 $ <eq1.1>

== Section 1.1
$ E = m c^2 $ <eq1.1.1>

== Section 1.2
$ E = m c^2 $ <eq1.2.1>

=== Sub-Section 1.2.1
$ E = m c^2 $ <eq1.2.2>

=== Sub-Section 1.2.2
$ E = m c^2 $ <eq1.2.3>

== Section 1.3
$ E = m c^2 $ <eq1.3.1>

= Chapter 2
$ E = m c^2 $ <eq2.1>
