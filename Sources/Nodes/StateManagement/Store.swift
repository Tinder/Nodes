//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

#if canImport(Combine) && canImport(Observation) && canImport(SwiftUI)

import Combine
import Observation
import SwiftUI

// MARK: - Protocols

@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public protocol StateStore<State>: AnyObject {

    associatedtype State: Equatable

    var state: State { get set }
}

@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public protocol ViewStateStore<ViewState>: AnyObject, Observable {

    associatedtype ViewState: Equatable

    var viewState: ViewState { get }
}

// MARK: - State Store

@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public final class AnyStateStore<
    State: Equatable
>: StateStore {

    public var state: State {
        get { box.state }
        set { box.state = newValue }
    }

    private var box: StateStoreBase<State>

    public init<Base: StateStore>(
        _ base: Base
    ) where Base.State == State {
        if let base: AnyStateStore = base as? AnyStateStore<State> {
            box = base.box
        } else {
            box = StateStoreBox(base)
        }
    }
}

@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
private class StateStoreBox<
    Base: StateStore
>: StateStoreBase<Base.State> {

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
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
private class StateStoreBase<
    State: Equatable
>: StateStore {

    var state: State {
        get { preconditionFailure("Property in abstract base class must be overridden") }
        // swiftlint:disable:next unused_setter_value
        set { preconditionFailure("Property in abstract base class must be overridden") }
    }
}

// MARK: - View State Store

@Observable
@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public final class AnyViewStateStore<
    ViewState: Equatable
>: ViewStateStore {

    public var viewState: ViewState {
        box.viewState
    }

    @ObservationIgnored
    private var box: ViewStateStoreBase<ViewState>

    public init<Base: ViewStateStore>(
        _ base: Base
    ) where Base.ViewState == ViewState {
        box = ViewStateStoreBox(base)
    }
}

@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
private class ViewStateStoreBox<
    Base: ViewStateStore
>: ViewStateStoreBase<Base.ViewState> {

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
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
private class ViewStateStoreBase<
    ViewState: Equatable
>: ViewStateStore {

    var viewState: ViewState {
        preconditionFailure("Property in abstract base class must be overridden")
    }
}

// MARK: - Preview

@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public final class PreviewStore<ViewState: Equatable>: ViewStateStore {

    public var viewState: ViewState

    public init(viewState: ViewState) {
        self.viewState = viewState
    }
}

// MARK: - Scope

@Observable
@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
private final class Scope<
    Store: ViewStateStore,
    ViewState: Equatable
>: ViewStateStore {

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

@Observable
@preconcurrency
@MainActor
@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
open class Store<
    State: Equatable,
    ViewState: Equatable
>: StateStore, ViewStateStore {

    @ObservationIgnored
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

@available(macOS 14.0, macCatalyst 17.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension ViewStateStore {

    public func scope<T: Equatable>(
        viewState keyPath: KeyPath<ViewState, T>
    ) -> AnyViewStateStore<T> {
        AnyViewStateStore(Scope(store: self, keyPath: keyPath))
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
        else {
            assertionFailure("The `onChange` closure should not be nil")
            return bind(to: keyPath) { _ in }
        }
        return bind(to: keyPath) { onChange($0) }
    }
}

#endif
