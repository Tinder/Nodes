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

    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        tearDown(keyPath: \.mockWorkers, initialValue: [WorkerMock(), WorkerMock(), WorkerMock()])
    }

    @MainActor
    override func tearDown() async throws {
        try await super.tearDown()
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
        workerController.withFirstWorker(ofType: WorkerMock.self) { worker = $0 }
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
        workerController.withWorkers(ofType: WorkerMock.self) { workers.append($0) }
        expect(workers) == mockWorkers
    }

    @MainActor
    private func givenWorkerController(with workers: [Worker], start startWorkers: Bool = false) -> WorkerController {
        let workerController: WorkerController = .init(workers: workers)
        expect(workerController).to(notBeNilAndToDeallocateAfterTest())
        if startWorkers { workerController.startWorkers() }
        addTeardownBlock(with: workerController) { $0.stopWorkers() }
        return workerController
    }
}
