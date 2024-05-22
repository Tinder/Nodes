//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

#if canImport(SwiftUI)

import SwiftUI

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Binding {

    /// Initializes a SwiftUI `Binding`.
    ///
    /// Use instead of the built-in SwiftUI provided initializer for two reasons:
    /// - Accepts a value for the getter instead of a closure
    /// - Allows for `.bind` which is more declarative than `.init`
    ///
    /// Example:
    /// ```swift
    /// var body: some View {
    ///     WithViewState(initialState: initialState, statePublisher: statePublisher) { viewState in
    ///         Slider(value: .bind(to: viewState.sliderValue) { receiver?.didChangeSliderValue($0) },
    ///                in: 1...100)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - value: A value for the getter of the binding.
    ///   - onChange: An escaping closure for the setter of the binding.
    ///
    /// - Returns: A SwiftUI `Binding` instance.
    @preconcurrency
    @MainActor
    public static func bind(
        to value: @escaping @autoclosure () -> Value,
        onChange: @escaping @MainActor (Value) -> Void
    ) -> Binding<Value> {
        Binding(get: value, set: onChange)
    }

    /// Initializes a SwiftUI `Binding`.
    ///
    /// Use instead of the built-in SwiftUI provided initializer for two reasons:
    /// - Accepts a value for the getter instead of a closure
    /// - Allows for `.bind` which is more declarative than `.init`
    ///
    /// Example:
    /// ```swift
    /// var body: some View {
    ///     WithViewState(initialState: initialState, statePublisher: statePublisher) { viewState in
    ///         Slider(value: .bind(to: viewState.sliderValue, onChange: receiver?.didChangeSliderValue),
    ///                in: 1...100)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - value: A value for the getter of the binding.
    ///   - onChange: An optional (escaping) closure for the setter of the binding.
    ///
    /// - Returns: A SwiftUI `Binding` instance.
    @preconcurrency
    @MainActor
    public static func bind(
        to value: @escaping @autoclosure () -> Value,
        onChange: (@MainActor (Value) -> Void)?
    ) -> Binding<Value> {
        if let onChange: @MainActor (Value) -> Void {
            Binding(get: value, set: onChange)
        } else {
            Binding(get: value) { _ in }
        }
    }
}

#endif
