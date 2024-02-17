//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

import Foundation

public final class PresetGenerator {

    private let config: Config
    private let fileSystem: FileSystem

    public init(
        config: Config,
        fileSystem: FileSystem = FileManager.default
    ) {
        self.config = config
        self.fileSystem = fileSystem
    }

    // swiftlint:disable:next function_body_length
    public func generate(
        preset: Preset,
        with fileHeader: String,
        into directory: URL
    ) throws {
        let output: [String: String]
        if preset.isViewInjected {
            let node: StencilTemplate.NodeViewInjected = .init()
            let context: NodeViewInjectedStencilContext = try .init(
                preset: preset,
                fileHeader: fileHeader,
                analyticsImports: node.analytics.imports(config: config),
                builderImports: node.builder.imports(config: config),
                contextImports: node.context.imports(config: config),
                flowImports: node.flow.imports(config: config),
                stateImports: node.state.imports(config: config),
                analyticsTestsImports: node.analyticsTests.imports(config: config),
                contextTestsImports: node.contextTests.imports(config: config),
                flowTestsImports: node.flowTests.imports(config: config),
                dependencies: config.dependencies,
                analyticsProperties: config.analyticsProperties,
                flowProperties: config.flowProperties,
                viewControllableFlowType: config.viewControllableFlowType,
                viewControllableType: config.viewControllableType,
                viewControllableMockContents: config.viewControllableMockContents,
                contextGenericTypes: config.contextGenericTypes,
                workerGenericTypes: config.workerGenericTypes,
                isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
                isNimbleEnabled: config.isNimbleEnabled
            )
            output = try StencilRenderer().renderNodeViewInjected(context: context, includeState: false)
        } else {
            let uiFramework: UIFramework = try config.uiFramework(for: .uiKit)
            let kind: UIFramework.Kind = uiFramework.kind
            let node: StencilTemplate.Node = .init(for: .variation(for: kind))
            let context: NodeStencilContext = try .init(
                preset: preset,
                fileHeader: fileHeader,
                analyticsImports: node.analytics.imports(for: uiFramework, config: config),
                builderImports: node.builder.imports(for: uiFramework, config: config),
                contextImports: node.context.imports(for: uiFramework, config: config),
                flowImports: node.flow.imports(for: uiFramework, config: config),
                stateImports: node.state.imports(for: uiFramework, config: config),
                viewControllerImports: node.viewController.imports(for: uiFramework, config: config),
                viewStateImports: node.viewState.imports(for: uiFramework, config: config),
                analyticsTestsImports: node.analyticsTests.imports(for: uiFramework, config: config),
                contextTestsImports: node.contextTests.imports(for: uiFramework, config: config),
                flowTestsImports: node.flowTests.imports(for: uiFramework, config: config),
                viewControllerTestsImports: node.viewControllerTests.imports(for: uiFramework, config: config),
                viewStateFactoryTestsImports: node.viewStateFactoryTests.imports(for: uiFramework, config: config),
                dependencies: config.dependencies,
                analyticsProperties: config.analyticsProperties,
                flowProperties: config.flowProperties,
                viewControllableFlowType: config.viewControllableFlowType,
                viewControllableType: config.viewControllableType,
                viewControllableMockContents: config.viewControllableMockContents,
                viewControllerType: uiFramework.viewControllerType,
                viewControllerSuperParameters: uiFramework.viewControllerSuperParameters,
                viewControllerProperties: uiFramework.viewControllerProperties,
                viewControllerMethods: uiFramework.viewControllerMethods,
                viewControllerSubscriptionsProperty: config.viewControllerSubscriptionsProperty,
                viewControllerUpdateComment: config.viewControllerUpdateComment,
                viewStateEmptyFactory: config.viewStateEmptyFactory,
                viewStateOperators: config.viewStateOperators,
                viewStatePropertyComment: config.viewStatePropertyComment,
                viewStatePropertyName: config.viewStatePropertyName,
                viewStateTransform: config.viewStateTransform,
                publisherType: config.publisherType,
                publisherFailureType: config.publisherFailureType,
                contextGenericTypes: config.contextGenericTypes,
                workerGenericTypes: config.workerGenericTypes,
                isPreviewProviderEnabled: config.isPreviewProviderEnabled,
                isPeripheryCommentEnabled: config.isPeripheryCommentEnabled,
                isNimbleEnabled: config.isNimbleEnabled
            )
            output = try StencilRenderer().renderNode(context: context, kind: kind, includeState: true)
        }
        for (file, contents): (String, String) in output.sorted(by: { $0.key < $1.key }) {
            let url: URL = directory
                .appendingPathComponent("\(preset.nodeName)\(file)")
                .appendingPathExtension("swift")
            try fileSystem.write(Data(contents.utf8), to: url, atomically: true)
        }
    }
}
