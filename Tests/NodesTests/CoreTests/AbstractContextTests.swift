//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nimble
import Nodes
import XCTest

final class AbstractContextTests: XCTestCase, TestCaseHelpers {

    private class PresentableType {}

    private class TestContext: AbstractPresentableContext<CancellableMock, PresentableType> {

        private(set) var didBecomeActiveCallCount: Int = 0
        private(set) var willResignActiveCount: Int = 0

        override func didBecomeActive() {
            super.didBecomeActive()
            didBecomeActiveCallCount += 1
        }

        override func willResignActive() {
            super.willResignActive()
            willResignActiveCount += 1
        }
    }

    private var mockWorkers: [WorkerMock]!
    private var mockCancellables: [CancellableMock]!

    @MainActor
    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.mockWorkers, initialValue: [WorkerMock(), WorkerMock(), WorkerMock()])
        tearDown(keyPath: \.mockCancellables, initialValue: [CancellableMock(), CancellableMock(), CancellableMock()])
    }

    @MainActor
    override func tearDown() {
        super.tearDown()
    }

    @MainActor
    func testPresentable() {
        let presentable: PresentableType = .init()
        expect(presentable).to(notBeNilAndToDeallocateAfterTest())
        let context: TestContext = givenContext(presentable: presentable)
        expect(context.presentable) === presentable
    }

    @MainActor
    func testCancellables() {
        let cancellables: [CancellableMock] = [CancellableMock(), CancellableMock(), CancellableMock()]
        expect(cancellables).to(notBeNilAndElementsToDeallocateAfterTest())
        let context: TestContext = givenContext(cancellables: cancellables)
        expect(context.cancellables).to(haveCount(3))
        expect(context.cancellables).to(contain(cancellables))
    }

    @MainActor
    func testWorkers() {
        let context: TestContext = givenContext(workers: mockWorkers)
        expect(context.workers as? [WorkerMock]) == mockWorkers
    }

    @MainActor
    func testActivate() {
        let context: TestContext = givenContext(workers: mockWorkers)
        expect(context).toNot(beActive())
        expect(context.didBecomeActiveCallCount) == 0
        expect(context.workers).toNot(allBeWorking())
        context.activate()
        expect(context).to(beActive())
        expect(context.didBecomeActiveCallCount) == 1
        expect(context.workers).to(allBeWorking())
    }

    @MainActor
    func testDeactivate() {
        let context: TestContext = givenContext(workers: mockWorkers, cancellables: mockCancellables)
        let cancellables: [CancellableMock] = Array(context.cancellables)
        expect(cancellables).toNot(allBeCancelled())
        expect(context.cancellables).to(haveCount(3))
        context.activate()
        expect(context).to(beActive())
        expect(context.willResignActiveCount) == 0
        expect(context.workers).to(allBeWorking())
        context.deactivate()
        expect(context).toNot(beActive())
        expect(context.willResignActiveCount) == 1
        expect(context.workers).toNot(allBeWorking())
        expect(cancellables).to(allBeCancelled())
        expect(context.cancellables).to(beEmpty())
    }

    @MainActor
    func testFirstWorkerOfType() {
        let context: TestContext = givenContext(workers: mockWorkers)
        expect(context.firstWorker(ofType: WorkerMock.self)) == mockWorkers.first
    }

    @MainActor
    func testWithFirstWorkerOfType() {
        let context: TestContext = givenContext(workers: mockWorkers)
        var worker: WorkerMock?
        context.withFirstWorker(ofType: WorkerMock.self) { worker = $0 }
        expect(worker) == mockWorkers.first
    }

    @MainActor
    func testWorkersOfType() {
        let context: TestContext = givenContext(workers: mockWorkers)
        expect(context.workers(ofType: WorkerMock.self)) == mockWorkers
    }

    @MainActor
    func testWithWorkersOfType() {
        let context: TestContext = givenContext(workers: mockWorkers)
        var workers: [WorkerMock] = []
        context.withWorkers(ofType: WorkerMock.self) { workers.append($0) }
        expect(workers) == mockWorkers
    }

    @MainActor
    private func givenContext(
        presentable: PresentableType? = nil,
        workers: [Worker] = [],
        cancellables: [CancellableMock] = []
    ) -> TestContext {
        let context: TestContext
        if let presentable: PresentableType {
            context = .init(presentable: presentable, workers: workers)
        } else {
            let presentable: PresentableType = .init()
            expect(presentable).to(notBeNilAndToDeallocateAfterTest())
            context = .init(presentable: presentable, workers: workers)
        }
        expect(context).to(notBeNilAndToDeallocateAfterTest())
        context.cancellables.formUnion(cancellables)
        addTeardownBlock(with: context) { context in
            guard context.isActive
            else { return }
            context.deactivate()
        }
        return context
    }
}
