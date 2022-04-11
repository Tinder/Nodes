//
//  PluginMap.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/21/20.
//

/**
 * Nodes’ abstract `PluginMap` base class.
 *
 * `PluginMap` has the following generic parameters:
 * | Name          | Description                                                                                 |
 * | ------------- | ------------------------------------------------------------------------------------------- |
 * | ComponentType | The DI graph `Component` type.                                                              |
 * | BuildType     | The type of object created (typically a `Builder`).                                         |
 * | StateType     | The type of state to be used as enabled criteria (can be any type, even `Void` or a tuple). |
 */
open class PluginMap<KeyType: Hashable, ComponentType, BuildType, StateType> {

    /**
     * A type-erased `Plugin` type used by the `PluginMap` instance when defining a collection of generic plugins.
     */
    public final class Plugin {

        private let create: (StateType) -> BuildType?

        /// Initializes a new type-erased `Plugin` instance.
        ///
        /// - Parameters:
        ///   - create: A factory closure in which to initialize a generic `Plugin` instance
        ///     and call its `create` method.
        ///
        ///     The closure has the following arguments:
        ///     | Name  | Description               |
        ///     | ----- | ------------------------- |
        ///     | state | The `StateType` instance. |
        ///
        ///     The closure is escaping and returns an optional `BuildType` instance.
        ///
        /// Example:
        /// ```
        /// Plugin { state in
        ///     ExamplePluginImp(component: component.examplePluginComponentFactory(state: state)).create()
        /// }
        /// ```
        public init(create: @escaping (StateType) -> BuildType?) {
            self.create = create
        }

        /// Calls the stored factory closure.
        ///
        /// - Important: This method should never be called directly.
        ///   The `PluginMap` instance calls this method internally.
        ///
        /// - Parameter state: The `StateType` instance.
        ///
        /// - Returns: An optional `BuildType` instance.
        public func create(state: StateType) -> BuildType? {
            create(state)
        }
    }

    // swiftlint:disable:next strict_fileprivate
    fileprivate let component: ComponentType

    /// Initializes a new `PluginMap` instance.
    ///
    /// - Parameter component: The `ComponentType` instance.
    public init(component: ComponentType) {
        self.component = component
    }

    /// Defines the collection of type-erased `Plugin` instances.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The `PluginMap` instance calls this method internally.
    ///
    /// - Parameter component: The `ComponentType` instance.
    ///
    /// - Returns: The dictionary of type-erased `Plugin` instances.
    open func plugins(component: ComponentType) -> [KeyType: Plugin] { // swiftlint:disable:this unavailable_function
        preconditionFailure("Method in abstract base class must be overridden")
    }

    /// Calls `create` on all plugins and returns the resulting non-nil `BuildType` instances.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: An array of `BuildType` instances.
    public func createAll(state: StateType) -> [BuildType] {
        plugins(component: component).compactMap { $0.value.create(state: state) }
    }

    /// Calls `create` on the plugin in the dictionary for the given `key`
    /// and returns the resulting optional `BuildType` instance, or `nil` when the `key` is not in the dictionary.
    ///
    /// - Parameters:
    ///   - key: The `KeyType` instance.
    ///   - state: The `StateType` instance.
    ///
    /// - Returns: An optional `BuildType` instance.
    public func create(key: KeyType, state: StateType) -> BuildType? {
        plugins(component: component)[key]?.create(state: state)
    }
}

extension PluginMap.Plugin where StateType == Void {

    /// Initializes a new type-erased `Plugin` instance.
    ///
    /// - Parameters:
    ///   - create: A factory closure in which to initialize a generic `Plugin` instance and call its `create` method.
    ///
    ///     The closure is an escaping autoclosure that has no arguments and returns an optional `BuildType` instance.
    ///
    /// Example:
    /// ```
    /// Plugin(ExamplePluginImp(component: component.examplePluginComponentFactory()).create())
    /// ```
    public convenience init(_ create: @escaping @autoclosure () -> BuildType?) {
        self.init(create: create)
    }
}

