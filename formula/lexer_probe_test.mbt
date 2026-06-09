///|
test "recognizes the milestone zero formula shape" {
  let formula = "=IF(A1>0,SUM(B1:B3),C1/0)"
  assert_true(is_formula(formula))
  assert_eq(count_formula_punctuation(formula), 7)
  assert_eq(count_binary_operators(formula), 2)
}

///|
test "rejects literal text as a formula" {
  assert_false(is_formula("Revenue"))
}
