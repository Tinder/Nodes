//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Combine
import Nimble
import Nodes
import XCTest

final class StateObserverTests: XCTestCase {

    private class TestObserver: StateObserver {

        private(set) var observerCallCount: Int = 0

        func update(with: Void) {
            observerCallCount += 1
        }
    }

    @MainActor
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
        expect(observer.observerCallCount) == 3
    }
}
