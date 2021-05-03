//
//  AbstractBuilder.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

// swiftlint:disable:next generic_type_name
open class AbstractBuilder<ComponentType, BuildType, DynamicBuildDependencyType, DynamicComponentDependencyType> {

    private weak var lastComponent: AnyObject?

    private let componentFactory: (DynamicComponentDependencyType) -> ComponentType

    public init(componentFactory: @escaping (DynamicComponentDependencyType) -> ComponentType) {
        self.componentFactory = componentFactory
    }

    // swiftlint:disable:next unavailable_function
    open func build(
        component: ComponentType,
        dynamicBuildDependency: DynamicBuildDependencyType
    ) -> BuildType {
        fatalError("Method in abstract base class must be overridden")
    }

    public final func build(
        _ dynamicBuildDependency: DynamicBuildDependencyType,
        _ dynamicComponentDependency: DynamicComponentDependencyType
    ) -> BuildType {
        let component: ComponentType = componentFactory(dynamicComponentDependency)
        let newComponent: AnyObject = component as AnyObject
        if newComponent === lastComponent {
            assertionFailure("Component must be a new instance")
        }
        lastComponent = newComponent
        return build(component: component, dynamicBuildDependency: dynamicBuildDependency)
    }
}
