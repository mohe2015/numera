#import "@preview/numera:0.0.1": (
  display-numbering, get-numbering, heading-dependent, my-numbering,
  normal-figure, numera, outer-figure-counter-value,
)

#show: numera(level: 3)
#set heading(numbering: "1.1.1")

#set math.equation(numbering: heading-dependent(3, "1"))

= Chapter 1
$ E = m c^2 $ <eq1.1>

== Section 1.1
$ E = m c^2 $ <eq1.1.1>

== Section 1.2
$ E = m c^2 $ <eq1.2.1>

=== Sub-Section 1.2.1
$ E = m c^2 $ <eq1.2.1.1>

=== Sub-Section 1.2.2
$ E = m c^2 $ <eq1.2.2.1>

== Section 1.3
$ E = m c^2 $ <eq1.3.1>

= Chapter 2
$ E = m c^2 $ <eq2.1>
