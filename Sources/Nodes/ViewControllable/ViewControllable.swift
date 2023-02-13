//
//  ViewControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * The interface used for injecting a user interface into a `Flow` instance to limit the available API,
 * to avoid the use of UI frameworks within the `Flow` instance and to facilitate testing.
 */
public protocol ViewControllable: AnyObject {

    /// Applies the given ``ModalStyle``.
    ///
    /// - Parameter modalStyle: The ``ModalStyle`` to apply.
    ///
    /// - Returns: The `self` instance with the given ``ModalStyle`` applied.
    @discardableResult
    func withModalStyle(_ style: ModalStyle) -> Self

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

    /// Called just before the ``ViewControllable`` instance is added or removed from a container
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The parent ``ViewControllable`` instance, or `nil` if there is no parent.
    func willMove(toParent viewController: ViewControllable?)

    /// Called after the ``ViewControllable`` instance is added or removed from a container
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The parent ``ViewControllable`` instance, or `nil` if there is no parent.
    func didMove(toParent viewController: ViewControllable?)

    /// Adds the given ``ViewControllable`` instance as a child.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to be added as a child.
    func addChild(_ viewController: ViewControllable)

    /// Removes the given ``ViewControllable`` instance from its parent.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to be removed from its parent.
    func removeChild(_ viewController: ViewControllable)

    /// Contains the given ``ViewControllable`` instance within the entire bounds of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to contain.
    func contain(_ viewController: ViewControllable)

    /// Contains the given ``ViewControllable`` instance within the given frame of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
    ///   - frame: The frame in which to contain the ``ViewControllable`` instance.
    func contain(_ viewController: ViewControllable, in frame: CGRect)

    /// Contains the given ``ViewControllable`` instance within the given frame of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
    ///   - frame: The frame in which to contain the ``ViewControllable`` instance.
    ///   - autoresizingMask: The autoresizing mask to apply to the ``ViewControllable`` instance.
    func contain(
        _ viewController: ViewControllable,
        in frame: CGRect,
        with autoresizingMask: UIView.AutoresizingMask
    )

    /// Contains the given ``ViewControllable`` instance with the layout constraints provided by the given closure.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
    ///   - constraints: The closure providing the layout constraints.
    ///
    ///     The closure has the following arguments:
    ///     | Name | Description                                  |
    ///     | ---- | -------------------------------------------- |
    ///     | view | The view on which to add layout constraints. |
    ///
    ///     The closure returns an array of layout constraints.
    func contain(_ viewController: ViewControllable, constraints: (_ view: UIView) -> [NSLayoutConstraint])

    /// Uncontains the given ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to uncontain.
    func uncontain(_ viewController: ViewControllable)

    /// Returns `self` as a ``UIViewController``.
    ///
    /// - Returns: The `self` instance as a ``UIViewController``.
    func _asUIViewController() -> UIViewController // swiftlint:disable:this identifier_name
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

#else

public protocol ViewControllable: AnyObject {}

#endif
