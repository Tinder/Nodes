//
//  Copyright © 2020 Tinder (Match Group, LLC)
//

// swiftlint:disable period_spacing

/**
 * Nodes’ ``AbstractBuilder`` base class.
 *
 * > Note: This abstract class should never be instantiated directly and must therefore always be subclassed.
 *
 * ``AbstractBuilder`` has the following generic parameters:
 * | Name                           | Description                                                                  |
 * | ------------------------------ | ---------------------------------------------------------------------------- |
 * | ComponentType                  | The DI graph `Component` type.                                               |
 * | BuildType                      | The type of `Flow` object the ``AbstractBuilder`` instance will create.      |
 * | DynamicBuildDependencyType     | The type of dependency provided dynamically to the `BuildType` instance.     |
 * | DynamicComponentDependencyType | The type of dependency provided dynamically to the `ComponentType` instance. |
 */
open class AbstractBuilder<ComponentType,
                           BuildType,
                           DynamicBuildDependencyType, // swiftlint:disable:this generic_type_name
                           DynamicComponentDependencyType> { // swiftlint:disable:this generic_type_name

    private weak var lastComponent: AnyObject?

    private let componentFactory: (DynamicComponentDependencyType) -> ComponentType

    /// Initializes an ``AbstractBuilder`` instance.
    ///
    /// - Parameters:
    ///   - componentFactory: The `ComponentType` factory closure.
    ///
    ///     The closure has the following arguments:
    ///     | Name       | Description                                             |
    ///     | ---------- | ------------------------------------------------------- |
    ///     | dependency | The dynamic dependency of the `ComponentType` instance. |
    ///
    ///     The closure is escaping and returns a `ComponentType` instance.
    public init(componentFactory: @escaping (DynamicComponentDependencyType) -> ComponentType) {
        self.componentFactory = componentFactory
    }

    /// The factory method that creates and returns a `BuildType` instance (`Flow` object).
    ///
    /// This method typically also creates several other objects including a `Context` instance,
    /// one or more `Worker` instances, and a ``ViewControllable`` instance.
    ///
    /// - Important: This abstract method must be overridden in subclasses.
    ///   This method should never be called directly.
    ///   The ``AbstractBuilder`` instance calls this method internally.
    ///
    /// - Parameters:
    ///   - component: The `ComponentType` instance.
    ///   - dynamicBuildDependency: The `DynamicBuildDependencyType` instance.
    ///
    /// - Returns: A `BuildType` instance (`Flow` object).
    open func build( // swiftlint:disable:this unavailable_function
        component: ComponentType,
        dynamicBuildDependency: DynamicBuildDependencyType
    ) -> BuildType {
        preconditionFailure("Method in abstract base class must be overridden")
    }

    /// Initializes a `ComponentType` instance (using the stored factory) which is then passed to
    /// ``build(component:dynamicBuildDependency:)`` to create the `BuildType` instance (`Flow` object).
    ///
    /// - Parameters:
    ///   - dynamicBuildDependency: The `DynamicBuildDependencyType` instance.
    ///   - dynamicComponentDependency: The `DynamicComponentDependencyType` instance.
    ///
    /// - Returns: A `BuildType` instance (`Flow` object).
    public final func build(
        _ dynamicBuildDependency: DynamicBuildDependencyType,
        _ dynamicComponentDependency: DynamicComponentDependencyType
    ) -> BuildType {
        let component: ComponentType = componentFactory(dynamicComponentDependency)
        let newComponent: AnyObject = component as AnyObject
        assert(newComponent !== lastComponent, "Factory must produce a new component each time it is called")
        lastComponent = newComponent
        return build(component: component, dynamicBuildDependency: dynamicBuildDependency)
    }
}

// swiftlint:enable period_spacing
