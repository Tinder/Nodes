//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Combine
import Nimble
import Nodes
import SwiftUI
import XCTest

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
final class StoreTests: XCTestCase {

    private final class Store: Nodes.Store<Int, String> {

        init() {
            super.init(state: 1) { $0 == 0 ? "23" : "\($0)" }
        }
    }

    @MainActor
    func testStore() {

        let store: Store = .init()

        expect(store).to(notBeNilAndToDeallocateAfterTest())

        var values: [String] = []

        let cancellable: AnyCancellable = store
            .viewStatePublisher
            .sink { values.append($0) }

        let stateStore: AnyStateStore<Int> = .init(store)
        let viewStateStore: AnyViewStateStore<String> = .init(store)
        let scopedViewStateStore: AnyViewStateStore<String> = .init(store.scope(viewState: \.self))

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
    func testTestStore() {
        var values: [(Int, Int)] = []
        let store: TestStore = .init(state: 23) { values.append(($0, $1)) }
        expect(store).to(notBeNilAndToDeallocateAfterTest())
        expect(store.state) == 23
        store.state = 100
        expect(store.state) == 100
        expect(values) == [(23, 100)]
    }

    @MainActor
    func testPreviewStore() {
        let store: PreviewStore = .init(viewState: 23)
        expect(store).to(notBeNilAndToDeallocateAfterTest())
        expect(store.viewState) == 23
        store.viewState = 100
        expect(store.viewState) == 100
    }

    @MainActor
    func testStoreBindings() {
        let store: Store = .init()
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
}
