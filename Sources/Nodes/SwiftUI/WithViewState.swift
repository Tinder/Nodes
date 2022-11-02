//
//  WithViewState.swift
//  Nodes
//
//  Created by Christopher Fuller on 5/11/21.
//

#if canImport(Combine) && canImport(SwiftUI)
import Combine
import SwiftUI
#endif

/**
 * A [SwiftUI](https://developer.apple.com/documentation/swiftui) helper
 * [View](https://developer.apple.com/documentation/swiftui/view) that provides access to view state emitted
 * by a given publisher.
 *
 * Usage Example:
 * ```
 * struct ExampleViewState: Equatable {
 *     let text: String
 * }
 *
 * struct ExampleView: View {
 *     let viewState: AnyPublisher<ExampleViewState, Never>
 *     let initialState: ExampleViewState = .init(text: "Hello World")
 *     var body: some View {
 *         WithViewState(viewState, initialState: initialState) { viewState in
 *             Text(viewState.text)
 *         }
 *     }
 * }
 * ```
 *
 * It is also possible to define the initial state within the state type definition by adopting the
 * ``InitialStateProviding`` protocol.
 *
 * Usage Example:
 * ```
 * struct ExampleViewState: Equatable, InitialStateProviding {
 *     static let initialState: ExampleViewState = .init(text: "Hello World")
 *     let text: String
 * }
 *
 * struct ExampleView: View {
 *     let viewState: AnyPublisher<ExampleViewState, Never>
 *     var body: some View {
 *         WithViewState(viewState) { viewState in
 *             Text(viewState.text)
 *         }
 *     }
 * }
 * ```
 */
@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct WithViewState<ViewState, Content: View>: View {

    /// The content and behavior of the view.
    public var body: some View {
        content(viewState).onReceive(publisher) { viewState = $0 }
    }

    private let publisher: AnyPublisher<ViewState, Never>
    private let content: (ViewState) -> Content

    @State private var viewState: ViewState

    /// Initializes a ``WithViewState`` view with the given view state `publisher`, `initialState` and `content`.
    ///
    /// - Parameters:
    ///     - publisher: The view state ``Publisher`` instance to observe.
    ///     - initialState: The initial view state.
    ///     - content: A view builder that creates the content of this view.
    public init<P: Publisher>(
        _ publisher: P,
        initialState: ViewState,
        @ViewBuilder content: @escaping (ViewState) -> Content
    ) where P.Output == ViewState, P.Failure == Never {
        self.publisher = publisher.eraseToAnyPublisher()
        self.content = content
        _viewState = State(initialValue: initialState)
    }

    /// Initializes a ``WithViewState`` view with the given view state `publisher` and `content`.
    ///
    /// - Parameters:
    ///     - publisher: The view state ``Publisher`` instance to observe.
    ///     - content: A view builder that creates the content of this view.
    @available(macOS 11.0, macCatalyst 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    public init(
        _ publisher: CurrentValuePublisher<ViewState>,
        @ViewBuilder content: @escaping (ViewState) -> Content
    ) {
        self.init(publisher, initialState: publisher.value, content: content)
    }
}

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension WithViewState where ViewState: InitialStateProviding {

    /// Initializes a ``WithViewState`` view with the given view state `publisher` and `content`.
    ///
    /// - Parameters:
    ///     - publisher: The view state ``Publisher`` instance to observe.
    ///     - content: A view builder that creates the content of this view.
    public init<P: Publisher>(
        _ publisher: P,
        @ViewBuilder content: @escaping (ViewState) -> Content
    ) where P.Output == ViewState, P.Failure == Never {
        self.init(publisher, initialState: .initialState, content: content)
    }
}
