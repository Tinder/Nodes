//
//  StateObserver.swift
//  Nodes
//
//  Created by Christopher Fuller on 5/1/21.
//

#if canImport(Combine)
import Combine
#endif

/**
 * `StateObserver` specifies a method for updating a UI with view state.
 *
 * A protocol extension method is defined for [Combine](https://developer.apple.com/documentation/combine) for
 * configuring the `update(with:)` method to automatically be called with view state emitted by a given
 * publisher.
 *
 * > Important: For [SwiftUI](https://developer.apple.com/documentation/swiftui) use ``WithViewState``
 * instead.
 */
public protocol StateObserver: AnyObject {

    /// The type of view state with which to update the UI.
    associatedtype StateObserverStateType

    /// A method for updating a UI with the given view state.
    ///
    /// - Parameter with: The view state with which to update the UI.
    func update(with: StateObserverStateType)
}

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension StateObserver {

    /// Configures the `update(with:)` method to automatically be called with view state emitted by the given publisher.
    ///
    /// - Parameter publisher: The view state `Publisher` instance to observe.
    /// - Returns: A `Cancellable` instance.
    public func observe<P: Publisher>(
        _ publisher: P
    ) -> AnyCancellable where P.Output == StateObserverStateType, P.Failure == Never {
        publisher.sink { [weak self] in
            self?.update(with: $0)
        }
    }
}
