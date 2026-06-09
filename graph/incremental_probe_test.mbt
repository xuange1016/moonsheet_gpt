///|
test "counts only affected cells in a dependency chain" {
  let parents = [-1, 0, 1, -1, 3]
  assert_eq(affected_count(parents, 0), 3)
  assert_eq(affected_count(parents, 3), 2)
}

///|
test "stops propagation when value and diagnostic stay equal" {
  assert_false(should_propagate(false, false))
  assert_true(should_propagate(true, false))
  assert_true(should_propagate(false, true))
}
