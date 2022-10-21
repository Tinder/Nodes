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
 * | Name          | Description                                                                                 |
 * | ------------- | ------------------------------------------------------------------------------------------- |
 * | KeyType       | The ``Hashable`` key type.                                                                  |
 * | ComponentType | The DI graph `Component` type.                                                              |
 * | BuildType     | The type of object created (typically a `Builder`).                                         |
 * | StateType     | The type of state to be used as enabled criteria (can be any type, even `Void` or a tuple). |
 */
open class PluginList<KeyType: Hashable, ComponentType, BuildType, StateType> {

    private typealias KeyValuePair = (key: KeyType, value: AnyPlugin)

    /**
     * A type-erased `AnyPlugin` type used to define the plugin collection in ``PluginList`` subclasses.
     */
    public final class AnyPlugin {

        private let create: (StateType) -> BuildType?

        /// Initializes a new type-erased `AnyPlugin` instance.
        ///
        /// Example:
        /// ```
        /// Plugin { state in
        ///     ExamplePluginImp(componentFactory: component.examplePluginComponentFactory).create(state: state)
        /// }
        /// ```
        ///
        /// - Parameters:
        ///   - create: A factory closure in which to initialize a generic `AnyPlugin` instance and
        ///     call its `create` method.
        ///
        ///     The closure has the following arguments:
        ///     | Name  | Description               |
        ///     | ----- | ------------------------- |
        ///     | state | The `StateType` instance. |
        ///
        ///     The closure is escaping and returns an optional `BuildType` instance.
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

    private weak var lastComponent: AnyObject?

    private let componentFactory: () -> ComponentType

    /// Initializes a new ``PluginList`` instance.
    ///
    /// - Parameters:
    ///   - componentFactory: The `ComponentType` factory closure.
    ///
    ///     The closure is an escaping closure that has no arguments and returns a `ComponentType` instance.
    public init(componentFactory: @escaping () -> ComponentType) {
        self.componentFactory = componentFactory
    }

    /// Defines the collection of type-erased `AnyPlugin` instances.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The ``PluginList`` instance calls this method internally.
    ///
    /// - Parameter component: The `ComponentType` instance.
    ///
    /// - Returns: The collection of type-erased `AnyPlugin` instances.
    open func plugins( // swiftlint:disable:this unavailable_function
        component: ComponentType
    ) -> KeyValuePairs<KeyType, AnyPlugin> {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    /// Defines the order plugins are created in.
    ///
    /// This method may be overridden in subclasses. The default implementation returns the keys in order as
    /// defined in ``plugins(component:)``. There is no need to call `super` when overriding this method unless
    /// it is desirable to reference (or modify) the default order.
    ///
    /// - Tip: If a key for a plugin is not included in the returned array, that plugin will not be created.
    ///   This can be useful to dynamically filter the plugin collection, for example.
    ///
    /// - Important: This method should never be called directly.
    ///   The ``PluginList`` instance calls this method internally.
    ///
    /// - Parameters:
    ///   - component: The `ComponentType` instance.
    ///   - state: The `StateType` instance.
    ///
    /// - Returns: The keys defining the order plugins are created in.
    open func creationOrder(
        component: ComponentType,
        state: StateType
    ) -> [KeyType] {
        plugins(component: component).map(\.key)
    }

    /// Calls `create` on the plugins for the keys provided by ``creationOrder(component:)`` and returns
    /// the resulting non-nil `BuildType` instances in creation order.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: An array of `BuildType` instances.
    public func createAll(state: StateType) -> [BuildType] {
        let component: ComponentType = makeComponent()
        return createAll(component: component, state: state)
    }

    /// Calls `create` on each plugin in the plugin collection (in reverse creation order) and returns the
    /// first non-nil `BuildType` instance.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: An optional `BuildType` instance.
    public func create(state: StateType) -> BuildType? {
        let component: ComponentType = makeComponent()
        return create(component: component, state: state)
    }

    /// Calls `create` on the plugin for the given `key` and returns the resulting optional `BuildType` instance,
    /// or `nil` when the collection does not contain a plugin for that `key`.
    ///
    /// - Parameters:
    ///   - key: The `KeyType` instance.
    ///   - state: The `StateType` instance.
    ///
    /// - Returns: An optional `BuildType` instance.
    public func create(key: KeyType, state: StateType) -> BuildType? {
        let component: ComponentType = makeComponent()
        return create(component: component, key: key, state: state)
    }

    // MARK: - Access Control: fileprivate

    // swiftlint:disable:next strict_fileprivate
    fileprivate func makeComponent() -> ComponentType {
        let component: ComponentType = componentFactory()
        let newComponent: AnyObject = component as AnyObject
        assert(newComponent !== lastComponent, "Factory must produce a new component each time it is called")
        lastComponent = newComponent
        return component
    }

    // swiftlint:disable:next strict_fileprivate
    fileprivate func createAll(component: ComponentType, state: StateType) -> [BuildType] {
        let plugins: [KeyValuePair] = orderedPlugins(component: component, state: state)
        return plugins.map(\.value).compactMap { $0.create(state: state) }
    }

    // swiftlint:disable:next strict_fileprivate
    fileprivate func create(component: ComponentType, state: StateType) -> BuildType? {
        let plugins: [KeyValuePair] = orderedPlugins(component: component, state: state)
        for plugin: AnyPlugin in plugins.map(\.value).reversed() {
            guard let build: BuildType = plugin.create(state: state)
            else { continue }
            return build
        }
        return nil
    }

    // swiftlint:disable:next strict_fileprivate
    fileprivate func create(component: ComponentType, key: KeyType, state: StateType) -> BuildType? {
        let plugins: [KeyValuePair] = orderedPlugins(component: component, state: state)
        guard let plugin: KeyValuePair = plugins.first(where: { $0.key == key })
        else { return nil }
        return plugin.value.create(state: state)
    }

    // MARK: - Access Control: private

    private func orderedPlugins(component: ComponentType, state: StateType) -> [KeyValuePair] {
        let plugins: KeyValuePairs<KeyType, AnyPlugin> = plugins(component: component)
        let keys: [KeyType] = creationOrder(component: component, state: state)
        var store: Set<KeyType> = []
        let uniqueKeys: [KeyType] = keys.filter { store.insert($0).inserted }
        assert(uniqueKeys.count == keys.count, "Keys must be unique \(keys)")
        return uniqueKeys.compactMap { key in plugins.first { $0.key == key } }
    }
}

extension PluginList.AnyPlugin where StateType == Void {

