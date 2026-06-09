///|
pub fn parse_column(text : String) -> Int? {
  if text.length() == 0 {
    return None
  }
  let mut value = 0
  for i = 0; i < text.length(); i = i + 1 {
    let code = text[i].to_int()
    let digit = if code >= 97 && code <= 122 {
      code - 97 + 1
    } else if code >= 65 && code <= 90 {
      code - 65 + 1
    } else {
      return None
    }
    value = value * 26 + digit
    if value > 16384 {
      return None
    }
  }
  Some(value)
}

///|
pub fn format_column(column : Int) -> String? {
  if column < 1 || column > 16384 {
    return None
  }
  let mut current = column
  let mut result = ""
  while current > 0 {
    let digit = (current - 1) % 26
    result = (digit + 65).unsafe_to_char().to_string() + result
    current = (current - 1) / 26
  }
  Some(result)
}
