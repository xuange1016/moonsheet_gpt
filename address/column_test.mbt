///|
test "parses A1 column boundaries" {
  assert_true(parse_column("A") == Some(1))
  assert_true(parse_column("Z") == Some(26))
  assert_true(parse_column("AA") == Some(27))
  assert_true(parse_column("XFD") == Some(16384))
  assert_true(parse_column("XFE") == None)
}

///|
test "formats A1 column boundaries" {
  assert_true(format_column(1) == Some("A"))
  assert_true(format_column(27) == Some("AA"))
  assert_true(format_column(16384) == Some("XFD"))
  assert_true(format_column(16385) == None)
}
