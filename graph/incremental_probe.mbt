///|
fn depends_on(parents : Array[Int], node : Int, edited : Int) -> Bool {
  let seen = Array::make(parents.length(), false)
  let mut current = node
  while current >= 0 && current < parents.length() && !seen[current] {
    if current == edited {
      return true
    }
    seen[current] = true
    current = parents[current]
  }
  false
}

///|
pub fn affected_count(parents : Array[Int], edited : Int) -> Int {
  let mut count = 0
  for node = 0; node < parents.length(); node = node + 1 {
    if depends_on(parents, node, edited) {
      count = count + 1
    }
  }
  count
}

///|
pub fn should_propagate(
  value_changed : Bool,
  diagnostic_changed : Bool,
) -> Bool {
  value_changed || diagnostic_changed
}
