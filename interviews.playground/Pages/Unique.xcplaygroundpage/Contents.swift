//: [Previous](@previous)

import Foundation

let empty = ""
let unique = "abc"
let unique2 = "xtlkj325"
let nonunique = "abbccc"
let challenge = "AaBbCc"

extension String {
  func uniqueness() -> Bool {
    guard self.count > 0 else { return false }
    let normalized = self.lowercased()
    let set = Set<Character>(normalized)
    return set.count == self.count
  }

  var unique: Bool {
    guard self.count > 0 else { return false }
    let normalized = self.lowercased()
    let set = Set<Character>(normalized)
    return set.count == self.count
  }
}

print("Is \(empty) unique? \(empty.uniqueness())")
print("Is \(unique) unique? \(unique.uniqueness())")
print("Is \(unique2) unique? \(unique2.uniqueness())")
print("Is \(nonunique) unique? \(nonunique.uniqueness())")
print("Is \(challenge) unique? \(challenge.uniqueness())")

print("Is \(empty) unique? \(empty.unique)")
print("Is \(unique) unique? \(unique.unique)")
print("Is \(unique2) unique? \(unique2.unique)")
print("Is \(nonunique) unique? \(nonunique.unique)")
print("Is \(challenge) unique? \(challenge.unique)")

print("--------")

func isUnique(_ string: String) -> Bool {
  guard string.count > 0 else { return false }
  let normalized = string.lowercased()
  var counts = [Character : Int]()
  for char in normalized {
    if counts[char] == nil {
      counts[char] = 1
    } else { return false }
  }
  return true
}

print("Is \(empty) unique? \(isUnique(empty))")
print("Is \(unique) unique? \(isUnique(unique))")
print("Is \(unique2) unique? \(isUnique(unique2))")
print("Is \(nonunique) unique? \(isUnique(nonunique))")
print("Is \(challenge) unique? \(isUnique(challenge))")
print("-----------------")

//: [Next](@next)
