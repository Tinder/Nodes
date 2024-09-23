// swiftlint:disable:this file_name
//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Nodes
import SwiftUI

public final class StateStoreMock<State: Equatable>: StateStore {

    public var state: State {
        get { _state }
        set { _state = newValue }
    }

    public private(set) var stateSetCallCount: Int = 0

    private var _state: State {
        didSet { stateSetCallCount += 1 }
    }

    public init(state: State) {
        self._state = state
    }
}

public final class ObservableStateStoreMock<State: Equatable>: ObservableStateStore {

    public var state: State {
        get { _state }
        set { _state = newValue }
    }

    public private(set) var stateSetCallCount: Int = 0

    private var _state: State {
        didSet { stateSetCallCount += 1 }
    }

    public init(state: State) {
        self._state = state
    }
}

// swiftlint:disable:next file_types_order
public final class ViewStateStoreMock<ViewState: Equatable>: ViewStateStore {

    public var viewState: ViewState {
        get { _viewState }
        set { _viewState = newValue }
    }

    public var bindHandler: ((Any, Any) -> (Any))?
    public var bindToHandler: ((Any, (@MainActor (Any) -> Void)?) -> (Any))?

    public private(set) var viewStateSetCallCount: Int = 0
    public private(set) var bindCallCount: Int = 0
    public private(set) var bindToCallCount: Int = 0

    private var _viewState: ViewState {
        didSet { viewStateSetCallCount += 1 }
    }

    public init(viewState: ViewState) {
        self._viewState = viewState
    }

    public func bind<T>(to keyPath: KeyPath<ViewState, T>, onChange: @escaping @MainActor (T) -> Void) -> Binding<T> {
        bindCallCount += 1
        if let bindHandler {
            // swiftlint:disable:next force_cast
            return bindHandler(keyPath, onChange) as! Binding<T>
        }
        fatalError("bindHandler returns can't have a default value thus its handler must be set")
    }

    public func bind<T>(to keyPath: KeyPath<ViewState, T>, onChange: (@MainActor (T) -> Void)?) -> Binding<T> {
        bindToCallCount += 1
        if let bindToHandler {
            // swiftlint:disable:next force_cast
            return bindToHandler(keyPath, onChange as? (@MainActor (Any) -> Void)) as! Binding<T>
        }
        fatalError("bindToHandler returns can't have a default value thus its handler must be set")
    }
}

public final class ObservableViewStateStoreMock<ViewState: Equatable>: ObservableViewStateStore {

    public var viewState: ViewState {
        get { _viewState }
        set { _viewState = newValue }
    }

    public var bindHandler: ((Any, Any) -> (Any))?
    public var bindToHandler: ((Any, (@MainActor (Any) -> Void)?) -> (Any))?

    public private(set) var viewStateSetCallCount: Int = 0
    public private(set) var bindCallCount: Int = 0
    public private(set) var bindToCallCount: Int = 0

    private var _viewState: ViewState {
        didSet { viewStateSetCallCount += 1 }
    }

    public init(viewState: ViewState) {
        self._viewState = viewState
    }

    public func bind<T>(to keyPath: KeyPath<ViewState, T>, onChange: @escaping @MainActor (T) -> Void) -> Binding<T> {
        bindCallCount += 1
        if let bindHandler {
            // swiftlint:disable:next force_cast
            return bindHandler(keyPath, onChange) as! Binding<T>
        }
        fatalError("bindHandler returns can't have a default value thus its handler must be set")
    }

    public func bind<T>(to keyPath: KeyPath<ViewState, T>, onChange: (@MainActor (T) -> Void)?) -> Binding<T> {
        bindToCallCount += 1
        if let bindToHandler {
            // swiftlint:disable:next force_cast
            return bindToHandler(keyPath, onChange as? (@MainActor (Any) -> Void)) as! Binding<T>
        }
        fatalError("bindToHandler returns can't have a default value thus its handler must be set")
    }
}
