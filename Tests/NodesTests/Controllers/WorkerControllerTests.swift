//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
@testable import Nodes
import XCTest

final class WorkerControllerTests: XCTestCase, TestCaseHelpers {

    private var mockWorkers: [WorkerMock]!

    override func setUp() {
        super.setUp()
        tearDown(keyPath: \.mockWorkers, initialValue: [WorkerMock(), WorkerMock(), WorkerMock()])
    }

    override func tearDown() {
        super.tearDown()
    }

    func testWorkers() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        expect(workerController.workers as? [WorkerMock]) == mockWorkers
    }

    func testStartWorkers() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        expect(workerController.workers).toNot(allBeWorking())
        workerController.startWorkers()
        expect(workerController.workers).to(allBeWorking())
    }

    func testStopWorkers() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers, start: true)
        expect(workerController.workers).to(allBeWorking())
        workerController.stopWorkers()
        expect(workerController.workers).toNot(allBeWorking())
    }

    func testFirstWorkerOfType() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        expect(workerController.firstWorker(ofType: WorkerMock.self)) === mockWorkers.first
    }

    func testWithFirstWorkerOfType() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        var worker: WorkerMock?
        workerController.withFirstWorker(ofType: WorkerMock.self) { worker = $0 }
        expect(worker) === mockWorkers.first
    }

    func testWorkersOfType() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        expect(workerController.workers(ofType: WorkerMock.self)) == mockWorkers
    }

    func testWithWorkersOfType() {
        let workerController: WorkerController = givenWorkerController(with: mockWorkers)
        var workers: [WorkerMock] = []
        workerController.withWorkers(ofType: WorkerMock.self) { workers.append($0) }
        expect(workers) == mockWorkers
    }

    private func givenWorkerController(with workers: [Worker], start startWorkers: Bool = false) -> WorkerController {
        let workerController: WorkerController = .init(workers: workers)
        expect(workerController).to(notBeNilAndToDeallocateAfterTest())
        if startWorkers { workerController.startWorkers() }
        addTeardownBlock(with: workerController) { $0.stopWorkers() }
        return workerController
    }
}
