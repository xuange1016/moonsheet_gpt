///|
test "parser probe accepts the fixed milestone formula" {
  let formula = "=IF(A1>0,SUM(B1:B3),C1/0)"
  assert_eq(count_a1_references(formula), 4)
  assert_true(milestone_formula_is_parseable(formula))
}

///|
test "parser probe rejects an incomplete formula" {
  assert_false(milestone_formula_is_parseable("=IF(A1>0"))
}
