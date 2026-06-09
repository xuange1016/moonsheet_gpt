///|
test "parses A1 column boundaries" {
  assert_eq(parse_column("A"), Some(1))
  assert_eq(parse_column("Z"), Some(26))
  assert_eq(parse_column("AA"), Some(27))
  assert_eq(parse_column("XFD"), Some(16384))
  assert_eq(parse_column("XFE"), None)
}

///|
test "formats A1 column boundaries" {
  assert_eq(format_column(1), Some("A"))
  assert_eq(format_column(27), Some("AA"))
  assert_eq(format_column(16384), Some("XFD"))
  assert_eq(format_column(16385), None)
}
