//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Combine
import Nimble
import Nodes
import SwiftUI
import XCTest

final class ObservableStoreTests: XCTestCase {

    @MainActor
    func testObservableStore() {

        let store: ObservableStore = givenObservableStore()

        expect(store).to(notBeNilAndToDeallocateAfterTest())

        var values: [String] = []

        let cancellable: AnyCancellable = store
            .viewStatePublisher
            .sink { values.append($0) }

        let stateStore: AnyObservableStateStore<Int> = .init(store)
        let viewStateStore: AnyObservableViewStateStore<String> = .init(store)
        let scopedViewStateStore: AnyObservableViewStateStore<String> = .init(store.scope(viewState: \.self))

        expect(values) == ["1"]

        expect(stateStore.state) == 1
        expect(viewStateStore.viewState) == "1"
        expect(scopedViewStateStore.viewState) == "1"

        stateStore.state = 23

        expect(values) == ["1", "23"]

        expect(stateStore.state) == 23
        expect(viewStateStore.viewState) == "23"
        expect(scopedViewStateStore.viewState) == "23"

        stateStore.state = 23

        expect(values) == ["1", "23"]

        expect(stateStore.state) == 23
        expect(viewStateStore.viewState) == "23"
        expect(scopedViewStateStore.viewState) == "23"

        stateStore.state = 0

        expect(values) == ["1", "23"]

        expect(stateStore.state) == 0
        expect(viewStateStore.viewState) == "23"
        expect(scopedViewStateStore.viewState) == "23"

        stateStore.state = 100

        expect(values) == ["1", "23", "100"]

        expect(stateStore.state) == 100
        expect(viewStateStore.viewState) == "100"
        expect(scopedViewStateStore.viewState) == "100"

        cancellable.cancel()
    }

    @MainActor
    func testObservablePreviewStore() {
        let store: ObservablePreviewStore = .init(viewState: 23)
        expect(store).to(notBeNilAndToDeallocateAfterTest())
        expect(store.viewState) == 23
        store.viewState = 100
        expect(store.viewState) == 100
    }

    @MainActor
    func testObservableStoreBindings() {
        let store: ObservableStore = givenObservableStore()
        expect(store).to(notBeNilAndToDeallocateAfterTest())
        let onChangeA: (String) -> Void = { value in
            let sanitized: String = value.replacingOccurrences(of: "|", with: "")
            store.state = Int(sanitized) ?? -1
        }
        let onChangeB: ((String) -> Void)? = onChangeA
        let bindingA: Binding<String> = store.bind(to: \.self, onChange: onChangeA)
        let bindingB: Binding<String> = store.bind(to: \.self, onChange: onChangeB)
        expect(bindingA.wrappedValue) == "1"
        expect(bindingB.wrappedValue) == "1"
        bindingA.wrappedValue = "|23|"
        bindingB.wrappedValue = "|23|"
        expect(bindingA.wrappedValue) == "23"
        expect(bindingB.wrappedValue) == "23"
    }

    @MainActor
    private func givenObservableStore() -> ObservableStore<Int, String> {
        ObservableStore(state: 1) { $0 == 0 ? "23" : "\($0)" }
    }
}
