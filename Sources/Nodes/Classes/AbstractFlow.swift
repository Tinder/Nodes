//
//  AbstractFlow.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

public protocol FlowRetaining: AnyObject {}

/// @mockable
public protocol Flow: AnyObject {

    var isStarted: Bool { get }

    // swiftlint:disable:next identifier_name
    var _context: Context { get }

    func start()
    func end()
}

open class AbstractFlow<ContextInterfaceType, ViewControllerType>: Flow {

    public var isStarted: Bool {
        _context.isActive
    }

    // swiftlint:disable:next identifier_name
    public let _context: Context

    public let context: ContextInterfaceType
    public let viewController: ViewControllerType

    public var subFlows: [Flow] {
        flowController.flows
    }

    private let flowController: FlowController = .init()

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

    open func didStart() {}

    public final func start() {
        guard !_context.isActive
        else { return }
        _context.activate()
        didStart()
    }

    public final func end() {
        guard _context.isActive
        else { return }
        _context.deactivate()
    }

    public final func attach(starting subFlow: Flow) {
        flowController.attach(starting: subFlow)
    }

    public final func detach(ending subFlow: Flow) {
        flowController.detach(ending: subFlow)
    }

    public final func detach<T>(endingSubFlowsOfType type: T.Type, where completion: (_ flow: T) -> Bool) {
        flowController.detach(endingFlowsOfType: type, where: completion)
    }

    public final func firstSubFlow<T>(ofType type: T.Type) -> T? {
        flowController.firstFlow(ofType: T.self)
    }

    public final func withFirstSubFlow<T>(ofType type: T.Type, perform: (_ flow: T) throws -> Void) rethrows {
        try flowController.withFirstFlow(ofType: T.self, perform: perform)
    }

    public final func subFlows<T>(ofType type: T.Type) -> [T] {
        flowController.flows(ofType: T.self)
    }

    public final func withSubFlows<T>(ofType type: T.Type, perform: (_ flow: T) throws -> Void) rethrows {
        try flowController.withFlows(ofType: T.self, perform: perform)
    }

    deinit {
        subFlows.forEach(detach)
        _context.deactivate()
        LeakDetector.detect(_context)
    }
}
