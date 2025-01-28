//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

extension UIViewController: ViewControllable {

    /// Applies the given ``ModalStyle``.
    ///
    /// - Parameter modalStyle: The ``ModalStyle`` to apply.
    ///
    /// - Returns: The `self` instance with the given ``ModalStyle`` applied.
    @discardableResult
    public func withModalStyle(_ modalStyle: ModalStyle) -> Self {
        switch modalStyle.behavior {
        case .cover:
            modalPresentationStyle = .fullScreen
        case .overlay:
            modalPresentationStyle = .overFullScreen
        #if !os(tvOS)
        case .page:
            modalPresentationStyle = .pageSheet
        case .form:
            modalPresentationStyle = .formSheet
        #endif
        case .custom:
            modalPresentationStyle = .none
        }
        isModalInPresentation = true
        modalStyle.configuration.forEach { $0(self) }
        return self
    }

    /// Presents a ``ViewControllable`` instance.
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: The ``ViewControllable`` instance to present.
    ///   - modalStyle: The ``ModalStyle`` to apply to the ``ViewControllable`` instance before presenting.
    ///   - animated: A Boolean value specifying whether presentation is animated.
    ///   - completion: An optional closure to execute when the presentation is finished.
    ///
    ///     The closure has no arguments and returns `Void`.
    public func present(
        _ viewControllerToPresent: ViewControllable,
        withModalStyle modalStyle: ModalStyle,
        animated flag: Bool,
        completion: (() -> Void)?
    ) {
        let viewController: UIViewController = viewControllerToPresent._asUIViewController()
        present(viewController.withModalStyle(modalStyle), animated: flag, completion: completion)
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
        let viewController: UIViewController = viewController._asUIViewController()
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

    // swiftlint:disable identifier_name

    /// Returns `self` as a ``UIViewController``.
    ///
    /// - Returns: The `self` instance as a ``UIViewController``.
    public func _asUIViewController() -> UIViewController {
        self
    }

    // swiftlint:enable identifier_name
}

#endif
