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

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct WithViewState<ViewState: InitialStateProviding, Content: View>: View {

    public var body: some View {
        content(viewState).onReceive(publisher) { viewState = $0 }
    }

    private let publisher: AnyPublisher<ViewState, Never>
    private let content: (ViewState) -> Content

    @State(initialValue: .initialState) private var viewState: ViewState

    public init<P: Publisher>(
        _ publisher: P,
        @ViewBuilder content: @escaping (ViewState) -> Content
    ) where P.Output == ViewState, P.Failure == Never {
        self.publisher = publisher.eraseToAnyPublisher()
        self.content = content
    }
}
