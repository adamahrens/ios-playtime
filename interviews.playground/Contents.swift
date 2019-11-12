import UIKit

var empty = ""
var unique = "abc"
var challenge = "Aabc"
var nonunique = "abbc"
var unique2 = "xyasdf325"

func isUnique(_ string: String) -> Bool {
  guard string.count > 0 else { return false }
  let normalized = string.lowercased()
  var counts = [Character : Int]()
  for char in normalized {
    if counts[char] == nil {
      counts[char] = 1
    } else {
      return false
    }
  }

  return true
}

print("Is \(empty) unique? \(isUnique(empty))")
print("Is \(unique) unique? \(isUnique(unique))")
print("Is \(challenge) unique? \(isUnique(challenge))")
print("Is \(nonunique) unique? \(isUnique(nonunique))")
print("Is \(unique2) unique? \(isUnique(unique2))")
