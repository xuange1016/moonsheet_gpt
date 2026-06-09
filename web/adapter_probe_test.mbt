///|
test "browser adapter exposes serialized ready state" {
  assert_eq(
    open_workbook_probe(),
    "{\"status\":\"ready\",\"content_version\":1,\"calculation_version\":1}",
  )
}

///|
test "invalid browser draft does not trigger recalculation" {
  assert_eq(
    commit_cell_probe(false),
    "{\"status\":\"parse_error\",\"recalculated\":0}",
  )
}
