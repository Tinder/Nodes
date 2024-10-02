A store compatible with [Perception](https://github.com/pointfreeco/swift-perception).

```swift
//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

import Combine
import Nodes
import Observation
import Perception
import SwiftUI

// MARK: - Protocols

@preconcurrency
@MainActor
public protocol PerceptibleStateStore<State>: AnyObject {

    associatedtype State: Equatable

    var state: State { get set }
}

@preconcurrency
@MainActor
public protocol PerceptibleViewStateStore<ViewState>: AnyObject, Perceptible {

    associatedtype ViewState: Equatable

    var viewState: ViewState { get }
}

// MARK: - State Store

@preconcurrency
@MainActor
public final class AnyPerceptibleStateStore<
    State: Equatable
>: PerceptibleStateStore {

    public var state: State {
        get { box.state }
        set { box.state = newValue }
    }

    private var box: PerceptibleStateStoreBase<State>

    public init<Base: PerceptibleStateStore>(
        _ base: Base
    ) where Base.State == State {
        if let base: AnyPerceptibleStateStore = base as? AnyPerceptibleStateStore<State> {
            box = base.box
        } else {
            box = PerceptibleStateStoreBox(base)
        }
    }
}

@preconcurrency
@MainActor
private class PerceptibleStateStoreBox<
    Base: PerceptibleStateStore
>: PerceptibleStateStoreBase<Base.State> {

    override var state: Base.State {
        get { base.state }
        set { base.state = newValue }
    }

    private var base: Base

    init(_ base: Base) {
        self.base = base
    }
}

@preconcurrency
@MainActor
private class PerceptibleStateStoreBase<
    State: Equatable
>: PerceptibleStateStore {

    var state: State {
        get { preconditionFailure("Property in abstract base class must be overridden") }
        // swiftlint:disable:next unused_setter_value
        set { preconditionFailure("Property in abstract base class must be overridden") }
    }
}

// MARK: - View State Store

@Perceptible
@preconcurrency
@MainActor
public final class AnyPerceptibleViewStateStore<
    ViewState: Equatable
>: PerceptibleViewStateStore {

    public var viewState: ViewState {
        box.viewState
    }

    @PerceptionIgnored
    private var box: PerceptibleViewStateStoreBase<ViewState>

    public init<Base: PerceptibleViewStateStore>(
        _ base: Base
    ) where Base.ViewState == ViewState {
        box = PerceptibleViewStateStoreBox(base)
    }
}

@preconcurrency
@MainActor
private class PerceptibleViewStateStoreBox<
    Base: PerceptibleViewStateStore
>: PerceptibleViewStateStoreBase<Base.ViewState> {

    override var viewState: Base.ViewState {
        base.viewState
    }

    private var base: Base

    init(_ base: Base) {
        self.base = base
    }
}

@preconcurrency
@MainActor
private class PerceptibleViewStateStoreBase<
    ViewState: Equatable
>: PerceptibleViewStateStore {

    var viewState: ViewState {
        preconditionFailure("Property in abstract base class must be overridden")
    }
}

// MARK: - Preview

@preconcurrency
@MainActor
public final class PerceptiblePreviewStore<ViewState: Equatable>: PerceptibleViewStateStore {

    public var viewState: ViewState

    public init(viewState: ViewState) {
        self.viewState = viewState
    }
}

// MARK: - Scope

@Perceptible
@preconcurrency
@MainActor
private final class PerceptibleScope<
    Store: PerceptibleViewStateStore,
    ViewState: Equatable
>: PerceptibleViewStateStore {

    var viewState: ViewState {
        store.viewState[keyPath: keyPath]
    }

    private let store: Store
    private let keyPath: KeyPath<Store.ViewState, ViewState>

    init(
        store: Store,
        keyPath: KeyPath<Store.ViewState, ViewState>
    ) {
        self.store = store
        self.keyPath = keyPath
    }
}

// MARK: - Store

@Perceptible
@preconcurrency
@MainActor
open class PerceptibleStore<
    State: Equatable,
    ViewState: Equatable
>: PerceptibleStateStore, PerceptibleViewStateStore {

    @PerceptionIgnored
    public var state: State {
        didSet {
            guard state != oldValue
            else { return }
            viewState = transform(state)
            viewStateSubject.send(viewState)
        }
    }

    public private(set) var viewState: ViewState

    public let viewStatePublisher: AnyPublisher<ViewState, Never>

    private let viewStateSubject: CurrentValueSubject<ViewState, Never>

    private let transform: (_ state: State) -> ViewState

    public convenience init<T: Transform>(
        state: State,
        transform: T
    ) where T.Input == State, T.Output == ViewState {
        self.init(state: state) { transform($0) }
    }

    public init(
        state: State,
        transform: @escaping (State) -> ViewState
    ) {
        let viewState: ViewState = transform(state)
        let viewStateSubject: CurrentValueSubject<ViewState, Never> = .init(viewState)
        self.state = state
        self.viewState = viewState
        self.viewStatePublisher = viewStateSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
        self.viewStateSubject = viewStateSubject
        self.transform = transform
    }
}

// MARK: - Extensions

extension PerceptibleViewStateStore {

    public func scope<T: Equatable>(
        viewState keyPath: KeyPath<ViewState, T>
    ) -> AnyPerceptibleViewStateStore<T> {
        AnyPerceptibleViewStateStore(PerceptibleScope(store: self, keyPath: keyPath))
    }

    public func bind<T>(
        to keyPath: KeyPath<ViewState, T>,
        onChange: @escaping @MainActor (T) -> Void
    ) -> Binding<T> {
        Binding { [self] in
            viewState[keyPath: keyPath]
        } set: { value in
            onChange(value)
        }
    }

    public func bind<T>(
        to keyPath: KeyPath<ViewState, T>,
        onChange: (@MainActor (T) -> Void)?
    ) -> Binding<T> {
        guard let onChange: (@MainActor (T) -> Void)
        else { return bind(to: keyPath) { _ in } }
        return bind(to: keyPath, onChange: onChange)
    }
}
```
