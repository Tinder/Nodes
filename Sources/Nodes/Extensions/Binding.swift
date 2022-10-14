//
//  Binding.swift
//  Nodes
//
//  Created by Seppe Snoeck on 11/10/22.
//

import SwiftUI

@available(macOS 10.15, *)
extension Binding {

    public static func binding(to value: Value, onChange: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: { value }, set: { onChange($0) })
    }

    public static func binding(to value: Value, onChange: ((Value) -> Void)?) -> Binding<Value> {
        guard let onChange: (Value) -> Void = onChange
        else { return .constant(value) }
        return binding(to: value, onChange: onChange)
    }
}
