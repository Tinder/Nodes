//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if canImport(Observation)

import Nodes
import Observation

@Observable
@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public final class ViewStateStoreMock<
    ViewState: Equatable
>: ViewStateStore {

    public var viewState: ViewState {
        didSet { viewStateSetCallCount += 1 }
    }

    public private(set) var viewStateSetCallCount: Int = 0

    public init(viewState: ViewState) {
        self.viewState = viewState
    }
}

#endif
