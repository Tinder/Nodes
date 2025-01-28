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

// swiftlint:disable:next file_types_order
extension AnyCancellable: Cancellable {}

#endif

/**
 * A Nodes application can use [Combine](https://developer.apple.com/documentation/combine), or any other
 * reactive library, by providing a type supporting subscription cancellation that conforms to Nodes'
 * ``Cancellable`` protocol.
 *
 * An extension is defined that provides ``Cancellable`` protocol conformance for [AnyCancellable](
 * https://developer.apple.com/documentation/combine/anycancellable
 * ).
 */
public protocol Cancellable: AnyObject, Hashable {

    /// Cancels the ``Cancellable`` subscription.
    func cancel()
}
