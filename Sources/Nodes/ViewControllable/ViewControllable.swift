//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

#if !canImport(UIKit) || os(watchOS)

/// @mockable
@preconcurrency
@MainActor
public protocol ViewControllable: AnyObject {}

#endif