    /// Initializes a new type-erased `AnyPlugin` instance.
    ///
    /// Example:
    /// ```
    /// Plugin(ExamplePluginImp(componentFactory: component.examplePluginComponentFactory).create())
    /// ```
    ///
    /// - Parameters:
    ///   - create: A factory closure in which to initialize a generic `AnyPlugin` instance and
    ///     call its `create` method.
    ///
    ///     The closure is an escaping autoclosure that has no arguments and returns an optional `BuildType` instance.
    public convenience init(_ create: @escaping @autoclosure () -> BuildType?) {
        self.init(create: create)
    }
}

extension PluginList where StateType == Void {

    /// Calls `create` on the plugins for the keys provided by ``creationOrder(component:)`` and returns
    /// the resulting non-nil `BuildType` instances in creation order.
    ///
    /// This convenience method has no parameters since `StateType` is `Void`.
    ///
    /// - Returns: An array of `BuildType` instances.
    public func createAll() -> [BuildType] {
        createAll(state: ())
    }

    /// Calls `create` on each plugin in the plugin collection (in reverse creation order) and returns the
    /// first non-nil `BuildType` instance.
    ///
    /// This convenience method has no parameters since `StateType` is `Void`.
    ///
    /// - Returns: An optional `BuildType` instance.
    public func create() -> BuildType? {
        create(state: ())
    }

    /// Calls `create` on the plugin for the given `key` and returns the resulting optional `BuildType` instance,
    /// or `nil` when the collection does not contain a plugin for that `key`.
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
 * Nodes’ abstract ``PluginListWithDefault`` base class.
 *
 * A default instance is prepended to the collection of `BuildType` instances.
 *
 * ``PluginListWithDefault`` has the following generic parameters:
 * | Name          | Description                                                                                 |
 * | ------------- | ------------------------------------------------------------------------------------------- |
 * | KeyType       | The ``Hashable`` key type.                                                                  |
 * | ComponentType | The DI graph `Component` type.                                                              |
 * | BuildType     | The type of object created (typically a `Builder`).                                         |
 * | StateType     | The type of state to be used as enabled criteria (can be any type, even `Void` or a tuple). |
 */
open class PluginListWithDefault<KeyType: Hashable, // swiftlint:disable:this operator_usage_whitespace
                                 ComponentType,
                                 BuildType,
                                 StateType>: PluginList<KeyType, ComponentType, BuildType, StateType> {

    /// Defines the default instance to prepend to the collection of `BuildType` instances.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The ``PluginListWithDefault`` instance calls this method internally.
    ///
    /// - Parameters:
    ///   - component: The `ComponentType` instance.
    ///
    /// - Returns: A `BuildType` instance.
    open func `default`( // swiftlint:disable:this unavailable_function
        component: ComponentType
    ) -> BuildType {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    /// Calls `create` on the plugins for the keys provided by ``creationOrder(component:)`` and returns
    /// the resulting non-nil `BuildType` instances in creation order prepended with the default instance
    /// provided by ``default(component:state:)``.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: An array of `BuildType` instances.
    override public func createAll(state: StateType) -> [BuildType] {
        let component: ComponentType = makeComponent()
        return [`default`(component: component)] + createAll(component: component, state: state)
    }

    /// Calls `create` on each plugin in the plugin collection (in reverse creation order) and returns the
    /// first non-nil `BuildType` instance, otherwise the default instance provided by ``default(component:state:)``
    /// is returned.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: A `BuildType` instance.
    override public func create(state: StateType) -> BuildType {
        let component: ComponentType = makeComponent()
        return create(component: component, state: state) ?? `default`(component: component)
    }

    /// Calls `create` on the plugin for the given `key` and returns the resulting `BuildType` instance,
    /// otherwise when the `key` is not in the dictionary or the `create` method returns `nil`, the default
    /// instance provided by ``default(component:state:)`` is returned.
    ///
    /// - Parameters:
    ///   - key: The `KeyType` instance.
    ///   - state: The `StateType` instance.
    ///
    /// - Returns: A `BuildType` instance.
    override public func create(key: KeyType, state: StateType) -> BuildType {
        let component: ComponentType = makeComponent()
        return create(component: component, key: key, state: state) ?? `default`(component: component)
    }
}

extension PluginListWithDefault where StateType == Void {

    /// Calls `create` on each plugin in the plugin collection (in reverse creation order) and returns the
    /// first non-nil `BuildType` instance, otherwise the default instance provided by ``default(component:state:)``
    /// is returned.
    ///
    /// This convenience method has no parameters since `StateType` is `Void`.
    ///
    /// - Returns: A `BuildType` instance.
    public func create() -> BuildType {
        create(state: ())
    }

    /// Calls `create` on the plugin for the given `key` and returns the resulting `BuildType` instance,
    /// otherwise when the `key` is not in the dictionary or the `create` method returns `nil`, the default
    /// instance provided by ``default(component:)`` is returned.
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
