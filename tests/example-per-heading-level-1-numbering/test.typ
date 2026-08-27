#import "@preview/numera:0.0.1": (
  display-numbering, get-numbering, my-numbering, normal-figure, numera,
  outer-figure-counter-value, heading-dependent
)

#show: numera(level: 1)
#set heading(numbering: "1.1.1")

#set math.equation(numbering: heading-dependent(1, "1"))

= Chapter 1
$ E = m c^2 $ <eq1.1>

== Section 1.1
$ E = m c^2 $ <eq1.2>

== Section 1.2
$ E = m c^2 $ <eq1.3>

=== Sub-Section 1.2.1
$ E = m c^2 $ <eq1.4>

=== Sub-Section 1.2.2
$ E = m c^2 $ <eq1.5>

== Section 1.3
$ E = m c^2 $ <eq1.6>

= Chapter 2
$ E = m c^2 $ <eq2.1>
