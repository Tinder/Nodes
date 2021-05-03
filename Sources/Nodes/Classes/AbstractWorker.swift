//
//  AbstractWorker.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

/// @mockable
public protocol Worker: AnyObject {

    var isWorking: Bool { get }

    func start()
    func stop()
}

open class AbstractWorker<CancellableType: Cancellable>: Worker {

    public var cancellables: Set<CancellableType> = .init()

    // swiftlint:disable:next redundant_type_annotation
    public private(set) var isWorking: Bool = false

    public init() {}

    open func didStart() {}
    open func willStop() {}

    public final func start() {
        guard !isWorking
        else { return }
        isWorking = true
        didStart()
    }

    public final func stop() {
        guard isWorking
        else { return }
        willStop()
        cancellables.forEach {
            $0.cancel()
            LeakDetector.detect($0)
        }
        cancellables.removeAll()
        isWorking = false
    }

    deinit {
        stop()
    }
}
