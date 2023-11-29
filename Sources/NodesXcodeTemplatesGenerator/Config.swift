//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Codextended
import Foundation
import Yams

public struct Config: Equatable, Codable {

    public enum ConfigError: LocalizedError, Equatable {

        case uiFrameworkNotDefined(kind: UIFramework.Kind)

        public var errorDescription: String? {
            switch self {
            case let .uiFrameworkNotDefined(kind):
                return "ERROR: UIFramework Not Defined [`kind: \(kind)`]"
            }
        }
    }

    internal enum ImportsType {

        case nodes, diGraph, viewController(UIFramework)
    }

    public var uiFrameworks: [UIFramework]
    public var fileHeader: String
    public var baseImports: Set<String>
    public var baseTestImports: Set<String>
    public var reactiveImports: Set<String>
    public var dependencyInjectionImports: Set<String>
    public var dependencies: [Variable]
    public var analyticsProperties: [Variable]
    public var flowProperties: [Variable]
    public var viewControllableType: String
    public var viewControllableFlowType: String
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
    public var isPreviewProviderEnabled: Bool
    public var isTestTemplatesGenerationEnabled: Bool
    public var isPeripheryCommentEnabled: Bool

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

    public func uiFramework(for kind: UIFramework.Kind) throws -> UIFramework {
        guard let uiFramework: UIFramework = uiFrameworks.first(where: { $0.framework.kind == kind })
        else { throw ConfigError.uiFrameworkNotDefined(kind: kind) }
        return uiFramework
    }
}

// swiftlint:disable:next no_grouping_extension
extension Config {

    public init() {
        uiFrameworks = [UIFramework(framework: .uiKit), UIFramework(framework: .swiftUI)]
        fileHeader = "//___FILEHEADER___"
        baseImports = []
        baseTestImports = ["Nimble", "XCTest"]
        reactiveImports = ["Combine"]
        dependencyInjectionImports = ["NeedleFoundation"]
        dependencies = []
        analyticsProperties = []
        flowProperties = []
        viewControllableType = "ViewControllable"
        viewControllableFlowType = "ViewControllableFlow"
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
        viewStatePropertyComment = "The view state publisher"
        viewStatePropertyName = "statePublisher"
        viewStateTransform = """
            Publishers.Map(upstream: context.$state, transform: viewStateFactory).eraseToAnyPublisher()
            """
        publisherType = "AnyPublisher"
        publisherFailureType = "Never"
        contextGenericTypes = ["AnyCancellable"]
        workerGenericTypes = ["AnyCancellable"]
        isViewInjectedTemplateEnabled = true
        isPreviewProviderEnabled = false
        isTestTemplatesGenerationEnabled = false
        isPeripheryCommentEnabled = false
    }
}

// swiftlint:disable:next no_grouping_extension
extension Config {

    // swiftlint:disable:next function_body_length
    public init(from decoder: Decoder) throws {
        let defaults: Config = .init()
        uiFrameworks =
            (try? decoder.decode(CodingKeys.uiFrameworks))
            ?? defaults.uiFrameworks
        fileHeader =
            (try? decoder.decodeString(CodingKeys.fileHeader))
            ?? defaults.fileHeader
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
        dependencies =
            (try? decoder.decode(CodingKeys.dependencies))
            ?? defaults.dependencies
        analyticsProperties =
            (try? decoder.decode(CodingKeys.analyticsProperties))
            ?? defaults.analyticsProperties
        flowProperties =
            (try? decoder.decode(CodingKeys.flowProperties))
            ?? defaults.flowProperties
        viewControllableType =
            (try? decoder.decodeString(CodingKeys.viewControllableType))
            ?? defaults.viewControllableType
        viewControllableFlowType =
            (try? decoder.decodeString(CodingKeys.viewControllableFlowType))
            ?? defaults.viewControllableFlowType
        viewControllerSubscriptionsProperty =
            (try? decoder.decodeString(CodingKeys.viewControllerSubscriptionsProperty))
            ?? defaults.viewControllerSubscriptionsProperty
        viewControllerUpdateComment =
            (try? decoder.decodeString(CodingKeys.viewControllerUpdateComment))
            ?? defaults.viewControllerUpdateComment
        viewStateEmptyFactory =
            (try? decoder.decodeString(CodingKeys.viewStateEmptyFactory))
            ?? defaults.viewStateEmptyFactory
        viewStateOperators =
            (try? decoder.decodeString(CodingKeys.viewStateOperators))
            ?? defaults.viewStateOperators
        viewStatePropertyComment =
            (try? decoder.decodeString(CodingKeys.viewStatePropertyComment))
            ?? defaults.viewStatePropertyComment
        viewStatePropertyName =
            (try? decoder.decodeString(CodingKeys.viewStatePropertyName))
            ?? defaults.viewStatePropertyName
        viewStateTransform =
            (try? decoder.decodeString(CodingKeys.viewStateTransform))
            ?? defaults.viewStateTransform
        publisherType =
            (try? decoder.decodeString(CodingKeys.publisherType))
            ?? defaults.publisherType
        publisherFailureType =
            (try? decoder.decodeString(CodingKeys.publisherFailureType))
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
        isPreviewProviderEnabled =
            (try? decoder.decode(CodingKeys.isPreviewProviderEnabled))
            ?? defaults.isPreviewProviderEnabled
        isTestTemplatesGenerationEnabled =
            (try? decoder.decode(CodingKeys.isTestTemplatesGenerationEnabled))
            ?? defaults.isTestTemplatesGenerationEnabled
        isPeripheryCommentEnabled =
            (try? decoder.decode(CodingKeys.isPeripheryCommentEnabled))
            ?? defaults.isPeripheryCommentEnabled
    }
}
