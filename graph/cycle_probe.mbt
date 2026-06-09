///|
pub fn has_cycle_from(parents : Array[Int], start : Int) -> Bool {
  let seen = Array::make(parents.length(), false)
  let mut node = start
  while node >= 0 && node < parents.length() {
    if seen[node] {
      return true
    }
    seen[node] = true
    node = parents[node]
  }
  false
}

///|
pub fn chain_length(parents : Array[Int], start : Int) -> Int {
  let seen = Array::make(parents.length(), false)
  let mut node = start
  let mut count = 0
  while node >= 0 && node < parents.length() && !seen[node] {
    seen[node] = true
    count = count + 1
    node = parents[node]
  }
  count
}
