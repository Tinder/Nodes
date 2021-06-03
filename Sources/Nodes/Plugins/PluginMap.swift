//
//  PluginMap.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/21/20.
//

open class PluginMap<KeyType: Hashable, ComponentType, BuildType, StateType> {

    public final class Plugin {

        private let create: (StateType) -> BuildType?

        public init(create: @escaping (StateType) -> BuildType?) {
            self.create = create
        }

        public func create(state: StateType) -> BuildType? {
            create(state)
        }
    }

    // swiftlint:disable:next strict_fileprivate
    fileprivate let component: ComponentType

    public init(component: ComponentType) {
        self.component = component
    }

    // swiftlint:disable:next unavailable_function
    open func plugins(component: ComponentType) -> [KeyType: Plugin] {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    public func createAll(state: StateType) -> [BuildType] {
        plugins(component: component).compactMap { $0.value.create(state: state) }
    }

    public func create(key: KeyType, state: StateType) -> BuildType? {
        plugins(component: component)[key]?.create(state: state)
    }
}

extension PluginMap.Plugin where StateType == Void {

    public convenience init(_ create: @escaping @autoclosure () -> BuildType?) {
        self.init(create: create)
    }
}

extension PluginMap where StateType == Void {

    public func createAll() -> [BuildType] {
        createAll(state: ())
    }

    public func create(key: KeyType) -> BuildType? {
        create(key: key, state: ())
    }
}

// swiftlint:disable:next operator_usage_whitespace
open class PluginMapWithDefault<KeyType: Hashable,
                                ComponentType,
                                BuildType,
                                StateType>: PluginMap<KeyType, ComponentType, BuildType, StateType> {

    // swiftlint:disable:next unavailable_function
    open func `default`(component: ComponentType, state: StateType) -> BuildType {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    override public func createAll(state: StateType) -> [BuildType] {
        [`default`(component: component, state: state)] + super.createAll(state: state)
    }

    override public func create(key: KeyType, state: StateType) -> BuildType {
        super.create(key: key, state: state) ?? `default`(component: component, state: state)
    }
}

extension PluginMapWithDefault where StateType == Void {

    public func create(key: KeyType) -> BuildType {
        create(key: key, state: ())
    }
}
