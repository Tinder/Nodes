//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

#if canImport(UIKit) && !os(watchOS)

import UIKit

/**
 * ``NavigationController`` is a [`UINavigationController`](
 * https://developer.apple.com/documentation/uikit/uinavigationcontroller
 * ) subclass to be used with Nodes.
 *
 * ``NavigationController`` provides a necessary callback allowing `Flow` instances to be detached when their view
 * controllers are removed from the navigation stack as a result of user interactions (such as when long pressing the
 * back button of the navigation controller interface).
 *
 * > Important: ``NavigationController`` must be used instead of [`UINavigationController`](
 * https://developer.apple.com/documentation/uikit/uinavigationcontroller
 * ) with Nodes.
 *
 * Under normal circumstances, user interactions do not directly cause ``ViewControllable`` instances to
 * be dismissed, for example when simply tapping a button. To dismiss a ``ViewControllable`` instance in these
 * situations, the `Context` instance will be informed of the button tap which then informs the `Flow` instance
 * to initiate the dismissal. The `Flow` instance retrieves the appropriate child `Flow` instance (by type) and,
 * only after the dismissal is complete, detaches the child `Flow` instance using the
 * ``AbstractFlow/detach(ending:)`` method.
 *
 * However, in some cases, user interactions can directly cause ``ViewControllable`` instances to be dismissed,
 * for example when interacting with [`UINavigationController`](
 * https://developer.apple.com/documentation/uikit/uinavigationcontroller
 * ) (from `UIKit`). By long pressing the back button of the navigation controller, a user may navigate backward
 * to any point in the navigation history, which directly causes one or more ``ViewControllable`` instances to be
 * immediately removed from the navigation stack. In these situations, to detach `Flow` instances corresponding to
 * already dismissed ``ViewControllable`` instances, the `Context` instance will be informed of the dismissal
 * (and be provided the ``ViewControllable`` instances) which then informs the `Flow` instance to perform
 * the detachment only.
 *
 * Example of `Flow` implementation:
 * ```swift
 * func detach(endingFlowsFor viewControllers: [ViewControllable]) {
 *     detach(endingSubFlowsOfType: ViewControllableFlow.self) { flow in
 *         viewControllers.contains { $0 === flow.viewController }
 *     }
 * }
 * ```
 *
 * - Note: In the above example, the `where` closure returns `true` if the ``ViewControllable`` of the `flow`
 *   exists in the given `viewControllers` array.
 *
 * - Important: Use the ``AbstractFlow/detach(endingSubFlowsOfType:where:)`` method only when ``ViewControllable``
 *   instances are dismissed directly within the UI framework (before the `Context` instance is informed of the
 *   interaction). And therefore, in normal situations, use the ``AbstractFlow/detach(ending:)`` method whenever
 *   the `Flow` instance initiates the dismissal.
 *
 * Within a `UIKit` app (for example), for a `Flow` instance to be informed of view controllers removed from a
 * navigation stack as a result of user interactions, the view controller must subclass ``NavigationController``
 * and provide the closure in which to call the receiver method.
 *
 * Example of view controller implementation:
 * ```swift
 * class ViewController: NavigationController {
 *
 *     init() {
 *         super.init(nibName: nil, bundle: nil)
 *         onPopViewControllers { [weak self] in
 *             self?.receiver?.didPopViewControllers($0)
 *         }
 *     }
 * }
 * ```
 *
 * The `Context` (receiver) instance is then responsible for forwarding the ``ViewControllable`` collection to the
 * `Flow` instance.
 *
 * Example of `Context` implementation:
 * ```swift
 * func didPopViewControllers(_ viewControllers: [ViewControllable]) {
 *     flow?.detach(endingFlowsFor: viewControllers)
 * }
 * ```
 */
open class NavigationController: UINavigationController, UINavigationControllerDelegate {

    public typealias DidPopViewControllersCallback = ([UIViewController]) -> Void

    private var didPopViewControllers: DidPopViewControllersCallback?

    private var previousChildren: [UIViewController] = []

