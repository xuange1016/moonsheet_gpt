///|
test "selects stable primary root by specification priority" {
  assert_eq(primary_code("TYPE_ERROR", "PARSE_ERROR"), "PARSE_ERROR")
  assert_eq(
    primary_code("DEPENDENCY_ERROR", "CIRCULAR_REFERENCE"),
    "CIRCULAR_REFERENCE",
  )
}

///|
test "keeps left root stable when priorities tie" {
  assert_eq(primary_code("NUMERIC_ERROR", "DIVIDE_BY_ZERO"), "NUMERIC_ERROR")
}
