//
//  FlowController.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

/**
 * ``FlowController`` is used internally (within Nodes' source code) enabling each `Flow` instance to manage
 * a collection of child `Flow` instances.
 *
 * > Important: Consider ``FlowController`` to be a private type and avoid its use within application code.
 */
public final class FlowController {

    #if DEBUG

    public var tree: Node {
        Node(name: "", children: flows.map(\.tree))
    }

    #endif

    /// The array of `Flow` instances managed by the ``FlowController``.
    public private(set) var flows: [Flow] = []

    // swiftlint:disable:next redundant_type_annotation
    internal var isFlowLeakDetectionEnabled: Bool = true

    /// Initializes a new ``FlowController`` instance to manage a collection of `Flow` instances.
    public init() {}

    /// Executes the given closure without `Flow` leak detection enabled.
    ///
    /// - Important: Extremely limit the use of this method to only where it is absolutely unavoidable.
    ///
    /// - Parameters:
    ///   - withoutFlowLeakDetection: The closure to execute.
    ///
    ///     The closure has the following arguments:
    ///     | Name           | Description                    |
    ///     | -------------- | ------------------------------ |
    ///     | flowController | The ``FlowController`` instance. |
    ///
    ///     The closure returns `Void`.
    public func withoutFlowLeakDetection(withoutFlowLeakDetection: (FlowController) -> Void) {
        isFlowLeakDetectionEnabled = false
        withoutFlowLeakDetection(self)
        isFlowLeakDetectionEnabled = true
    }

    /// Appends the given `Flow` instance to the `flows` array and calls its `start` method.
    ///
    /// The given `Flow` instance must not already exist in the `flows` array and its `Context` must not be active.
    ///
    /// - Parameter flow: The `Flow` instance to attach and start.
    public func attach(starting flow: Flow) {
        guard !flows.contains(where: { $0 === flow }),
              !flow._context.isActive
        else {
            assertionFailure("Unable to attach")
            return
        }
        #if DEBUG
        DebugInformation.FlowControllerWillAttachNotification(flowController: self, flow: flow).post()
        #endif
        flows.append(flow)
        flow.start()
    }

    /// Calls the end method of the given `Flow` instance and removes it from the `flows` array.
    ///
    /// The given `Flow` instance must already exist in the `flows` array and its `Context` must be active.
    ///
    /// - Parameter flow: The `Flow` instance to end and detach.
    public func detach(ending flow: Flow) {
        guard flows.contains(where: { $0 === flow }),
              flow._context.isActive
        else {
            assertionFailure("Unable to detach")
            return
        }
        flow.end()
        flows.removeAll { $0 === flow }
        if isFlowLeakDetectionEnabled { LeakDetector.detect(flow) }
        #if DEBUG
        DebugInformation.FlowControllerDidDetachNotification(flowController: self, flow: flow).post()
        #endif
    }

    /// Detaches `Flow` instances of the given `type` where the given predicate closure returns `true`.
    ///
    /// Under normal circumstances, user interactions do not directly cause ``ViewControllable`` instances to
    /// be dismissed, for example when simply tapping a button. To dismiss a ``ViewControllable`` instance in
    /// these situations, the `Context` instance will be informed of the button tap which then informs the `Flow`
    /// instance to initiate the dismissal. The `Flow` instance retrieves the appropriate child `Flow` instance
    /// (by type) and, only after the dismissal is complete, detaches the child `Flow` instance using the
    /// ``detach(ending:)`` method.
    ///
    /// However, in some cases, user interactions can directly cause ``ViewControllable`` instances to be dismissed,
    /// for example when interacting with ``UINavigationController`` (from `UIKit`). By long pressing the back button
    /// of a ``UINavigationController``, a user may navigate backward to any point in the navigation history, which
    /// directly causes one or more ``ViewControllable`` instances to be immediately popped off the navigation stack.
    /// In these situations, to detach `Flow` instances corresponding to already dismissed ``ViewControllable``
    /// instances, the `Context` instance will be informed of the dismissal (and be provided the ``ViewControllable``
    /// instances) which then informs the `Flow` instance to perform the detachment only.
    ///
    /// Example:
    /// ```
    /// func detach(endingFlowsFor viewControllers: [ViewControllable]) {
    ///     detach(endingFlowsOfType: ViewControllableFlow.self) { flow in
    ///         viewControllers.contains { $0 === flow.viewController }
    ///     }
    /// }
    /// ```
    ///
    /// In the above example, the `where` closure returns `true` if the ``ViewControllable`` of the `flow` exists in
    /// the given `viewControllers` array.
    ///
    /// - Important: Use the ``detach(endingFlowsOfType:where:)`` method only when ``ViewControllable``
    ///   instances are dismissed directly within the UI framework (before the `Context` instance is informed of the
    ///   interaction). And therefore, in normal situations, use the ``detach(ending:)`` method whenever the `Flow`
    ///   instance initiates the dismissal.
    ///
    /// For a `Flow` instance to be informed of any view controllers popped off of a navigation stack as a result of
    /// user interactions, the view controller must subclass ``NavigationController`` providing a closure in which to
    /// call the receiver method.
    ///
    /// Example:
    /// ```
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
    /// The `Context` (receiver) instance is then responsible for forwarding the view controller collection to
    /// the `Flow` instance.
    ///
    /// Example:
    /// ```
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
    public final func detach<T>(endingFlowsOfType type: T.Type, where: (_ flow: T) -> Bool) {
        flows.reversed().forEach { flow in
            guard let typedFlow: T = flow as? T, `where`(typedFlow)
            else { return }
            detach(ending: flow)
        }
    }

    /// Returns the first `Flow` instance of the given `type`, if any exist, in the `flows` array.
    ///
    /// - Parameter type: The type of the `Flow` instance to return.
    ///
    /// - Returns: The first `Flow` instance of the given `type` in the `flows` array, or `nil` if none exist.
    public func firstFlow<T>(ofType type: T.Type) -> T? {
        flows.first { $0 is T } as? T
    }

    /// Executes the given closure with the first `Flow` instance of the given `type`, if any exist,
    /// in the `flows` array.
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
    public func withFirstFlow<T>(ofType type: T.Type, perform: (_ flow: T) throws -> Void) rethrows {
        guard let flow: T = firstFlow(ofType: type)
        else { return }
        try perform(flow)
    }

    /// Returns an array of the `Flow` instances of the given `type` existing in the `flows` array.
    ///
    /// - Parameter type: The type of the `Flow` instances to return.
    ///
    /// - Returns: The `Flow` instances of the given `type`.
    public func flows<T>(ofType type: T.Type) -> [T] {
        flows.compactMap { $0 as? T }
    }

    /// Executes the given closure with each `Flow` instance of the given `type`, if any exist,
    /// in the `flows` array.
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
    public func withFlows<T>(ofType type: T.Type, perform: (_ flow: T) throws -> Void) rethrows {
        try flows(ofType: type).forEach(perform)
    }

    deinit {
        flows.forEach(detach)
    }
}
