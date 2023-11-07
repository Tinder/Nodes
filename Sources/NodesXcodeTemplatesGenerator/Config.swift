//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Codextended
import Foundation
import Yams

extension XcodeTemplates {

    public struct Config: Equatable, Codable {

        // swiftlint:disable:next nesting
        public enum ConfigError: Error, Equatable {
            case uiFrameworkNotDefined(kind: UIFramework.Kind)
        }

        // swiftlint:disable:next nesting
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
        public var viewControllableMockContents: String
        public var viewControllerUpdateComment: String
        public var viewStateOperators: String
        public var publisherType: String
        public var publisherFailureType: String
        public var cancellableType: String
        public var isPeripheryCommentEnabled: Bool
        public var isViewInjectedTemplateEnabled: Bool

        public init(
            at path: String,
            using fileSystem: FileSystem = FileManager.default
        ) throws {
            let url: URL = .init(fileURLWithPath: path)
            self = try fileSystem.contents(of: url).decoded(using: YAMLDecoder())
        }

        public func uiFramework(for kind: UIFramework.Kind) throws -> UIFramework {
            guard let uiFramework: UIFramework = uiFrameworks.first(where: { $0.framework.kind == kind })
            else { throw ConfigError.uiFrameworkNotDefined(kind: kind) }
            return uiFramework
        }

        internal func variable(_ name: String) -> String {
            "___VARIABLE_\(name)___"
        }
    }
}

// swiftlint:disable:next no_grouping_extension
extension XcodeTemplates.Config {

    public init() {
        uiFrameworks = [UIFramework(framework: .uiKit), UIFramework(framework: .swiftUI)]
        fileHeader = "//___FILEHEADER___"
        baseImports = []
        baseTestImports = ["XCTest"]
        reactiveImports = ["Combine"]
        dependencyInjectionImports = ["NeedleFoundation"]
        dependencies = []
        analyticsProperties = []
        flowProperties = []
        viewControllableType = "ViewControllable"
        viewControllableFlowType = "ViewControllableFlow"
        viewControllableMockContents = ""
        viewControllerUpdateComment = """
            // Add implementation to update the user interface when the view state changes.
            """
        viewStateOperators = """
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            """
        publisherType = "AnyPublisher"
        publisherFailureType = "Never"
        cancellableType = "AnyCancellable"
        isPeripheryCommentEnabled = false
        isViewInjectedTemplateEnabled = true
    }
}

// swiftlint:disable:next no_grouping_extension
extension XcodeTemplates.Config {

    // swiftlint:disable:next function_body_length
    public init(from decoder: Decoder) throws {
        let defaults: XcodeTemplates.Config = .init()
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
        viewControllableMockContents =
            (try? decoder.decodeString(CodingKeys.viewControllableMockContents))
            ?? defaults.viewControllableMockContents
        viewControllerUpdateComment =
            (try? decoder.decodeString(CodingKeys.viewControllerUpdateComment))
            ?? defaults.viewControllerUpdateComment
        viewStateOperators =
            (try? decoder.decodeString(CodingKeys.viewStateOperators))
            ?? defaults.viewStateOperators
        publisherType =
            (try? decoder.decodeString(CodingKeys.publisherType))
            ?? defaults.publisherType
        publisherFailureType =
            (try? decoder.decodeString(CodingKeys.publisherFailureType))
            ?? defaults.publisherFailureType
        cancellableType =
            (try? decoder.decodeString(CodingKeys.cancellableType))
            ?? defaults.cancellableType
        isPeripheryCommentEnabled =
            (try? decoder.decode(CodingKeys.isPeripheryCommentEnabled))
            ?? defaults.isPeripheryCommentEnabled
        isViewInjectedTemplateEnabled =
            (try? decoder.decode(CodingKeys.isViewInjectedTemplateEnabled))
            ?? defaults.isViewInjectedTemplateEnabled
    }
}
