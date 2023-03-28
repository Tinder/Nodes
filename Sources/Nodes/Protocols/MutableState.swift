//
//  MutableState.swift
//  Nodes
//
//  Created by Seppe Snoeck on 21/10/22.
//

public protocol MutableState {

    /// Mutate an instance with a new value.
    ///
    /// - Parameter mutation: The mutation itself.
    ///
    /// Example of mutating a struct variable:
    /// ```
    /// var example: Example = .init()
    ///
    /// example.apply {
    ///    $0.exampleProperty = 23
    ///    $0.anotherExampleProperty = 100
    /// }
    ///
    /// print(example)
    /// ```
    mutating func apply(_ mutation: (inout Self) throws -> Void) rethrows

    /// Create a new instance with the desired changes.
    ///
    /// - Parameter mutation: The mutation itself.
    ///
    /// Example of mutating a struct constant:
    /// ```
    /// let example: Example = .init()
    ///
    /// print(example.with {
    ///    $0.exampleProperty = 23
    ///    $0.anotherExampleProperty = 100
    /// })
    /// ```
    func with(_ mutation: (inout Self) throws -> Void) rethrows -> Self
}

extension MutableState {

    public mutating func apply(_ mutation: (inout Self) throws -> Void) rethrows {
        self = try with(mutation)
    }

    public func with(_ mutation: (inout Self) throws -> Void) rethrows -> Self {
        var value: Self = self
        try mutation(&value)
        return value
    }
}
