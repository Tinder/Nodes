// swiftlint:disable:this file_name
//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nodes

// swiftlint:disable:next file_types_order
internal final class FlowMock: Flow, Equatable {

    internal let tree: Node = .init(name: "", children: [])

    internal private(set) var isStarted: Bool = false

    // swiftlint:disable:next identifier_name
    internal let _context: Context = ContextMock()

    nonisolated internal static func == (lhs: FlowMock, rhs: FlowMock) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    internal func start() {
        isStarted = true
        _context.activate()
    }

    internal func end() {
        _context.deactivate()
        isStarted = false
    }
}

internal final class ContextMock: Context {

    internal private(set) var isActive: Bool = false

    internal func activate() {
        isActive = true
    }

    internal func deactivate() {
        isActive = false
    }
}

internal final class WorkerMock: Worker, Equatable {

    internal private(set) var isWorking: Bool = false

    internal static func == (lhs: WorkerMock, rhs: WorkerMock) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    internal func start() {
        isWorking = true
    }

    internal func stop() {
        isWorking = false
    }
}

internal final class CancellableMock: Cancellable {

    internal private(set) var isCancelled: Bool = false

    internal static func == (lhs: CancellableMock, rhs: CancellableMock) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    internal func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    internal func cancel() {
        isCancelled = true
    }
}
