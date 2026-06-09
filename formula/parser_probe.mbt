///|
pub fn count_a1_references(text : String) -> Int {
  let mut count = 0
  for i = 0; i + 1 < text.length(); i = i + 1 {
    let first = text[i].to_int()
    let second = text[i + 1].to_int()
    if first >= 65 && first <= 90 && second >= 49 && second <= 57 {
      count = count + 1
    }
  }
  count
}

///|
pub fn milestone_formula_is_parseable(text : String) -> Bool {
  is_formula(text) &&
  count_a1_references(text) == 4 &&
  count_binary_operators(text) == 2 &&
  count_formula_punctuation(text) == 7
}
