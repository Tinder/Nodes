//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
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
