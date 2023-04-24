//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

// swiftlint:disable period_spacing

extension UIViewController {

    /// Contains the given ``ViewControllable`` instance with the layout provided by the given closure.
    ///
    /// - Parameters:
    ///   - viewController: The ``ViewControllable`` instance to contain.
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
        _ viewController: ViewControllable,
        layout: (_ view: UIView, _ subview: UIView) -> T
    ) -> T {
        let viewController: UIViewController = viewController._asUIViewController()
        _addChild(viewController)
        let subview: UIView = viewController.view
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        let layout: T = layout(view, subview)
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
        let viewController: UIViewController = viewController._asUIViewController()
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
        let viewController: UIViewController = viewController._asUIViewController()
        guard !children.contains(viewController)
        else { return }
        addChild(viewController)
    }

    // swiftlint:disable:next identifier_name
    internal func _removeChild(_ viewController: UIViewController) {
        let viewController: UIViewController = viewController._asUIViewController()
        guard children.contains(viewController)
        else { return }
        viewController.removeFromParent()
    }
}

#endif

// swiftlint:enable period_spacing
