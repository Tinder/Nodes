//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Combine
import Nimble
import Nodes
import SwiftUI
import XCTest

final class WithViewStateTests: XCTestCase {

    private struct State: Equatable {}

    @MainActor
    func testWithViewState() {
        var states: [State] = []
        let withViewState: WithViewState = .init(initialState: State(), statePublisher: Empty()) { state in
            states.append(state)
            return EmptyView()
        }
        expect(states).to(beEmpty())
        expect(withViewState.body).to(beAKindOf(SubscriptionView<AnyPublisher<State, Never>, EmptyView>.self))
        expect(states) == [State()]
    }
}
