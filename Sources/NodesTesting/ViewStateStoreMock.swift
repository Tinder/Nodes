//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Nodes

public final class ViewStateStoreMock<ViewState: Equatable>: ViewStateStore, ObservableViewStateStore {

    public var viewState: ViewState {
        didSet { viewStateSetCallCount += 1 }
    }

    public private(set) var viewStateSetCallCount: Int = 0

    public init(viewState: ViewState) {
        self.viewState = viewState
    }
}
