import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "collect") {
  let array = ["A", "B", "C", "D", "E", "F"]
  array.publisher.collect().sink(receiveCompletion: { _ in
    print("finished")
  }) { next in
    print(next)
  }

  // Collects in pairs of 2
  array.publisher.collect(2).sink(receiveCompletion: { _ in
    print("finished")
  }) { next in
    print(next)
  }
}

example(of: "map") {
  let formatter = NumberFormatter()
  formatter.numberStyle = .spellOut
  let array = [1001, 234567, 22, 69]
  array.publisher.map { num in
    formatter.string(from: NSNumber(integerLiteral: num)) ?? "NAN"
  }.sink { numberSpelled in
    print(numberSpelled)
  }.store(in: &subscriptions)
}

example(of: "map keypaths") {
  let publisher = PassthroughSubject<Coordinate, Never>()
  publisher.map(\.x, \.y).sink { x, y in
    print("Quadrant of \(x), \(y) is \(quadrantOf(x: x, y: y))")
  }.store(in: &subscriptions)

  publisher.send(Coordinate(x: 11, y: 24))
  publisher.send(Coordinate(x: -12, y: -7))
  publisher.send(Coordinate(x: 0, y: 4))
}

example(of: "tryMap") {
  Just("this/directory/doesnt/exist").tryMap {
    try FileManager.default.contentsOfDirectory(atPath: $0)
  }.sink(receiveCompletion: { completion in
    switch completion {
      
    }
    }, receiveValue: { contents in

  }).store(in: &subscriptions)
}

/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
