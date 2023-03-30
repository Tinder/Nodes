//
//  MutableState.swift
//  Nodes
//
//  Created by Seppe Snoeck on 21/10/22.
//

/**
 * ``MutableState`` specifies a method for applying a mutation to an instance and a method for creating a new
 * instance with a mutation. Protocol extension methods are defined and provide default implementations.
 *
 * ``MutableState`` may also be used with [Combine](https://developer.apple.com/documentation/combine) in
 * the following ways:
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
 *
 * The above examples assume that the `Example` struct definition declares conformance to ``MutableState``.
 */
public protocol MutableState {

    /// Applies a mutation to an instance.
    ///
    /// - Parameter mutation: The closure in which properties are mutated.
    ///
    /// Example of mutating a struct variable:
    /// ```swift
    /// var example: Example = .init()
    ///
    /// example.apply {
    ///    $0.exampleProperty = 23
    ///    $0.anotherExampleProperty = 100
    /// }
    ///
    /// print(example)
    /// ```
    mutating func apply(_ changes: (inout Self) throws -> Void) rethrows

    /// Creates a new instance with a mutation.
    ///
    /// - Parameter mutation: The closure in which properties are mutated.
    ///
    /// Example of mutating a struct constant:
    /// ```swift
    /// let example: Example = .init()
    ///
    /// print(example.with {
    ///    $0.exampleProperty = 23
    ///    $0.anotherExampleProperty = 100
    /// })
    /// ```
    func applying(_ changes: (inout Self) throws -> Void) rethrows -> Self
}

extension MutableState {

    public mutating func apply(_ changes: (inout Self) throws -> Void) rethrows {
        self = try applying(changes)
    }

    public func applying(_ changes: (inout Self) throws -> Void) rethrows -> Self {
        var value: Self = self
        try changes(&value)
        return value
    }
}
