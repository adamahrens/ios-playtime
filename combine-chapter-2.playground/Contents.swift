import Foundation
import Combine
import CoreLocation

var subscriptions = Set<AnyCancellable>()

extension Notification.Name {
  enum App {
    static let didLoad = Notification.Name.init("appDidLoad")
  }
}

example(of: "Publisher/Subscriber") {
  let notification = Notification.Name.App.didLoad
  let publisher = NotificationCenter.default.publisher(for: notification)

  let observer = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: nil) { note in
    print("Notification received the old way with an observer")
  }

  // Need to sink
  let subscriber = publisher.sink {
    print("Publisher received notification: \($0.name.rawValue)")
  }

  // Send notification
  NotificationCenter.default.post(name: notification, object: nil)

  // Remove observering
  NotificationCenter.default.removeObserver(observer)

  // No longer want to receive stuff
  subscriber.cancel()
}

example(of: "Just for primitive types") {
  let justString = Just("My String")
  let justInt = Just(33)

  let _ = justString.sink(receiveCompletion: { _ in
    print("justString complete")
  }) {
    print("Received \($0)")
  }

  let _ = justInt.sink(receiveCompletion: { _ in
    print("justInt complete")
  }) {
    print("Received \($0)")
  }

  let _ = justString.sink(receiveCompletion: { _ in
    print("justString complete again")
  }) {
    print("Received \($0) again")
  }
}

example(of: "assign on KVO like properties") {
  class Weather {
    var city: String = "" {
      didSet {
        print(city)
      }
    }
  }

  let weather = Weather()
  let cities = ["Minneapolis", "St. Paul", "Iowa City"].publisher
  let _ = cities.assign(to: \.city, on: weather)
}

example(of: "custom subscriber") {
  final class MySubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never

    func receive(subscription: Subscription) {
      subscription.request(.max(8))
    }

    func receive(_ input: Int) -> Subscribers.Demand {
      print("MySubscriber received \(input)")
      //return .none
      return .unlimited
    }

    func receive(completion: Subscribers.Completion<Never>) {
      print("Received completion: \(completion)")
    }
  }

  let publisher = (1...11).publisher
  let subscriber = MySubscriber()
  publisher.subscribe(subscriber)
}

//example(of: "Futures") {
//  func futureIncrement(_ integer: Int, after delay: TimeInterval) -> Future<Int, Never> {
//    return Future<Int, Never> { promise in
//      print("O.G")
//      DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
//        promise(.success(integer + 1))
//      }
//    }
//  }
//
//  let future = futureIncrement(1, after: 3)
//  future
//    .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
//    .store(in: &subscriptions)
//
//  future
//     .sink(receiveCompletion: { print("Second Completion", $0) }, receiveValue: { print("Second Received", $0) })
//     .store(in: &subscriptions)
//}

example(of: "passthrough subject") {
  enum TestError: Error {
    case someBadThing
  }

  final class StringSubscriber: Subscriber {
    typealias Failure = TestError
    typealias Input = String

    func receive(subscription: Subscription) {
      subscription.request(.max(3))
    }

    func receive(completion: Subscribers.Completion<TestError>) {
      print("StringSubscriber#complete", completion)
    }

    func receive(_ input: String) -> Subscribers.Demand {
      print("StringSubscriber#input ", input)
      return input == "world" ? .max(2) : .none
    }
  }

  let subscriber = StringSubscriber()
  let subject = PassthroughSubject<String, TestError>()
  subject.subscribe(subscriber)

  let subscription = subject.sink(receiveCompletion: { error in
    print("Error: ", error)
  }) { next in
    print("Next: ", next)
  }

  subject.send("Hello")
  subject.send("Hello Again")
  subject.send(completion: .failure(TestError.someBadThing))
  subscription.cancel()
  subject.send("Still there?")
}

example(of: "Create a Blackjack card dealer") {
  let cards = [
    ("🂡", 11), ("🂢", 2), ("🂣", 3), ("🂤", 4), ("🂥", 5), ("🂦", 6), ("🂧", 7), ("🂨", 8), ("🂩", 9), ("🂪", 10), ("🂫", 10), ("🂭", 10), ("🂮", 10),
    ("🂱", 11), ("🂲", 2), ("🂳", 3), ("🂴", 4), ("🂵", 5), ("🂶", 6), ("🂷", 7), ("🂸", 8), ("🂹", 9), ("🂺", 10), ("🂻", 10), ("🂽", 10), ("🂾", 10),
    ("🃁", 11), ("🃂", 2), ("🃃", 3), ("🃄", 4), ("🃅", 5), ("🃆", 6), ("🃇", 7), ("🃈", 8), ("🃉", 9), ("🃊", 10), ("🃋", 10), ("🃍", 10), ("🃎", 10),
    ("🃑", 11), ("🃒", 2), ("🃓", 3), ("🃔", 4), ("🃕", 5), ("🃖", 6), ("🃗", 7), ("🃘", 8), ("🃙", 9), ("🃚", 10), ("🃛", 10), ("🃝", 10), ("🃞", 10)
  ]
  
  let dealtHand = PassthroughSubject<Hand, HandError>()

  func deal(_ cardCount: UInt) {
    var deck = cards
    var cardsRemaining = 52
    var hand = Hand()

    for _ in 0 ..< cardCount {
      let randomIndex = Int.random(in: 0 ..< cardsRemaining)
      hand.append(deck[randomIndex])
      deck.remove(at: randomIndex)
      cardsRemaining -= 1
    }

    // Add code to update dealtHand here
    if hand.points > 21 {
      dealtHand.send(completion: .failure(HandError.busted))
    } else {
      dealtHand.send(hand)
    }
  }

  // Add subscription to dealtHand here
  dealtHand.sink(receiveCompletion: { completion in
    print("Hand over")
  }) { cards in
    print("Dealt \(cards.cardString), for \(cards.points)")
  }

  deal(3)
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
