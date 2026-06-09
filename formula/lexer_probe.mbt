///|
pub fn is_formula(text : String) -> Bool {
  text.length() > 0 && text[0].to_int() == 61
}

///|
pub fn count_formula_punctuation(text : String) -> Int {
  let mut count = 0
  for i = 0; i < text.length(); i = i + 1 {
    let code = text[i].to_int()
    if code == 40 || code == 41 || code == 44 || code == 58 {
      count = count + 1
    }
  }
  count
}

///|
pub fn count_binary_operators(text : String) -> Int {
  let mut count = 0
  for i = 1; i < text.length(); i = i + 1 {
    let code = text[i].to_int()
    if code == 43 || code == 45 || code == 42 || code == 47 || code == 62 {
      count = count + 1
    }
  }
  count
}
