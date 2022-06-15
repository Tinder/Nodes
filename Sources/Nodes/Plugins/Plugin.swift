//
//  Plugin.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

/**
 * Nodes’ abstract ``Plugin`` base class.
 *
 * ``Plugin`` has the following generic parameters:
 * | Name          | Description                                                                                 |
 * | ------------- | ------------------------------------------------------------------------------------------- |
 * | ComponentType | The DI graph `Component` type.                                                              |
 * | BuildType     | The type of object the `Plugin` instance will create (typically a `Builder`).               |
 * | StateType     | The type of state to be used as enabled criteria (can be any type, even `Void` or a tuple). |
 */
open class Plugin<ComponentType, BuildType, StateType> {

    private let component: ComponentType

    /// Initializes a new ``Plugin`` instance.
    ///
    /// - Parameter component: The `ComponentType` instance.
    public init(component: ComponentType) {
        self.component = component
    }

    /// Contains the plugin's enabled criteria.
    ///
    /// The `create` method of the plugin will return a `BuildType` instance when enabled, otherwise `nil`.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The plugin calls this method internally.
    ///
    /// - Parameters:
    ///   - component: The `ComponentType` instance.
    ///   - state: The `StateType` instance.
    ///
    /// - Returns: A Boolean value indicating whether the plugin is enabled.
    open func isEnabled( // swiftlint:disable:this unavailable_function
        component: ComponentType,
        state: StateType
    ) -> Bool {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    /// Initializes and returns a `BuildType` instance.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The plugin calls this method internally.
    ///
    /// - Parameter component: The `ComponentType` instance.
    ///
    /// - Returns: A `BuildType` instance.
    open func build(component: ComponentType) -> BuildType { // swiftlint:disable:this unavailable_function
        preconditionFailure("Method in abstract base class must be overridden")
    }

    /// Initializes and returns a `BuildType` instance when the plugin is enabled, otherwise `nil`.
    ///
    /// - Parameter state: The `StateType` instance.
    ///
    /// - Returns: An optional `BuildType` instance.
    public func create(state: StateType) -> BuildType? {
        guard isEnabled(component: component, state: state)
        else { return nil }
        return build(component: component)
    }
}

extension Plugin where StateType == Void {

    /// Initializes and returns a `BuildType` instance when the plugin is enabled, otherwise `nil`.
    ///
    /// This convenience method has no parameters since `StateType` is `Void`.
    ///
    /// - Returns: An optional `BuildType` instance.
    public func create() -> BuildType? {
        create(state: ())
    }
}