extension PluginMap where StateType == Void {

    /// Calls `create` on all plugins and returns the resulting non-nil `BuildType` instances.
    ///
    /// This convenience method has no parameters since `StateType` is `Void`.
    ///
    /// - Returns: An array of `BuildType` instances.
    public func createAll() -> [BuildType] {
        createAll(state: ())
    }

    /// Calls `create` on the plugin in the dictionary for the given `key`
    /// and returns the resulting optional `BuildType` instance, or `nil` when the `key` is not in the dictionary.
    ///
    /// This convenience method has only a `key` parameter since `StateType` is `Void`.
    ///
    /// - Parameter key: The `KeyType` instance.
    ///
    /// - Returns: An optional `BuildType` instance.
    public func create(key: KeyType) -> BuildType? {
        create(key: key, state: ())
    }
}

/**
 * Nodes’ abstract `PluginMapWithDefault` base class.
 *
 * A default instance is prepended to the collection of `BuildType` instances.
 *
 * `PluginMapWithDefault` has the following generic parameters:
 * | Name          | Description                                                                                 |
 * | ------------- | ------------------------------------------------------------------------------------------- |
 * | KeyType       | The `Hashable` type for the dictionary keys (typically `String`).                           |
 * | ComponentType | The DI graph `Component` type.                                                              |
 * | BuildType     | The type of object created (typically a `Builder`).                                         |
 * | StateType     | The type of state to be used as enabled criteria (can be any type, even `Void` or a tuple). |
 */
open class PluginMapWithDefault<KeyType: Hashable, // swiftlint:disable:this operator_usage_whitespace
                                ComponentType,
                                BuildType,
                                StateType>: PluginMap<KeyType, ComponentType, BuildType, StateType> {

    /// Defines the default instance to prepend to the collection of `BuildType` instances.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The `PluginListWithDefault` instance calls this method internally.
    ///
    /// - Parameters:
    ///   - component: The `ComponentType` instance.
    ///   - state: The `StateType` instance.
    ///
    /// - Returns: A `BuildType` instance.
    open func `default`( // swiftlint:disable:this unavailable_function
        component: ComponentType,
        state: StateType
    ) -> BuildType {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    /// Calls `create` on all plugins and returns the resulting non-nil `BuildType` instances
    /// prepended with the default instance returned from ``default(component:state:)``.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: An array of `BuildType` instances.
    override public func createAll(state: StateType) -> [BuildType] {
        [`default`(component: component, state: state)] + super.createAll(state: state)
    }

    /// Calls `create` on the plugin in the dictionary for the given `key`
    /// and returns the resulting `BuildType` instance, otherwise when the `key` is not in the dictionary
    /// or the `create` method returns `nil`, the default instance returned from ``default(component:state:)``
    /// is returned.
    ///
    /// - Parameters:
    ///   - key: The `KeyType` instance.
    ///   - state: The `StateType` instance.
    ///
    /// - Returns: A `BuildType` instance.
    override public func create(key: KeyType, state: StateType) -> BuildType {
        super.create(key: key, state: state) ?? `default`(component: component, state: state)
    }
}

extension PluginMapWithDefault where StateType == Void {

    /// Calls `create` on the plugin in the dictionary for the given `key`
    /// and returns the resulting `BuildType` instance, otherwise when the `key` is not in the dictionary
    /// or the `create` method returns `nil`, the default instance returned from ``default(component:state:)``
    /// is returned.
    ///
    /// This convenience method has only a `key` parameter since `StateType` is `Void`.
    ///
    /// - Parameters:
    ///   - key: The `KeyType` instance.
    ///
    /// - Returns: A `BuildType` instance.
    public func create(key: KeyType) -> BuildType {
        create(key: key, state: ())
    }
}
