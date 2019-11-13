//: [Previous](@previous)

import Foundation

let abc = "ABC"
let cab = "CAB"

let race = "Race"
let acer = "Acer"

func permutation(first: String, other: String) -> Bool {
  guard first.count != other.count else { return false }
  let firstChars = Array(first.lowercased())
  let otherChars = Array(other.lowercased())
  return firstChars.sorted() == otherChars.sorted()
}

print("Is \(cab) a permutation of \(abc)? \(permutation(first: abc, other: cab))")
print("Is \(acer) a permutation of \(race)? \(permutation(first: race, other: acer))")

let god = "God"
let dog = "dog"

extension String {
  func characterCounts() -> [Character:Int] {
    var counts = [Character:Int]()
    for character in self.lowercased() {
      if let value = counts[character] {
        counts[character] = value + 1
      } else {
        counts[character] =  1
      }
    }

    return counts
  }
}

func permutations(first: String, second: String) {
  let firstCounts = first.characterCounts()
  let secondCounts = second.characterCounts()
  if firstCounts == secondCounts {
    print("\(second) is a permutation of \(first)")
  } else {
    print("\(second) is NOT a permutation of \(first)")
  }
}

permutations(first: god, second: dog)

//: [Next](@next)
