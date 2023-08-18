//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

// swiftlint:disable period_spacing

extension UIViewController {

    /// Contains the view of the given ``UIViewController`` instance within the containing ``UIViewController``
    /// instance using a layout provided by the given closure.
    ///
    /// - Parameters:
    ///   - viewController: The ``UIViewController`` instance providing the subview to contain.
    ///   - layout: The closure providing the layout.
    ///
    /// - Returns: The output of the layout (can be `Void`).
    ///
    ///     The closure has the following arguments:
    ///     | view    | The containing view. |
    ///     | subview | The subview.         |
    ///
    ///     The closure may return any type such as an array of layout constraints to
    ///     be activated (or can simply return `Void`).
    @discardableResult
    public func contain<T>(
        _ viewController: UIViewController,
        layout: (_ view: UIView, _ subview: UIView) -> T
    ) -> T {
        _addChild(viewController)
        let subview: UIView = viewController.view
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        let layout: T = layout(view, subview)
        viewController.didMove(toParent: self)
        return layout
    }

    /// Contains the view of the given ``UIViewController`` instance within the given view of the containing
    /// ``UIViewController`` instance.
    ///
    /// - Parameters:
    ///   - viewController: The ``UIViewController`` instance providing the subview to contain.
    ///   - view: The containing view in which to contain the subview.
    public func contain(_ viewController: UIViewController, in view: UIView) {
        guard view.isDescendant(of: self.view)
        else { return }
        _addChild(viewController)
        let subview: UIView = viewController.view
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            subview.widthAnchor.constraint(equalTo: view.widthAnchor),
            subview.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        viewController.didMove(toParent: self)
    }

    // swiftlint:disable:next identifier_name
    internal func _addChild(_ viewController: UIViewController) {
        guard !children.contains(viewController)
        else { return }
        addChild(viewController)
    }

    // swiftlint:disable:next identifier_name
    internal func _removeChild(_ viewController: UIViewController) {
        guard children.contains(viewController)
        else { return }
        viewController.removeFromParent()
    }
}

#endif

// swiftlint:enable period_spacing
