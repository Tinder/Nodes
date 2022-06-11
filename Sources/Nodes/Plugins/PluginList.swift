//
//  PluginList.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

/**
 * Nodes’ abstract ``PluginList`` base class.
 *
 * ``PluginList`` has the following generic parameters:
 * | Name          | Description                                                                                   |
 * | ------------- | --------------------------------------------------------------------------------------------- |
 * | ComponentType | The DI graph `Component` type.                                                                |
 * | BuildType     | The type of object created (typically a `Builder`).                                           |
 * | StateType     | The type of state to be used as enabled criteria (can be any type, even ``Void`` or a tuple). |
 */
open class PluginList<ComponentType, BuildType, StateType> {

    /**
     * A type-erased `Plugin` type used by the ``PluginList`` instance when defining a collection of generic plugins.
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
        ///   The ``PluginList`` instance calls this method internally.
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

    /// Initializes a new ``PluginList`` instance.
    ///
    /// - Parameter component: The `ComponentType` instance.
    public init(component: ComponentType) {
        self.component = component
    }

    /// Defines the collection of type-erased `Plugin` instances.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The ``PluginList`` instance calls this method internally.
    ///
    /// - Parameter component: The `ComponentType` instance.
    ///
    /// - Returns: The array of type-erased `Plugin` instances.
    open func plugins(component: ComponentType) -> [Plugin] { // swiftlint:disable:this unavailable_function
        preconditionFailure("Method in abstract base class must be overridden")
    }

    /// Calls `create` on all plugins and returns the resulting non-nil `BuildType` instances.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: An array of `BuildType` instances.
    public func createAll(state: StateType) -> [BuildType] {
        plugins(component: component).compactMap { $0.create(state: state) }
    }

    /// Calls `create` on each plugin in the plugins collection (in reverse order)
    /// and returns the first non-nil `BuildType` instance.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: An optional `BuildType` instance.
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

extension PluginList where StateType == Void {

    /// Calls `create` on all plugins and returns the resulting non-nil `BuildType` instances.
    ///
    /// This convenience method has no parameters since `StateType` is ``Void``.
    ///
    /// - Returns: An array of `BuildType` instances.
    public func createAll() -> [BuildType] {
        createAll(state: ())
    }

    /// Calls `create` on each plugin in the plugins collection (in reverse order)
    /// and returns the first non-nil `BuildType` instance.
    ///
    /// This convenience method has no parameters since `StateType` is ``Void``.
    ///
    /// - Returns: An optional `BuildType` instance.
    public func create() -> BuildType? {
        create(state: ())
    }
}

/**
 * Nodes’ abstract ``PluginListWithDefault`` base class.
 *
 * A default instance is prepended to the collection of `BuildType` instances.
 *
 * ``PluginListWithDefault`` has the following generic parameters:
 * | Name          | Description                                                                                   |
 * | ------------- | --------------------------------------------------------------------------------------------- |
 * | ComponentType | The DI graph `Component` type.                                                                |
 * | BuildType     | The type of object created (typically a `Builder`).                                           |
 * | StateType     | The type of state to be used as enabled criteria (can be any type, even ``Void`` or a tuple). |
 */
open class PluginListWithDefault<ComponentType, // swiftlint:disable:this operator_usage_whitespace
                                 BuildType,
                                 StateType>: PluginList<ComponentType, BuildType, StateType> {

    /// Defines the default instance to prepend to the collection of `BuildType` instances.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The ``PluginListWithDefault`` instance calls this method internally.
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

    /// Calls `create` on each plugin in the plugins collection (in reverse order) and
    /// returns the first non-nil `BuildType` instance, otherwise the default instance
    /// returned from ``default(component:state:)`` is returned.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: A `BuildType` instance.
    override public func create(state: StateType) -> BuildType {
        super.create(state: state) ?? `default`(component: component, state: state)
    }
}

extension PluginListWithDefault where StateType == Void {

    /// Calls `create` on each plugin in the plugins collection (in reverse order) and
    /// returns the first non-nil `BuildType` instance, otherwise the default instance
    /// returned from ``default(component:state:)`` is returned.
    ///
    /// This convenience method has no parameters since `StateType` is ``Void``.
    ///
    /// - Returns: A `BuildType` instance.
    public func create() -> BuildType {
        create(state: ())
    }
}
