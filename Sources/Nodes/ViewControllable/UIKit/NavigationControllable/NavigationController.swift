//
//  NavigationController.swift
//  Nodes
//
//  Created by Christopher Fuller on 12/2/22.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

open class NavigationController: UINavigationController, UINavigationControllerDelegate {

    public typealias DidPopViewControllersCallback = ([UIViewController]) -> Void

    private var didPopViewControllers: DidPopViewControllersCallback?

    private var previousChildren: [UIViewController] = []

    public func onPopViewControllers(didPopViewControllers: DidPopViewControllersCallback? = nil) {
        self.didPopViewControllers = didPopViewControllers
        delegate = didPopViewControllers == nil ? nil : self
    }

    // MARK: - UINavigationControllerDelegate

    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        defer { previousChildren = children }
        guard let didPopViewControllers: DidPopViewControllersCallback = didPopViewControllers
        else { return }
        let endIndex: Int = previousChildren.count - 1
        guard let index: Int = previousChildren.firstIndex(where: { $0 === viewController }),
              index < endIndex
        else { return }
        let startIndex: Int = index + 1
        didPopViewControllers(Array(previousChildren[startIndex...endIndex]))
    }
}

#endif
