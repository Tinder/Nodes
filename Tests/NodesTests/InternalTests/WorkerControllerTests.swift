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

final class WorkerControllerTests: XCTestCase, TestCaseHelpers {

    private var mockWorkers: [WorkerMock]!
    private var mockDelegate: WorkerControllerDelegateMock!

    @MainActor
    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.mockWorkers, initialValue: [WorkerMock(), WorkerMock(), WorkerMock()])
        tearDown(keyPath: \.mockDelegate, initialValue: WorkerControllerDelegateMock())
    }

    @MainActor
    override func tearDown() {
        super.tearDown()
    }

    @MainActor
    func testWorkers() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        expect(workerController.workers as? [WorkerMock]) == mockWorkers
    }

    @MainActor
    func testStartWorkers() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        expect(workerController.workers).toNot(allBeWorking())
        workerController.startWorkers()
        expect(workerController.workers).to(allBeWorking())
    }

    @MainActor
    func testStopWorkers() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers, start: true)
        expect(workerController.workers).to(allBeWorking())
        workerController.stopWorkers()
        expect(workerController.workers).toNot(allBeWorking())
    }

    @MainActor
    func testFirstWorkerOfType() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        expect(workerController.firstWorker(ofType: WorkerMock.self)) === mockWorkers.first
    }

    @MainActor
    func testWithFirstWorkerOfType() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        var worker: WorkerMock?
        try? workerController.withFirstWorker(ofType: WorkerMock.self) { worker = $0 }
        expect(worker) === mockWorkers.first
    }

    @MainActor
    func testWorkersOfType() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        expect(workerController.workers(ofType: WorkerMock.self)) == mockWorkers
    }

    @MainActor
    func testWithWorkersOfType() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        var workers: [WorkerMock] = []
        try? workerController.withWorkers(ofType: WorkerMock.self) { workers.append($0) }
        expect(workers) == mockWorkers
    }

    @MainActor
    func testWithFirstWorkerOfTypeWhenWorkerNotFoundNotifiesDelegateAndThrows() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        let nonExistentType = NonExistentWorkerMock.self
        
        expect { try workerController.withFirstWorker(ofType: nonExistentType) { _ in } }
            .to(throwError(NodeError.workerNotFound(String(describing: nonExistentType))))
        
        expect(mockDelegate.lastFailedWorkerType) == String(describing: nonExistentType)
    }

    @MainActor
    func testWithFirstWorkerOfTypeWhenDelegateIsNilThrowsWithoutNotification() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers, delegate: nil)
        let nonExistentType = NonExistentWorkerMock.self
        
        expect { try workerController.withFirstWorker(ofType: nonExistentType) { _ in } }
            .to(throwError(NodeError.workerNotFound(String(describing: nonExistentType))))
        
        expect(mockDelegate.lastFailedWorkerType).to(beNil())
    }

    @MainActor
    private func givenWorkerController(with workers: [Worker], start startWorkers: Bool = false, delegate: WorkerControllerDelegate? = nil) -> WorkerController {
        let workerController: WorkerController = .init(workers: workers, delegate: delegate ?? mockDelegate)
        expect(workerController).to(notBeNilAndToDeallocateAfterTest())
        if startWorkers { workerController.startWorkers() }
        addTeardownBlock(with: workerController) { $0.stopWorkers() }
        return workerController
    }
}

// MARK: - Test Doubles

private final class WorkerControllerDelegateMock: WorkerControllerDelegate {
    private(set) var lastFailedWorkerType: String?
    
    func workerController(_ controller: WorkerController, didFailToFindWorkerOfType type: String) {
        lastFailedWorkerType = type
    }
}

private final class NonExistentWorkerMock: Worker {
    var isWorking: Bool = false
    
    func start() {}
    func stop() {}
}
