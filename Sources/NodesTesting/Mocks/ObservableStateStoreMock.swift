//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Nodes

@preconcurrency
@MainActor
public final class ObservableStateStoreMock<
    State: Equatable
>: ObservableStateStore {

    public var state: State {
        didSet { stateSetCallCount += 1 }
    }

    public private(set) var stateSetCallCount: Int = 0

    public init(state: State) {
        self.state = state
    }
}
