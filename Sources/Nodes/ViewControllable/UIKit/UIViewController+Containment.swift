//
//  UIViewController+Containment.swift
//  Nodes
//
//  Created by Sam Marshall on 2/13/23.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIViewController {

    /// Contains the given ``ViewControllable`` instance with the layout provided by the given closure.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
    ///   - layout: The closure providing the layout.
    ///   - subview: The view to enclose in the parent view
    ///
    ///     The closure has the following arguments:
    ///     | view    | The containing view. |
    ///     | subview | The subview. |
    ///
    ///     The closure returns an array of layout constraints.
    @discardableResult
    public func contain<T>(_ viewController: ViewControllable,
                           layout: (_ view: UIView) -> T,
                           _ subview: UIView) -> T
    {
        addChild(viewController)
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        let layout: T = layout(view)
        viewController.didMove(toParent: self)
        return layout
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
        viewController.didMove(toParent: self)
    }
}

#endif
