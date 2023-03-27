//
//  MutableState.swift
//  Nodes
//
//  Created by Seppe Snoeck on 21/10/22.
//

public protocol MutableState {

    /// Mutate an instance with a new value.
    ///
    /// - Parameter mutation: The mutation itself
    ///
    /// Example:
    /// Send a new value on a CurrentValueSubject by mutating the current value:
    /// ```
    /// let subject: CurrentValueSubject<Example, Never> = .init(Example())
    /// subject.apply { $0.exampleProperty = 23 }
    /// ```
    ///
    /// Mutate a struct variable:
    /// ```
    /// var example: Example = .init()
    /// example.apply { $0.exampleProperty = 23 }
    /// ```
    mutating func apply(_ mutation: (inout Self) throws -> Void) rethrows

    /// Create a new instance with the wanted changes.
    ///
    /// - Parameter mutation: The mutation itself
    ///
    /// Example:
    /// Mutate a struct constant:
    /// ```
    /// let publisher: AnyPublisher<Example, Never> = ...
    ///
    /// publisher.map { example in
    ///    example.with { $0.exampleProperty = 23 }
    /// }
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
