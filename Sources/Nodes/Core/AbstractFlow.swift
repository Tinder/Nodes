//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

// swiftlint:disable period_spacing

/**
 * Nodes’ ``AbstractFlow`` base class.
 *
 * > Note: This abstract class should never be instantiated directly and must therefore always be subclassed.
 *
 * ``AbstractFlow`` has the following generic parameters:
 * | Name                 | Description                                    |
 * | -------------------- | ---------------------------------------------- |
 * | ContextInterfaceType | The type of the `Context` instance.            |
 * | ViewControllerType   | The type of the ``ViewControllable`` instance. |
 */
@preconcurrency
@MainActor
open class AbstractFlow<ContextInterfaceType, ViewControllerType>: Flow {

    #if DEBUG

    public var tree: Node {
        let type: String = "\(type(of: self))".components(separatedBy: ".").reversed()[0]
        let suffix: String = "FlowImp"
        let name: String = type.hasSuffix(suffix)
            ? String(type.dropLast(suffix.count))
            : type
        return Node(name: name, children: flowController.tree.children)
    }

    #endif

    /// A Boolean value indicating whether the `Flow` instance has started.
    public var isStarted: Bool {
        _context.isActive
    }

    /// The `Context` instance.
    ///
    /// - Important: Consider this property to be private and avoid its use within application code.
    ///   This property is used internally within the framework code.
    public let _context: Context // swiftlint:disable:this identifier_name

    /// The `Context` instance.
    public let context: ContextInterfaceType

    /// The ``ViewControllable`` instance.
    public let viewController: ViewControllerType

    /// The array of child `Flow` instances.
    public var subFlows: [Flow] {
        flowController.flows
    }

    private let flowController: FlowController = .init()

    #if DEBUG

    private var _isStarted: Bool = false

    #endif

    /// Initializes an ``AbstractFlow`` instance.
    ///
    /// - Parameters:
    ///   - context: The `Context` instance.
    ///   - viewController: The ``ViewControllable`` instance.
    public init(
        context: ContextInterfaceType,
        viewController: ViewControllerType
    ) {
        // swiftlint:disable:next identifier_name
        guard let _context: Context = context as? Context
        else { preconditionFailure("\(context) must conform to \(Context.self)") }
        self._context = _context
        self.context = context
        self.viewController = viewController
        flowController.isFlowLeakDetectionEnabled = !(self is FlowRetaining)
    }

    /// Subclasses may override this method to define logic to be performed when the ``AbstractFlow`` starts.
    ///
    /// - Note: The default implementation of this method does nothing.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``AbstractFlow`` instance calls this method internally.
    open func didStart() {}

    /// Starts the `Flow` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    public final func start() {
        guard !isStarted
        else { return }
        #if DEBUG
        DebugInformation.FlowWillStartNotification(flow: self, viewController: viewController as AnyObject).post()
        _isStarted = true
        #endif
        _context.activate()
        #if DEBUG
        _isStarted = true
        #endif
        didStart()
    }

    /// Ends the `Flow` instance.
    ///
    /// - Important: This method should never be called directly within application code.
    ///   This method is called internally within the framework code.
    public final func end() {
        guard isStarted
        else { return }
        subFlows.reversed().forEach(detach)
        _context.deactivate()
        #if DEBUG
        _isStarted = false
        DebugInformation.FlowDidEndNotification(flow: self).post()
        #endif
    }

    /// Appends the given `Flow` instance to the `subFlows` array and calls its `start` method.
    ///
    /// The given `Flow` instance must not already exist in the `subFlows` array and its `Context` must not be active.
    ///
    /// - Parameter subFlow: The `Flow` instance to attach and start.
    public final func attach(starting subFlow: Flow) {
        #if DEBUG
        DebugInformation.FlowWillAttachNotification(flow: self, subFlow: subFlow).post()
        #endif
        flowController.attach(starting: subFlow)
    }

    /// Calls the end method of the given `Flow` instance and removes it from the `subFlows` array.
    ///
    /// The given `Flow` instance must already exist in the `subFlows` array and its `Context` must be active.
    ///
    /// - Parameter subFlow: The `Flow` instance to end and detach.
    public final func detach(ending subFlow: Flow) {
        flowController.detach(ending: subFlow)
        #if DEBUG
        DebugInformation.FlowDidDetachNotification(flow: self, subFlow: subFlow).post()
        #endif
    }

    /// Detaches `Flow` instances of the given `type` (in LIFO order) where the given predicate closure returns `true`.
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
    /// - Parameters:
    ///   - type: The type of the `Flow` instances to detach.
    ///   - where: The condition determining whether to detach the given `flow` instance.
    ///
    ///     The closure has the following arguments:
    ///     | Name | Description                      |
    ///     | ---- | -------------------------------- |
    ///     | flow | The `Flow` instance of type `T`. |
    ///
    ///     The closure returns a Boolean value indicating whether to detach the `Flow` instance.
    public final func detach<T>(endingSubFlowsOfType type: T.Type, where: (_ flow: T) -> Bool) {
        flowController.detach(endingFlowsOfType: type, where: `where`)
    }

    /// Returns the first `Flow` instance of the given `type`, if any exist, in the `subFlows` array.
    ///
    /// - Parameter type: The type of the `Flow` instance to return.
    ///
    /// - Returns: The first `Flow` instance of the given `type` in the `subFlows` array, or `nil` if none exist.
    public final func firstSubFlow<T>(ofType type: T.Type) -> T? {
        flowController.firstFlow(ofType: type)
    }

    /// Executes the given closure with the first `Flow` instance of the given `type`, if any exist,
    /// in the `subFlows` array.
    ///
    /// - Parameters:
    ///   - type: The type of the `Flow` instance with which to execute the closure.
    ///   - perform: The closure to execute.
    ///
    ///     The closure has the following arguments:
    ///     | Name | Description                      |
    ///     | ---- | -------------------------------- |
    ///     | flow | The `Flow` instance of type `T`. |
    ///
    ///     The closure returns `Void` and throws.
    public final func withFirstSubFlow<T>(ofType type: T.Type, perform: (_ flow: T) throws -> Void) rethrows {
        try flowController.withFirstFlow(ofType: type, perform: perform)
    }

    /// Returns an array of the `Flow` instances of the given `type` existing in the `subFlows` array.
    ///
    /// - Parameter type: The type of the `Flow` instances to return.
    ///
    /// - Returns: The `Flow` instances of the given `type`.
    public final func subFlows<T>(ofType type: T.Type) -> [T] {
        flowController.flows(ofType: type)
    }

    /// Executes the given closure with each `Flow` instance of the given `type`, if any exist,
    /// in the `subFlows` array.
    ///
    /// - Parameters:
    ///   - type: The type of the `Flow` instances with which to execute the closure.
    ///   - perform: The closure to execute.
    ///
    ///     The closure has the following arguments:
    ///     | Name | Description                      |
    ///     | ---- | -------------------------------- |
    ///     | flow | The `Flow` instance of type `T`. |
    ///
    ///     The closure returns `Void` and throws.
    public final func withSubFlows<T>(ofType type: T.Type, perform: (_ flow: T) throws -> Void) rethrows {
        try flowController.withFlows(ofType: type, perform: perform)
    }

    deinit {
        #if DEBUG
        if _isStarted {
            assertionFailure("Lifecycle Violation: Expected `AbstractFlow` to end before it is deallocated.")
        }
        #endif
    }
}

// swiftlint:enable period_spacing
