///|
test "parses A1 column boundaries" {
  inspect(parse_column("A"), content="Some(1)")
  inspect(parse_column("Z"), content="Some(26)")
  inspect(parse_column("AA"), content="Some(27)")
  inspect(parse_column("XFD"), content="Some(16384)")
  inspect(parse_column("XFE"), content="None")
}

///|
test "formats A1 column boundaries" {
  inspect(format_column(1), content="Some(\"A\")")
  inspect(format_column(27), content="Some(\"AA\")")
  inspect(format_column(16384), content="Some(\"XFD\")")
  inspect(format_column(16385), content="None")
}
