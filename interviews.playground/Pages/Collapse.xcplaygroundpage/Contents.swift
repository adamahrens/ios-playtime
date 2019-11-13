//: [Previous](@previous)

import Foundation

let string = "aabbccc" //a2b2c3

func collapse(string: String) -> String {

  guard string.count > 0 else { return string }

  var lastSeen: String?
  var currentCount = 0
  var result = ""

  for char in string {
    if lastSeen == nil {
      lastSeen = String(char)
      currentCount = 1
    } else if let last = lastSeen {
      // Are they equal?
      if last == String(char) {
        currentCount += 1
      } else {
        // They aren't update result
        result += last + "\(currentCount)"
        currentCount = 1
        lastSeen = String(char)
      }
    }
  }

  let final = result + lastSeen! + "\(currentCount)"
  return final.count > string.count ? string : final
}

print(collapse(string: string))
print(collapse(string: "abcdefg"))

//: [Next](@next)
