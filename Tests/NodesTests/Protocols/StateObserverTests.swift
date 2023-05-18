//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Combine
import Nimble
@testable import Nodes
import XCTest

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class StateObserverTests: XCTestCase {

    private class TestObserver: StateObserver {

        private(set) var observerCallCount: Int = 0

        func update(with: Void) {
            observerCallCount += 1
        }
    }

    func testObserve() {
        let observer: TestObserver = .init()
        let subject: PassthroughSubject<Void, Never> = .init()
        let cancellable: AnyCancellable = observer.observe(subject)
        expect(observer).to(notBeNilAndToDeallocateAfterTest())
        expect(subject).to(notBeNilAndToDeallocateAfterTest())
        expect(cancellable).to(notBeNilAndToDeallocateAfterTest())
        expect(observer.observerCallCount) == 0
        subject.send()
        subject.send()
        subject.send()
        expect(observer.observerCallCount).toEventually(equal(3))
        waitUntil { done in
            usleep(1_000)
            done()
        }
    }
}
