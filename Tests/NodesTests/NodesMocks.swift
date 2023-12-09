// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nodes

// swiftlint:disable:next file_types_order
extension Equatable where Self: AnyObject {

    internal static func == (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs
    }
}

// swiftlint:disable:next file_types_order
internal final class FlowMock: Flow, Equatable {

    internal let tree: Node = .init(name: "", children: [])

    // swiftlint:disable:next redundant_type_annotation
    internal private(set) var isStarted: Bool = false

    // swiftlint:disable:next identifier_name
    internal let _context: Context = ContextMock()

    internal func start() {
        isStarted = true
        _context.activate()
    }

    internal func end() {
        _context.deactivate()
        isStarted = false
    }
}

internal final class ContextMock: Context, Equatable {

    // swiftlint:disable:next redundant_type_annotation
    internal private(set) var isActive: Bool = false

    internal func activate() {
        isActive = true
    }

    internal func deactivate() {
        isActive = false
    }
}

internal final class WorkerMock: Worker, Equatable {

    // swiftlint:disable:next redundant_type_annotation
    internal private(set) var isWorking: Bool = false

    internal func start() {
        isWorking = true
    }

    internal func stop() {
        isWorking = false
    }
}

internal final class CancellableMock: Cancellable {

    // swiftlint:disable:next redundant_type_annotation
    internal private(set) var isCancelled: Bool = false

    internal func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    internal func cancel() {
        isCancelled = true
    }
}
