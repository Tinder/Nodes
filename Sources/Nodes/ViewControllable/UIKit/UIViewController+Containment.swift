//
//  UIViewController+Containment.swift.swift
//  Nodes
//
//  Created by Sam Marshall on 2/13/23.
//

import UIKit

extension UIViewController {

    /// Contains the given ``ViewControllable`` instance with the layout constraints provided by the given closure.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
    ///   - layout: The closure providing the layout constraints.
    ///
    ///     The closure has the following arguments:
    ///     | view | The view on which to add layout constraints. |
    ///
    ///     The closure returns an array of layout constraints.
    @discardableResult
    func contain<T>(_ viewController: ViewControllable, layout: (_ view: UIView) -> T) -> T {
        let subview: UIView = viewController._asUIViewController().view
        addChild(viewController)
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        let layout: T = layout(view)
        viewController.didMove(toParent: self)
        return layout
    }

}
