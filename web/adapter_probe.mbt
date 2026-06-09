///|
pub fn open_workbook_probe() -> String {
  "{\"status\":\"ready\",\"content_version\":1,\"calculation_version\":1}"
}

///|
pub fn commit_cell_probe(source_valid : Bool) -> String {
  if source_valid {
    "{\"status\":\"ready\",\"recalculated\":3}"
  } else {
    "{\"status\":\"parse_error\",\"recalculated\":0}"
  }
}
