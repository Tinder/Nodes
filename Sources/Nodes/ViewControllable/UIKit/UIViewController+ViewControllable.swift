//
//  UIViewController+ViewControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIViewController: ViewControllable {

    public func present(
        _ viewController: ViewControllable,
        withModalStyle modalStyle: ModalStyle,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let viewController: UIViewController = viewController._asUIViewController()
        present(viewController.withModalStyle(modalStyle), animated: animated, completion: completion)
    }

    public func dismiss(
        _ viewController: ViewControllable,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard viewController === presentedViewController
        else { return }
        dismiss(animated: animated, completion: completion)
    }

    public func willMove(toParent viewController: ViewControllable?) {
        let viewController: UIViewController? = viewController?._asUIViewController()
        willMove(toParent: viewController)
    }

    public func didMove(toParent viewController: ViewControllable?) {
        let viewController: UIViewController? = viewController?._asUIViewController()
        didMove(toParent: viewController)
    }

    public func addChild(_ viewController: ViewControllable) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard !children.contains(viewController)
        else { return }
        addChild(viewController)
    }

    public func removeChild(_ viewController: ViewControllable) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard children.contains(viewController)
        else { return }
        viewController.removeFromParent()
    }

    public func contain(_ viewController: ViewControllable) {
        contain(viewController, in: view.bounds)
    }

    public func contain(_ viewController: ViewControllable, in frame: CGRect) {
        contain(viewController, in: frame, with: [.flexibleWidth, .flexibleHeight])
    }

    public func contain(
        _ viewController: ViewControllable,
        in frame: CGRect,
        with autoresizingMask: UIView.AutoresizingMask
    ) {
        let subview: UIView = viewController._asUIViewController().view
        viewController.willMove(toParent: self)
        addChild(viewController)
        subview.translatesAutoresizingMaskIntoConstraints = true
        subview.frame = frame
        subview.autoresizingMask = autoresizingMask
        view.addSubview(subview)
        viewController.didMove(toParent: self)
    }

    public func contain(_ viewController: ViewControllable, in view: UIView) {
        guard view.isDescendant(of: self.view)
        else { return }
        let subview: UIView = viewController._asUIViewController().view
        viewController.willMove(toParent: self)
        addChild(viewController)
        subview.translatesAutoresizingMaskIntoConstraints = true
        subview.frame = view.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(subview)
        viewController.didMove(toParent: self)
    }

    public func contain(_ viewController: ViewControllable, constraints: (_ view: UIView) -> [NSLayoutConstraint]) {
        let subview: UIView = viewController._asUIViewController().view
        viewController.willMove(toParent: self)
        addChild(viewController)
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        NSLayoutConstraint.activate(constraints(subview))
        viewController.didMove(toParent: self)
    }

    public func uncontain(_ viewController: ViewControllable) {
        let subview: UIView = viewController._asUIViewController().view
        guard subview.isDescendant(of: view)
        else { return }
        viewController.willMove(toParent: nil)
        subview.removeFromSuperview()
        removeChild(viewController)
        viewController.didMove(toParent: nil)
    }

    // swiftlint:disable:next identifier_name
    public func _asUIViewController() -> UIViewController {
        self
    }
}

#endif
