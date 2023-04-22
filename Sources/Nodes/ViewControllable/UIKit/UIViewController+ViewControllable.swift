//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIViewController: ViewControllable {

    /// Presents a ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to present.
    ///   - modalStyle: The ``ModalStyle`` to apply to the ``ViewControllable`` instance before presenting.
    ///   - animated: A Boolean value specifying whether presentation is animated.
    ///   - completion: An optional closure to execute when the presentation is finished.
    ///
    ///     The closure has no arguments and returns `Void`.
    public func present(
        _ viewController: ViewControllable,
        withModalStyle modalStyle: ModalStyle,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let viewController: UIViewController = viewController._asUIViewController()
        present(viewController.withModalStyle(modalStyle), animated: animated, completion: completion)
    }

    /// Dismisses a ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to dismiss.
    ///   - animated: A Boolean value specifying whether dismissal is animated.
    ///   - completion: An optional closure to execute when the dismissal is finished.
    ///
    ///     The closure has no arguments and returns `Void`.
    public func dismiss(
        _ viewController: ViewControllable,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard viewController === presentedViewController
        else { return completion?() ?? () }
        dismiss(animated: animated, completion: completion)
    }

    /// Contains the given ``ViewControllable`` instance within the entire bounds of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to contain.
    public func contain(_ viewController: ViewControllable) {
        contain(viewController, in: view)
    }

    /// Uncontains the given ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to uncontain.
    public func uncontain(_ viewController: ViewControllable) {
        let viewController: UIViewController = viewController._asUIViewController()
        let subview: UIView = viewController.view
        guard subview.isDescendant(of: view)
        else { return }
        viewController.willMove(toParent: nil)
        subview.removeFromSuperview()
        _removeChild(viewController)
    }

    /// Returns `self` as a ``UIViewController``.
    ///
    /// - Returns: The `self` instance as a ``UIViewController``.
    public func _asUIViewController() -> UIViewController { // swiftlint:disable:this identifier_name
        self
    }
}

#endif
