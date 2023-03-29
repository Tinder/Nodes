//
//  MutableState.swift
//  Nodes
//
//  Created by Seppe Snoeck on 21/10/22.
//

/**
 * ``MutableState`` specifies methods for applying a mutation to an instance and creating a
 * new instance with a mutation.
 *
 * Protocol extension methods are defined and provide default implementations.
 *
 * ``MutableState`` may be used with [Combine](https://developer.apple.com/documentation/combine)
 * in the following ways.
 *
 * Example of publishing a single value when multiple properties are mutated:
 * ```swift
 * extension CurrentValueSubject where Output: MutableState {
 *
 *     func apply(_ mutation: (inout Output) throws -> Void) rethrows {
 *         value = try value.with(mutation)
 *     }
 * }
 * 
 * let subject: CurrentValueSubject<Example, Never> = .init(Example())
 *
 * subject.apply {
 *     $0.exampleProperty = 23
 *     $0.anotherExampleProperty = 100
 * }
 * ```
 *
 * Example of transforming emitted constant values:
 * ```swift
 * let publisher: AnyPublisher<Example, Never> = ...
 *
 * publisher.map { example in
 *     example.with {
 *         $0.exampleProperty = 23
 *         $0.anotherExampleProperty = 100
 *     }
 * }
 * ```
 */
public protocol MutableState {

    /// Applies a mutation to an instance.
    ///
    /// - Parameter mutation: The closure in which properties are mutated.
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

    /// Creates a new instance with a mutation.
    ///
    /// - Parameter mutation: The closure in which properties are mutated.
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
