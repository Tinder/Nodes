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
    ///     The closure has no arguments and returns ``Void``.
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
    ///     The closure has no arguments and returns ``Void``.
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

    /// Called just before the ``ViewControllable`` instance is added or removed from a container
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The parent ``ViewControllable`` instance, or `nil` if there is no parent.
    public func willMove(toParent viewController: ViewControllable?) {
        let viewController: UIViewController? = viewController?._asUIViewController()
        willMove(toParent: viewController)
    }

    /// Called after the ``ViewControllable`` instance is added or removed from a container
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The parent ``ViewControllable`` instance, or `nil` if there is no parent.
    public func didMove(toParent viewController: ViewControllable?) {
        let viewController: UIViewController? = viewController?._asUIViewController()
        didMove(toParent: viewController)
    }

    /// Adds the given ``ViewControllable`` instance as a child.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to be added as a child.
    public func addChild(_ viewController: ViewControllable) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard !children.contains(viewController)
        else { return }
        addChild(viewController)
    }

    /// Removes the given ``ViewControllable`` instance from its parent.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to be removed from its parent.
    public func removeChild(_ viewController: ViewControllable) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard children.contains(viewController)
        else { return }
        viewController.removeFromParent()
    }

    /// Contains the given ``ViewControllable`` instance within the entire bounds of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to contain.
    public func contain(_ viewController: ViewControllable) {
        contain(viewController, in: view.bounds)
    }

    /// Contains the given ``ViewControllable`` instance within the given frame of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
    ///   - frame: The frame in which to contain the ``ViewControllable`` instance.
    public func contain(_ viewController: ViewControllable, in frame: CGRect) {
        contain(viewController, in: frame, with: [.flexibleWidth, .flexibleHeight])
    }

    /// Contains the given ``ViewControllable`` instance within the given frame of the parent
    /// ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
    ///   - frame: The frame in which to contain the ``ViewControllable`` instance.
    ///   - autoresizingMask: The autoresizing mask to apply to the ``ViewControllable`` instance.
    public func contain(
        _ viewController: ViewControllable,
        in frame: CGRect,
        with autoresizingMask: UIView.AutoresizingMask
    ) {
        let subview: UIView = viewController._asUIViewController().view
        addChild(viewController)
        subview.translatesAutoresizingMaskIntoConstraints = true
        subview.frame = frame
        subview.autoresizingMask = autoresizingMask
        view.addSubview(subview)
        viewController.didMove(toParent: self)
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
        subview.translatesAutoresizingMaskIntoConstraints = true
        subview.frame = view.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(subview)
        viewController.didMove(toParent: self)
    }

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
    public func contain(_ viewController: ViewControllable, constraints: (_ view: UIView) -> [NSLayoutConstraint]) {
        let subview: UIView = viewController._asUIViewController().view
        addChild(viewController)
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        NSLayoutConstraint.activate(constraints(subview))
        viewController.didMove(toParent: self)
    }

    /// Uncontains the given ``ViewControllable`` instance.
    ///
    /// - Parameter viewController: The ``ViewControllable`` instance to uncontain.
    public func uncontain(_ viewController: ViewControllable) {
        let subview: UIView = viewController._asUIViewController().view
        guard subview.isDescendant(of: view)
        else { return }
        viewController.willMove(toParent: nil)
        subview.removeFromSuperview()
        removeChild(viewController)
    }

    /// Returns `self` as a ``UIViewController``.
    ///
    /// - Returns: The `self` instance as a ``UIViewController``.
    public func _asUIViewController() -> UIViewController { // swiftlint:disable:this identifier_name
        self
    }
}

#endif
