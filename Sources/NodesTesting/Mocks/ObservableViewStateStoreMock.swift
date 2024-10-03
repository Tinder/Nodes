//
//  Copyright © 2024 Tinder (Match Group, LLC)
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
