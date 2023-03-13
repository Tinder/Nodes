//
//  UIViewController+ViewControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
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

    /// Contains the given ``ViewControllable`` instance within the given view of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
    ///   - view: The view in which to contain the ``ViewControllable`` instance.
    public func contain(_ viewController: ViewControllable, in view: UIView) {
        guard view.isDescendant(of: self.view)
        else { return }
        let subview: UIView = viewController._asUIViewController().view
        addChild(viewController)
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.heightAnchor.constraint(equalTo: view.heightAnchor),
            subview.widthAnchor.constraint(equalTo: view.widthAnchor),
            subview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        viewController._asUIViewController().didMove(toParent: self)
    }

    /// Uncontains the given ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to uncontain.
    public func uncontain(_ viewController: ViewControllable) {
        let subview: UIView = viewController._asUIViewController().view
        guard subview.isDescendant(of: view)
        else { return }
        viewController._asUIViewController().willMove(toParent: nil)
        subview.removeFromSuperview()
        removeChild(viewController)
    }

    /// Returns `self` as a ``UIViewController``.
    ///
    /// - Returns: The `self` instance as a ``UIViewController``.
    public func _asUIViewController() -> UIViewController { // swiftlint:disable:this identifier_name
        self
    }

    /// Called just before the ``ViewControllable`` instance is added or removed from a container
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The parent ``ViewControllable`` instance, or `nil` if there is no parent.
    private func willMove(toParent viewController: ViewControllable?) {
        let viewController: UIViewController? = viewController?._asUIViewController()
        willMove(toParent: viewController)
    }

    /// Called after the ``ViewControllable`` instance is added or removed from a container
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The parent ``ViewControllable`` instance, or `nil` if there is no parent.
    private func didMove(toParent viewController: ViewControllable?) {
        let viewController: UIViewController? = viewController?._asUIViewController()
        didMove(toParent: viewController)
    }

    /// Adds the given ``ViewControllable`` instance as a child.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to be added as a child.
    private func addChild(_ viewController: ViewControllable) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard !children.contains(viewController)
        else { return }
        addChild(viewController)
    }

    /// Removes the given ``ViewControllable`` instance from its parent.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to be removed from its parent.
    private func removeChild(_ viewController: ViewControllable) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard children.contains(viewController)
        else { return }
        viewController.removeFromParent()
    }
}

#endif
