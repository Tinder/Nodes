//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Binding {

    /// Initializes a SwiftUI `Binding`.
    ///
    /// Use instead of the built-in SwiftUI provided initializer for two reasons:
    /// - Accepts a value for the getter instead of a closure
    /// - Allows for `.bind` which is more declarative than `.init`
    ///
    /// Example:
    /// ```
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
    public static func bind(to value: Value, onChange: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: { value }, set: { onChange($0) })
    }

    /// Initializes a SwiftUI `Binding`.
    ///
    /// Use instead of the built-in SwiftUI provided initializer for two reasons:
    /// - Accepts a value for the getter instead of a closure
    /// - Allows for `.bind` which is more declarative than `.init`
    ///
    /// Example:
    /// ```
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
    public static func bind(to value: Value, onChange: ((Value) -> Void)?) -> Binding<Value> {
        guard let onChange: (Value) -> Void
        else { return .constant(value) }
        return bind(to: value, onChange: onChange)
    }
}
