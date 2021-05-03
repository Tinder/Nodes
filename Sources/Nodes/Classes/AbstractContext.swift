//
//  AbstractContext.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

public protocol Cancellable: AnyObject, Hashable {

    func cancel()
}

/// @mockable
public protocol Context: AnyObject {

    var isActive: Bool { get }

    func activate()
    func deactivate()
}

open class AbstractContext<CancellableType: Cancellable>: Context {

    public var cancellables: Set<CancellableType> = .init()

    // swiftlint:disable:next redundant_type_annotation
    public private(set) var isActive: Bool = false

    public var workers: [Worker] {
        workerController.workers
    }

    private let workerController: WorkerController

    public init(workers: [Worker]) {
        self.workerController = .init(workers: workers)
    }

    open func didBecomeActive() {}
    open func willResignActive() {}

    public final func activate() {
        guard !isActive
        else { return }
        isActive = true
        didBecomeActive()
        workerController.startWorkers()
    }

    public final func deactivate() {
        guard isActive
        else { return }
        workerController.stopWorkers()
        willResignActive()
        cancellables.forEach {
            $0.cancel()
            LeakDetector.detect($0)
        }
        cancellables.removeAll()
        isActive = false
    }

    public final func firstWorker<T>(ofType type: T.Type) -> T? {
        workerController.firstWorker(ofType: type)
    }

    public final func withFirstWorker<T>(ofType type: T.Type, perform: (_ worker: T) throws -> Void) rethrows {
        try workerController.withFirstWorker(ofType: type, perform: perform)
    }

    public final func workers<T>(ofType type: T.Type) -> [T] {
        workerController.workers(ofType: type)
    }

    public final func withWorkers<T>(ofType type: T.Type, perform: (_ worker: T) throws -> Void) rethrows {
        try workerController.withWorkers(ofType: type, perform: perform)
    }

    deinit {
        deactivate()
        LeakDetector.detect(workerController)
    }
}

open class AbstractPresentableContext<CancellableType: Cancellable, PresentableType>: AbstractContext<CancellableType> {

    public let presentable: PresentableType

    public init(presentable: PresentableType, workers: [Worker]) {
        self.presentable = presentable
        super.init(workers: workers)
    }

    deinit {
        LeakDetector.detect(presentable as AnyObject)
    }
}
