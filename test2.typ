// what about typst letting the numbering in #ref get a different here() context?
// probably show rules should also be reset so we would need to do this properly?

#set math.equation(numbering: (..nums) => counter(heading).display(at: here()))

#set heading(numbering: "1")

= Test

$ 1 + 1 $ <test>

#set heading(numbering: "a")

@test