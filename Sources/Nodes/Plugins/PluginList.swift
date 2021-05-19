//
//  PluginList.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

open class PluginList<ComponentType, BuildType, StateType> {

    public final class Plugin {

        private let _create: (StateType) -> BuildType?

        public init(create: @escaping (StateType) -> BuildType?) {
            _create = create
        }

        public func create(state: StateType) -> BuildType? {
            _create(state)
        }
    }

    // swiftlint:disable:next strict_fileprivate
    fileprivate let component: ComponentType

    public init(component: ComponentType) {
        self.component = component
    }

    // swiftlint:disable:next unavailable_function
    open func plugins(component: ComponentType) -> [Plugin] {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    public func createAll(state: StateType) -> [BuildType] {
        plugins(component: component).compactMap { $0.create(state: state) }
    }

    public func create(state: StateType) -> BuildType? {
        for plugin in plugins(component: component).reversed() {
            guard let build: BuildType = plugin.create(state: state)
            else { continue }
            return build
        }
        return nil
    }
}

extension PluginList.Plugin where StateType == Void {

    public convenience init(_ create: @escaping @autoclosure () -> BuildType?) {
        self.init(create: create)
    }

    public func create() -> BuildType? {
        create(state: ())
    }
}

extension PluginList where StateType == Void {

    public func createAll() -> [BuildType] {
        createAll(state: ())
    }

    public func create() -> BuildType? {
        create(state: ())
    }
}

// swiftlint:disable:next operator_usage_whitespace
open class PluginListWithDefault<ComponentType,
                                 BuildType,
                                 StateType>: PluginList<ComponentType, BuildType, StateType> {

    // swiftlint:disable:next unavailable_function
    open func `default`(component: ComponentType, state: StateType) -> BuildType {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    override public func createAll(state: StateType) -> [BuildType] {
        [`default`(component: component, state: state)] + super.createAll(state: state)
    }

    override public func create(state: StateType) -> BuildType {
        super.create(state: state) ?? `default`(component: component, state: state)
    }
}

extension PluginListWithDefault where StateType == Void {

    public func create() -> BuildType {
        create(state: ())
    }
}
