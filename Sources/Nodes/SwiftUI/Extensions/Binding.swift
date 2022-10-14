//
//  Binding.swift
//  Nodes
//
//  Created by Seppe Snoeck on 11/10/22.
//

import SwiftUI

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Binding {

    /// Create a Binding for a value with a async callback listening for a change for the passed value.
    /// - Parameters:
    ///   - value: The value you want to create a Binding for.
    ///   - onChange: The async callback listinging for a change of the passed value.
    /// - Returns: Returns a SwiftUI Binding for the passed in value.
    public static func binding(to value: Value, onChange: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: { value }, set: { onChange($0) })
    }

    /// Create a Binding for a value with an optional callback listening for a change for the passed value.
    /// - Parameters:
    ///   - value: The value you want to create a Binding for.
    ///   - onChange: The optional callback listinging for a change of the passed value
    /// - Returns: Returns a SwiftUI Binding for the passed in value
    public static func binding(to value: Value, onChange: ((Value) -> Void)?) -> Binding<Value> {
        guard let onChange: (Value) -> Void = onChange
        else { return .constant(value) }
        return binding(to: value, onChange: onChange)
    }
}
