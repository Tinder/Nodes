//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if !canImport(UIKit) || os(watchOS)

/// @mockable
@preconcurrency
@MainActor
public protocol ViewControllable: AnyObject {}

#endif
