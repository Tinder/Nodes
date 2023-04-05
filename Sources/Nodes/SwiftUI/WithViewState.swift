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
 *         WithViewState(initialState: initialState, statePublisher: viewState) { viewState in
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
    ///     - initialState: The initial view state.
    ///     - publisher: The view state ``Publisher`` instance to observe.
    ///     - content: A view builder that creates the content of this view.
    public init<P: Publisher>(
        initialState: ViewState,
        statePublisher publisher: P,
        @ViewBuilder content: @escaping (ViewState) -> Content
    ) where P.Output == ViewState, P.Failure == Never {
        self.publisher = publisher.eraseToAnyPublisher()
        self.content = content
        _viewState = State(initialValue: initialState)
    }
}
