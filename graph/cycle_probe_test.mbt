///|
test "detects self and three node cycles" {
  assert_true(has_cycle_from([0], 0))
  assert_true(has_cycle_from([1, 2, 0], 0))
}

///|
test "keeps acyclic chains available" {
  let parents = [1, 2, -1]
  assert_false(has_cycle_from(parents, 0))
  assert_eq(chain_length(parents, 0), 3)
}
