//
//  ViewControllable.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

public protocol ViewControllable: AnyObject {

    @discardableResult
    func withModalStyle(_ style: UIViewController.ModalStyle) -> Self

    func present(
        _ viewController: ViewControllable,
        withModalStyle modalStyle: UIViewController.ModalStyle,
        animated: Bool,
        completion: (() -> Void)?
    )

    func dismiss(
        _ viewController: ViewControllable,
        animated: Bool,
        completion: (() -> Void)?
    )

    func willMove(toParent viewController: ViewControllable?)
    func didMove(toParent viewController: ViewControllable?)

    func addChild(_ viewController: ViewControllable)
    func removeChild(_ viewController: ViewControllable)

    func contain(_ viewController: ViewControllable)
    func contain(_ viewController: ViewControllable, in frame: CGRect)

    func contain(
        _ viewController: ViewControllable,
        in frame: CGRect,
        with autoresizingMask: UIView.AutoresizingMask
    )

    func contain(_ viewController: ViewControllable, in view: UIView)
    func contain(_ viewController: ViewControllable, constraints: (_ view: UIView) -> [NSLayoutConstraint])

    func uncontain(_ viewController: ViewControllable)

    // swiftlint:disable:next identifier_name
    func _asUIViewController() -> UIViewController
}

extension ViewControllable {

    public func present(
        _ viewController: ViewControllable,
        withModalStyle modalStyle: UIViewController.ModalStyle,
        animated: Bool
    ) {
        present(viewController, withModalStyle: modalStyle, animated: animated, completion: nil)
    }

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
