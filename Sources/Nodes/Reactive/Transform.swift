//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if canImport(Combine)

import Combine

/**
 * ``Transform`` represents a transformation from an `Input` value to an `Output` value.
 *
 * Protocol extensions are defined for using ``Transform`` conforming instances with
 * [Combine](https://developer.apple.com/documentation/combine) publishers.
 */
public protocol Transform {

    /// The input type.
    associatedtype Input

    /// The output type.
    associatedtype Output

    /// A method containing the transformation.
    ///
    /// - Parameter value: The input value.
    ///
    /// - Returns: The output value.
    func callAsFunction(_ value: Input) -> Output
}

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers.Map {

    /// Creates a publisher that maps all elements from the upstream publisher with a provided transformation.
    ///
    /// See [Publishers.Map](https://developer.apple.com/documentation/combine/publishers/map) for more information.
    ///
    /// - Parameters:
    ///   - upstream: The publisher from which this publisher receives elements.
    ///   - transform: The transformation that maps elements from the upstream publisher.
    public init<T: Transform>(
        upstream: Upstream,
        transform: T
    ) where T.Input == Upstream.Output, T.Output == Output {
        self.init(upstream: upstream) { transform($0) }
    }
}

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publisher {

    /// Transforms all elements from the upstream publisher with a provided transformation.
    ///
    /// See [map(_:)](https://developer.apple.com/documentation/combine/publisher/map(_:)-99evh) for more information.
    ///
    /// - Parameter transform: The transformation that maps elements from the upstream publisher.
    ///
    /// - Returns: A publisher that uses the provided transformation to map elements from the upstream publisher to
    ///   new elements that it then publishes.
    public func map<T: Transform>(
        _ transform: T
    ) -> Publishers.Map<Self, T.Output> where T.Input == Output {
        Publishers.Map(upstream: self, transform: transform)
    }
}

#endif
