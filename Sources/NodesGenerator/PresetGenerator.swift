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
                analyticsImports: node.analytics.imports(with: config),
                builderImports: node.builder.imports(with: config),
                contextImports: node.context.imports(with: config),
                flowImports: node.flow.imports(with: config),
                stateImports: node.state.imports(with: config),
                analyticsTestsImports: node.analyticsTests.imports(with: config),
                contextTestsImports: node.contextTests.imports(with: config),
                flowTestsImports: node.flowTests.imports(with: config),
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
            output = try StencilRenderer().renderNodeViewInjected(context: context)
        } else {
            let uiFramework: UIFramework = try config.uiFramework(for: .uiKit)
            let kind: UIFramework.Kind = uiFramework.kind
            let node: StencilTemplate.Node = .init(for: .variation(for: kind))
            let context: NodeStencilContext = try .init(
                preset: preset,
                fileHeader: fileHeader,
                analyticsImports: node.analytics.imports(with: config, including: uiFramework),
                builderImports: node.builder.imports(with: config, including: uiFramework),
                contextImports: node.context.imports(with: config, including: uiFramework),
                flowImports: node.flow.imports(with: config, including: uiFramework),
                stateImports: node.state.imports(with: config, including: uiFramework),
                viewControllerImports: node.viewController.imports(with: config, including: uiFramework),
                viewStateImports: node.viewState.imports(with: config, including: uiFramework),
                analyticsTestsImports: node.analyticsTests.imports(with: config, including: uiFramework),
                contextTestsImports: node.contextTests.imports(with: config, including: uiFramework),
                flowTestsImports: node.flowTests.imports(with: config, including: uiFramework),
                viewControllerTestsImports: node.viewControllerTests.imports(with: config, including: uiFramework),
                viewStateFactoryTestsImports: node.viewStateFactoryTests.imports(with: config, including: uiFramework),
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
            output = try StencilRenderer().renderNode(context: context, kind: kind)
        }
        for (file, contents): (String, String) in output.sorted(by: { $0.key < $1.key }) {
            let url: URL = directory
                .appendingPathComponent("\(preset.nodeName)\(file)")
                .appendingPathExtension("swift")
            try fileSystem.write(Data(contents.utf8), to: url, atomically: true)
        }
    }
}
