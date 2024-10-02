//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

#if canImport(Combine) && canImport(SwiftUI)

import Combine
import SwiftUI

// MARK: - Protocols

@preconcurrency
@MainActor
public protocol ObservableStateStore<State>: AnyObject {

    associatedtype State: Equatable

    var state: State { get set }
}

@preconcurrency
@MainActor
public protocol ObservableViewStateStore<ViewState>: AnyObject, ObservableObject {

    associatedtype ViewState: Equatable

    var viewState: ViewState { get }
}

// MARK: - State Store

@preconcurrency
@MainActor
public final class AnyObservableStateStore<
    State: Equatable
>: ObservableStateStore {

    public var state: State {
        get { box.state }
        set { box.state = newValue }
    }

    private var box: ObservableStateStoreBase<State>

    public init<Base: ObservableStateStore>(
        _ base: Base
    ) where Base.State == State {
        if let base: AnyObservableStateStore = base as? AnyObservableStateStore<State> {
            box = base.box
        } else {
            box = ObservableStateStoreBox(base)
        }
    }
}

@preconcurrency
@MainActor
private class ObservableStateStoreBox<
    Base: ObservableStateStore
>: ObservableStateStoreBase<Base.State> {

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
private class ObservableStateStoreBase<
    State: Equatable
>: ObservableStateStore {

    var state: State {
        get { preconditionFailure("Property in abstract base class must be overridden") }
        // swiftlint:disable:next unused_setter_value
        set { preconditionFailure("Property in abstract base class must be overridden") }
    }
}

// MARK: - View State Store

@preconcurrency
@MainActor
public final class AnyObservableViewStateStore<
    ViewState: Equatable
>: ObservableViewStateStore {

    public var viewState: ViewState {
        box.viewState
    }

    private var box: ObservableViewStateStoreBase<ViewState>

    private var cancellable: AnyCancellable?

    public init<Base: ObservableViewStateStore>(
        _ base: Base
    ) where Base.ViewState == ViewState {
        box = ObservableViewStateStoreBox(base)
        cancellable = base
            .objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }
}

@preconcurrency
@MainActor
private class ObservableViewStateStoreBox<
    Base: ObservableViewStateStore
>: ObservableViewStateStoreBase<Base.ViewState> {

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
private class ObservableViewStateStoreBase<
    ViewState: Equatable
>: ObservableViewStateStore {

    var viewState: ViewState {
        preconditionFailure("Property in abstract base class must be overridden")
    }
}

// MARK: - Preview

@preconcurrency
@MainActor
public final class ObservablePreviewStore<ViewState: Equatable>: ObservableViewStateStore {

    public var viewState: ViewState

    public init(viewState: ViewState) {
        self.viewState = viewState
    }
}

// MARK: - Scope

@preconcurrency
@MainActor
private final class ObservableScope<
    Store: ObservableViewStateStore,
    ViewState: Equatable
>: ObservableViewStateStore {

    var viewState: ViewState {
        store.viewState[keyPath: keyPath]
    }

    private let store: Store
    private let keyPath: KeyPath<Store.ViewState, ViewState>

    private var cancellable: AnyCancellable?

    init(
        store: Store,
        keyPath: KeyPath<Store.ViewState, ViewState>
    ) {
        self.store = store
        self.keyPath = keyPath
        cancellable = store
            .objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }
}

// MARK: - Store

@preconcurrency
@MainActor
open class ObservableStore<
    State: Equatable,
    ViewState: Equatable
>: ObservableStateStore, ObservableViewStateStore {

    public var state: State {
        didSet {
            guard state != oldValue
            else { return }
            viewState = transform(state)
            viewStateSubject.send(viewState)
        }
    }

    @Published
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

extension ObservableViewStateStore {

    public func scope<T: Equatable>(
        viewState keyPath: KeyPath<ViewState, T>
    ) -> AnyObservableViewStateStore<T> {
        AnyObservableViewStateStore(ObservableScope(store: self, keyPath: keyPath))
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
        guard let onChange: @MainActor (T) -> Void
        else { return bind(to: keyPath) { _ in } }
        return bind(to: keyPath, onChange: onChange)
    }
}

#endif
