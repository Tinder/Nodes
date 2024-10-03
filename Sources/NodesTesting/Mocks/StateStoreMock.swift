//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

#if canImport(Observation)

import Nodes
import Observation

@Observable
@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public final class StateStoreMock<State: Equatable>: StateStore {

    public var state: State {
        didSet { stateSetCallCount += 1 }
    }

    public private(set) var stateSetCallCount: Int = 0

    public init(state: State) {
        self.state = state
    }
}

#endif
