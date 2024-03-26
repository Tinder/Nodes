// swiftlint:disable:this file_name
//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * The interface used for injecting a user interface into a `Flow` instance to limit the available API,
 * to avoid the use of UI frameworks within the `Flow` instance and to facilitate testing.
 */
/// @mockable
@preconcurrency
@MainActor
public protocol ViewControllable: AnyObject {

    /// Applies the given ``ModalStyle``.
    ///
    /// - Parameter modalStyle: The ``ModalStyle`` to apply.
    ///
    /// - Returns: The `self` instance with the given ``ModalStyle`` applied.
    @discardableResult
    func withModalStyle(_ modalStyle: ModalStyle) -> Self

    /// Presents a ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to present.
    ///   - modalStyle: The ``ModalStyle`` to apply to the ``ViewControllable`` instance before presenting.
    ///   - animated: A Boolean value specifying whether presentation is animated.
    ///   - completion: An optional closure to execute when the presentation is finished.
    ///
    ///     The closure has no arguments and returns `Void`.
    func present(
        _ viewController: ViewControllable,
        withModalStyle modalStyle: ModalStyle,
        animated: Bool,
        completion: (() -> Void)?
    )

    /// Dismisses a ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to dismiss.
    ///   - animated: A Boolean value specifying whether dismissal is animated.
    ///   - completion: An optional closure to execute when the dismissal is finished.
    ///
    ///     The closure has no arguments and returns `Void`.
    func dismiss(
        _ viewController: ViewControllable,
        animated: Bool,
        completion: (() -> Void)?
    )

    /// Contains the given ``ViewControllable`` instance within the entire bounds of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to contain.
    func contain(_ viewController: ViewControllable)

    /// Uncontains the given ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to uncontain.
    func uncontain(_ viewController: ViewControllable)

    // swiftlint:disable identifier_name

    /// Returns `self` as a ``UIViewController``.
    ///
    /// - Returns: The `self` instance as a ``UIViewController``.
    func _asUIViewController() -> UIViewController

    // swiftlint:enable identifier_name
}

extension ViewControllable {

    /// Presents a ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to present.
    ///   - modalStyle: The ``ModalStyle`` to apply to the ``ViewControllable`` instance before presenting.
    ///   - animated: A Boolean value specifying whether presentation is animated.
    public func present(
        _ viewController: ViewControllable,
        withModalStyle modalStyle: ModalStyle,
        animated: Bool
    ) {
        present(viewController, withModalStyle: modalStyle, animated: animated, completion: nil)
    }

    /// Dismisses a ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to dismiss.
    ///   - animated: A Boolean value specifying whether dismissal is animated.
    public func dismiss(
        _ viewController: ViewControllable,
        animated: Bool
    ) {
        dismiss(viewController, animated: animated, completion: nil)
    }
}

#endif
