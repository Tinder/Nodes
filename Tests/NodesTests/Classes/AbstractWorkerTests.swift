//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import Nodes
import XCTest

final class AbstractWorkerTests: XCTestCase, TestCaseHelpers {

    private class TestWorker: AbstractWorker<CancellableMock> {

        private(set) var didStartCallCount: Int = 0
        private(set) var willStopCallCount: Int = 0

        override func didStart() {
            super.didStart()
            didStartCallCount += 1
        }

        override func willStop() {
            super.willStop()
            willStopCallCount += 1
        }
    }

    private var mockCancellables: [CancellableMock]!

    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.mockCancellables, initialValue: [CancellableMock(), CancellableMock(), CancellableMock()])
    }

    override func tearDown() {
        super.tearDown()
    }

    func testStart() {
        let worker: TestWorker = givenWorker()
        expect(worker).toNot(beWorking())
        expect(worker.didStartCallCount) == 0
        worker.start()
        expect(worker).to(beWorking())
        expect(worker.didStartCallCount) == 1
        worker.stop()
    }

    func testStop() {
        let worker: TestWorker = givenStartedWorker(cancellables: mockCancellables)
        let cancellables: [CancellableMock] = Array(worker.cancellables)
        expect(cancellables).toNot(allBeCancelled())
        expect(worker.cancellables).to(haveCount(3))
        expect(worker).to(beWorking())
        expect(worker.willStopCallCount) == 0
        worker.stop()
        expect(worker).toNot(beWorking())
        expect(worker.willStopCallCount) == 1
        expect(cancellables).to(allBeCancelled())
        expect(worker.cancellables).to(beEmpty())
    }

    private func givenWorker() -> TestWorker {
        let worker: TestWorker = .init()
        expect(worker).to(notBeNilAndToDeallocateAfterTest())
        return worker
    }

    private func givenStartedWorker(cancellables: [CancellableMock] = []) -> TestWorker {
        let worker: TestWorker = givenWorker()
        worker.start()
        worker.cancellables.formUnion(cancellables)
        return worker
    }
}
