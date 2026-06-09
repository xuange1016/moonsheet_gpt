///|
pub fn diagnostic_priority(code : String) -> Int {
  match code {
    "PARSE_ERROR" | "UNSUPPORTED_FEATURE" => 0
    "CIRCULAR_REFERENCE" => 1
    "INVALID_REFERENCE" => 2
    "ARGUMENT_ERROR" | "NUMERIC_ERROR" | "DIVIDE_BY_ZERO" => 3
    "TYPE_ERROR" => 4
    "DEPENDENCY_ERROR" => 5
    _ => 99
  }
}

///|
pub fn primary_code(left : String, right : String) -> String {
  if diagnostic_priority(left) <= diagnostic_priority(right) {
    left
  } else {
    right
  }
}
