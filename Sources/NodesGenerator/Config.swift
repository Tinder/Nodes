//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Codextended
import Foundation
import Yams

public struct Config: Codable, Equatable {

    public enum ConfigError: LocalizedError, Equatable {

        case emptyStringNotAllowed(key: String)

        public var errorDescription: String? {
            switch self {
            case let .emptyStringNotAllowed(key):
                let tip: String = "Omit from config for the default value to be used instead"
                return "ERROR: Empty String Not Allowed [key: \(key)] (TIP: \(tip))"
            }
        }
    }

    internal enum ImportsType {

        case nodes, diGraph, viewController(UIFramework)
    }

    public var uiFrameworks: [UIFramework]
    public var baseImports: Set<String>
    public var baseTestImports: Set<String>
    public var reactiveImports: Set<String>
    public var dependencyInjectionImports: Set<String>
    public var builderImports: Set<String>
    public var flowImports: Set<String>
    public var pluginListImports: Set<String>
    public var viewControllerImports: Set<String>
    public var dependencies: [Variable]
    public var analyticsProperties: [Variable]
    public var flowProperties: [Variable]
    public var viewControllableFlowType: String
    public var viewControllableType: String
    public var viewControllableMockContents: String
    public var viewControllerStaticContent: String
    public var viewControllerSubscriptionsProperty: String
    public var viewControllerUpdateComment: String
    public var viewStateEmptyFactory: String
    public var viewStateOperators: String
    public var viewStatePropertyComment: String
    public var viewStatePropertyName: String
    public var viewStateTransform: String
    public var publisherType: String
    public var publisherFailureType: String
    public var contextGenericTypes: [String]
    public var workerGenericTypes: [String]

    public var isViewInjectedTemplateEnabled: Bool
    public var isObservableStoreEnabled: Bool
    public var isPreviewProviderEnabled: Bool
    public var isTestTemplatesGenerationEnabled: Bool
    public var isPeripheryCommentEnabled: Bool

    public var storePrefix: String { isObservableStoreEnabled ? "Observable" : "" }
    public var isNimbleEnabled: Bool { baseTestImports.contains("Nimble") }

    public init(
        at path: String,
        using fileSystem: FileSystem = FileManager.default
    ) throws {
        let url: URL = .init(fileURLWithPath: path)
        let contents: Data = try fileSystem.contents(of: url)
        if contents.isEmpty {
            self.init()
        } else {
            self = try contents.decoded(using: YAMLDecoder())
        }
    }
}

// swiftlint:disable:next no_grouping_extension
extension Config {

    public init() {
        uiFrameworks = [UIFramework(framework: .uiKit), UIFramework(framework: .uiKitSwiftUI)]
        baseImports = []
        baseTestImports = ["Nimble", "XCTest"]
        reactiveImports = ["Combine"]
        dependencyInjectionImports = ["NeedleFoundation"]
        builderImports = []
        flowImports = []
        pluginListImports = []
        viewControllerImports = []
        dependencies = []
        analyticsProperties = []
        flowProperties = []
        viewControllableFlowType = "ViewControllableFlow"
        viewControllableType = "ViewControllable"
        viewControllableMockContents = ""
        viewControllerStaticContent = ""
        viewControllerSubscriptionsProperty = """
            /// The collection of cancellable instances.
            private var cancellables: Set<AnyCancellable> = .init()
            """
        viewControllerUpdateComment = """
            // Add implementation to update the user interface when the view state changes.
            """
        viewStateEmptyFactory = "Empty().eraseToAnyPublisher()"
        viewStateOperators = """
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            """
        viewStatePropertyComment = "The view state publisher."
        viewStatePropertyName = "statePublisher"
        viewStateTransform = "store.viewStatePublisher"
        publisherType = "AnyPublisher"
        publisherFailureType = "Never"
        contextGenericTypes = ["AnyCancellable"]
        workerGenericTypes = ["AnyCancellable"]
        isViewInjectedTemplateEnabled = true
        isObservableStoreEnabled = false
        isPreviewProviderEnabled = false
        isTestTemplatesGenerationEnabled = true
        isPeripheryCommentEnabled = false
    }
}

// swiftlint:disable:next no_grouping_extension
extension Config {

