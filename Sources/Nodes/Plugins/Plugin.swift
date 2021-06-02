//
//  Plugin.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

open class Plugin<ComponentType, BuildType, StateType> {

    private let component: ComponentType

    public init(component: ComponentType) {
        self.component = component
    }

    // swiftlint:disable:next unavailable_function
    open func isEnabled(component: ComponentType, state: StateType) -> Bool {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    // swiftlint:disable:next unavailable_function
    open func build(component: ComponentType) -> BuildType {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    public func create(state: StateType) -> BuildType? {
        guard isEnabled(component: component, state: state)
        else { return nil }
        return build(component: component)
    }
}

extension Plugin where StateType == Void {

    public func create() -> BuildType? {
        create(state: ())
    }
}
