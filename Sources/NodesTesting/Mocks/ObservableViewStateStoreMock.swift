//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if canImport(SwiftUI)

import Nodes
import SwiftUI

@preconcurrency
@MainActor
public final class ObservableViewStateStoreMock<
    ViewState: Equatable
>: ObservableViewStateStore {

    @Published
    public var viewState: ViewState {
        didSet { viewStateSetCallCount += 1 }
    }

    public private(set) var viewStateSetCallCount: Int = 0

    public init(viewState: ViewState) {
        self.viewState = viewState
    }
}

#endif