    // swiftlint:disable:next function_body_length
    public init(from decoder: Decoder) throws {

        let defaults: Config = .init()

        do {
            uiFrameworks = try decoder.decode(CodingKeys.uiFrameworks)
            if uiFrameworks.isEmpty {
                uiFrameworks = defaults.uiFrameworks
            }
        } catch let error as Config.ConfigError {
            throw error
        } catch {
            uiFrameworks = defaults.uiFrameworks
        }

        baseImports =
            (try? decoder.decode(CodingKeys.baseImports))
            ?? defaults.baseImports
        baseTestImports =
            (try? decoder.decode(CodingKeys.baseTestImports))
            ?? defaults.baseTestImports
        reactiveImports =
            (try? decoder.decode(CodingKeys.reactiveImports))
            ?? defaults.reactiveImports
        dependencyInjectionImports =
            (try? decoder.decode(CodingKeys.dependencyInjectionImports))
            ?? defaults.dependencyInjectionImports
        builderImports =
            (try? decoder.decode(CodingKeys.builderImports))
            ?? defaults.builderImports
        flowImports =
            (try? decoder.decode(CodingKeys.flowImports))
            ?? defaults.flowImports
        pluginListImports =
            (try? decoder.decode(CodingKeys.pluginListImports))
            ?? defaults.pluginListImports
        viewControllerImports =
            (try? decoder.decode(CodingKeys.viewControllerImports))
            ?? defaults.viewControllerImports
        dependencies =
            (try? decoder.decode(CodingKeys.dependencies))
            ?? defaults.dependencies
        analyticsProperties =
            (try? decoder.decode(CodingKeys.analyticsProperties))
            ?? defaults.analyticsProperties
        flowProperties =
            (try? decoder.decode(CodingKeys.flowProperties))
            ?? defaults.flowProperties
        viewControllableFlowType =
            (try? decoder.decode(CodingKeys.viewControllableFlowType))
            ?? defaults.viewControllableFlowType
        viewControllableType =
            (try? decoder.decode(CodingKeys.viewControllableType))
            ?? defaults.viewControllableType
        viewControllableMockContents =
            (try? decoder.decode(CodingKeys.viewControllableMockContents))
            ?? defaults.viewControllableMockContents
        viewControllerStaticContent =
            (try? decoder.decode(CodingKeys.viewControllerStaticContent))
            ?? defaults.viewControllerStaticContent
        viewControllerSubscriptionsProperty =
            (try? decoder.decode(CodingKeys.viewControllerSubscriptionsProperty))
            ?? defaults.viewControllerSubscriptionsProperty
        viewControllerUpdateComment =
            (try? decoder.decode(CodingKeys.viewControllerUpdateComment))
            ?? defaults.viewControllerUpdateComment
        viewStateEmptyFactory =
            (try? decoder.decode(CodingKeys.viewStateEmptyFactory))
            ?? defaults.viewStateEmptyFactory
        viewStateOperators =
            (try? decoder.decode(CodingKeys.viewStateOperators))
            ?? defaults.viewStateOperators
        viewStatePropertyComment =
            (try? decoder.decode(CodingKeys.viewStatePropertyComment))
            ?? defaults.viewStatePropertyComment
        viewStatePropertyName =
            (try? decoder.decode(CodingKeys.viewStatePropertyName))
            ?? defaults.viewStatePropertyName
        viewStateTransform =
            (try? decoder.decode(CodingKeys.viewStateTransform))
            ?? defaults.viewStateTransform
        publisherType =
            (try? decoder.decode(CodingKeys.publisherType))
            ?? defaults.publisherType
        publisherFailureType =
            (try? decoder.decode(CodingKeys.publisherFailureType))
            ?? defaults.publisherFailureType
        contextGenericTypes =
            (try? decoder.decode(CodingKeys.contextGenericTypes))
            ?? defaults.contextGenericTypes
        workerGenericTypes =
            (try? decoder.decode(CodingKeys.workerGenericTypes))
            ?? defaults.workerGenericTypes
        isViewInjectedTemplateEnabled =
            (try? decoder.decode(CodingKeys.isViewInjectedTemplateEnabled))
            ?? defaults.isViewInjectedTemplateEnabled
        isObservableStoreEnabled =
            (try? decoder.decode(CodingKeys.isObservableStoreEnabled))
            ?? defaults.isObservableStoreEnabled
        isPreviewProviderEnabled =
            (try? decoder.decode(CodingKeys.isPreviewProviderEnabled))
            ?? defaults.isPreviewProviderEnabled
        isTestTemplatesGenerationEnabled =
            (try? decoder.decode(CodingKeys.isTestTemplatesGenerationEnabled))
            ?? defaults.isTestTemplatesGenerationEnabled
        isPeripheryCommentEnabled =
            (try? decoder.decode(CodingKeys.isPeripheryCommentEnabled))
            ?? defaults.isPeripheryCommentEnabled

        try validateRequiredStrings()
    }

    private func validateRequiredStrings() throws {
        let required: [(key: String, value: String)] = [
            (key: "publisherType", value: publisherType),
            (key: "viewControllableFlowType", value: viewControllableFlowType),
            (key: "viewControllableType", value: viewControllableType),
            (key: "viewControllerSubscriptionsProperty", value: viewControllerSubscriptionsProperty),
            (key: "viewStateEmptyFactory", value: viewStateEmptyFactory),
            (key: "viewStatePropertyComment", value: viewStatePropertyComment),
            (key: "viewStatePropertyName", value: viewStatePropertyName),
            (key: "viewStateTransform", value: viewStateTransform)
        ]
        for (key, value): (String, String) in required
        where value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ConfigError.emptyStringNotAllowed(key: key)
        }
    }
}
