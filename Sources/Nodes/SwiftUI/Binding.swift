//
//  Binding.swift
//  Nodes
//
//  Created by Seppe Snoeck on 11/10/22.
//

import SwiftUI

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Binding {

    /// A Binding factory to be used instead of the built-in SwiftUI provided initializer for two reasons:
    /// - Accepts a value for the getter instead of a closure
    /// - Allows for `.binding` which is more declarative than `.init`
    ///
    /// Example:
    /// ```
    /// var body: some View {
    ///     WithViewState(viewState) { viewState in
    ///         Slider(value: .binding(to: viewState.sliderValue, onChange: receiver?.didChangeSliderValue), in: 1...100)
    ///     }
    /// }
    /// ```AbstractPresentableContext

    ///
    /// - Parameters:
    ///   - value: A value for the getter of the binding.
    ///   - onChange: An escaping closure for the setter of the binding.
    ///
    /// - Returns: A SwiftUI Binding instance.
    public static func binding(to value: Value, onChange: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: { value }, set: { onChange($0) })
    }

    /// A Binding factory to be used instead of the built-in SwiftUI provided initializer for two reasons:
    /// - Accepts a value for the getter instead of a closure
    /// - Allows for `.binding` which is more declarative than `.init`
    ///
    /// Example:
    /// ```
    /// var body: some View {
    ///     WithViewState(viewState) { viewState in
    ///         Slider(value: .binding(to: viewState.sliderValue, onChange: receiver?.didChangeSliderValue), in: 1...100)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - value: A value for the getter of the binding.
    ///   - onChange: An optional closure for the setter of the binding.
    ///
    /// - Returns: A SwiftUI Binding instance.
    public static func binding(to value: Value, onChange: ((Value) -> Void)?) -> Binding<Value> {
        guard let onChange: (Value) -> Void = onChange
        else { return .constant(value) }
        return binding(to: value, onChange: onChange)
    }
}
