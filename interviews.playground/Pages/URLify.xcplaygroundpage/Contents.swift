//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

func urlify(string: String) -> String {
  let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
  let space = " "
  var result = ""
  for char in trimmed {
    if String(char) == space {
      result += "%20"
    } else {
      result += String(char)
    }
  }

  return result.count == trimmed.count ? string : result
}

func urlifyV2(string: String) -> String {
  let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
  let split = trimmed.split(separator: " ")
  let result = split.reduce("") { string, substring in
    if string.count == 0 {
      return String(substring)
    } else {
      return string + "%20" + String(substring)
    }
  }

  return result.count == trimmed.count ? string : result
}

print(urlify(string: str))
print(urlify(string: "Mr. John Smith    "))
print("----------")
print(urlifyV2(string: str))
print(urlifyV2(string: "Mr. John Smith    "))

//: [Next](@next)