    /// Notifies the delegate after the navigation controller displays a view controller’s view and navigation
    /// item properties.
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller that is showing the view and properties of a
    ///     view controller.
    ///   - viewController: The view controller whose view and navigation item properties are being shown.
    ///   - animated: `true` to animate the transition; otherwise, `false`.
    open func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        defer { previousChildren = children }
        guard let didPopViewControllers: DidPopViewControllersCallback
        else { return }
        let endIndex: Int = previousChildren.count - 1
        guard let index: Int = previousChildren.firstIndex(where: { $0 === viewController }),
              index < endIndex
        else { return }
        let startIndex: Int = index + 1
        didPopViewControllers(Array(previousChildren[startIndex...endIndex]))
    }

    /// Assigns the closure in which to call the receiver method informing a `Context` instance of removed
    /// view controllers.
    ///
    /// Under normal circumstances, user interactions do not directly cause ``ViewControllable`` instances to
    /// be dismissed, for example when simply tapping a button. To dismiss a ``ViewControllable`` instance in these
    /// situations, the `Context` instance will be informed of the button tap which then informs the `Flow` instance
    /// to initiate the dismissal. The `Flow` instance retrieves the appropriate child `Flow` instance (by type) and,
    /// only after the dismissal is complete, detaches the child `Flow` instance using the
    /// ``AbstractFlow/detach(ending:)`` method.
    ///
    /// However, in some cases, user interactions can directly cause ``ViewControllable`` instances to be dismissed,
    /// for example when interacting with [`UINavigationController`](
    /// https://developer.apple.com/documentation/uikit/uinavigationcontroller
    /// ) (from `UIKit`). By long pressing the back button of the navigation controller, a user may navigate backward
    /// to any point in the navigation history, which directly causes one or more ``ViewControllable`` instances to be
    /// immediately removed from the navigation stack. In these situations, to detach `Flow` instances corresponding to
    /// already dismissed ``ViewControllable`` instances, the `Context` instance will be informed of the dismissal
    /// (and be provided the ``ViewControllable`` instances) which then informs the `Flow` instance to perform
    /// the detachment only.
    ///
    /// Example of `Flow` implementation:
    /// ```swift
    /// func detach(endingFlowsFor viewControllers: [ViewControllable]) {
    ///     detach(endingSubFlowsOfType: ViewControllableFlow.self) { flow in
    ///         viewControllers.contains { $0 === flow.viewController }
    ///     }
    /// }
    /// ```
    ///
    /// - Note: In the above example, the `where` closure returns `true` if the ``ViewControllable`` of the `flow`
    ///   exists in the given `viewControllers` array.
    ///
    /// - Important: Use the ``AbstractFlow/detach(endingSubFlowsOfType:where:)`` method only when ``ViewControllable``
    ///   instances are dismissed directly within the UI framework (before the `Context` instance is informed of the
    ///   interaction). And therefore, in normal situations, use the ``AbstractFlow/detach(ending:)`` method whenever
    ///   the `Flow` instance initiates the dismissal.
    ///
    /// Within a `UIKit` app (for example), for a `Flow` instance to be informed of view controllers removed from a
    /// navigation stack as a result of user interactions, the view controller must subclass ``NavigationController``
    /// and provide the closure in which to call the receiver method.
    ///
    /// Example of view controller implementation:
    /// ```swift
    /// class ViewController: NavigationController {
    ///
    ///     init() {
    ///         super.init(nibName: nil, bundle: nil)
    ///         onPopViewControllers { [weak self] in
    ///             self?.receiver?.didPopViewControllers($0)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// The `Context` (receiver) instance is then responsible for forwarding the ``ViewControllable`` collection to the
    /// `Flow` instance.
    ///
    /// Example of `Context` implementation:
    /// ```swift
    /// func didPopViewControllers(_ viewControllers: [ViewControllable]) {
    ///     flow?.detach(endingFlowsFor: viewControllers)
    /// }
    /// ```
    ///
    /// - Parameter didPopViewControllers: A closure in which to call the receiver method.
    public func onPopViewControllers(didPopViewControllers: DidPopViewControllersCallback? = nil) {
        self.didPopViewControllers = didPopViewControllers
        delegate = didPopViewControllers == nil ? nil : self
    }
}

#endif
