//
//  Config.swift
//  NodesXcodeTemplatesGenerator
//
//  Created by Christopher Fuller on 6/3/21.
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
        public var isViewInjectedNodeEnabled: Bool
        public var fileHeader: String
        public var baseImports: Set<String>
        public var reactiveImports: Set<String>
        public var dependencyInjectionImports: Set<String>
        public var dependencies: [Variable]
        public var analyticsDependencies: [Variable]
        public var flowProperties: [Variable]
        public var viewControllableType: String
        public var viewControllableFlowType: String
        public var viewControllerUpdateComment: String
        public var viewStateOperators: String
        public var publisherType: String
        public var publisherFailureType: String
        public var cancellableType: String

        public init(
            at path: String,
            using fileSystem: FileSystem = FileManager.default
        ) throws {
            let url: URL = .init(fileURLWithPath: path)
            self = try fileSystem.contents(of: url).decoded(using: YAMLDecoder())
        }

        public func uiFramework(for kind: UIFramework.Kind) throws -> UIFramework {
            guard let uiFramework: UIFramework = uiFrameworks.first(where: { $0.framework.kind == kind }) else {
                throw ConfigError.uiFrameworkNotDefined(kind: kind)
            }
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
        isViewInjectedNodeEnabled = true
        fileHeader = "//___FILEHEADER___"
        baseImports = []
        reactiveImports = ["Combine"]
        dependencyInjectionImports = ["NeedleFoundation"]
        dependencies = []
        analyticsDependencies = []
        flowProperties = []
        viewControllableType = "ViewControllable"
        viewControllableFlowType = "ViewControllableFlow"
        viewControllerUpdateComment = """
            // Add implementation to update the user interface when the view state changes.
            """
        viewStateOperators = """
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            """
        publisherType = "AnyPublisher"
        publisherFailureType = ", Never"
        cancellableType = "AnyCancellable"
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
        isViewInjectedNodeEnabled =
            (try? decoder.decode(CodingKeys.isViewInjectedNodeEnabled))
            ?? defaults.isViewInjectedNodeEnabled
        fileHeader =
            (try? decoder.decodeString(CodingKeys.fileHeader))
            ?? defaults.fileHeader
        baseImports =
            (try? decoder.decode(CodingKeys.baseImports))
            ?? defaults.baseImports
        reactiveImports =
            (try? decoder.decode(CodingKeys.reactiveImports))
            ?? defaults.reactiveImports
        dependencyInjectionImports =
            (try? decoder.decode(CodingKeys.dependencyInjectionImports))
            ?? defaults.dependencyInjectionImports
        dependencies =
            (try? decoder.decode(CodingKeys.dependencies))
            ?? defaults.dependencies
        analyticsDependencies =
            (try? decoder.decode(CodingKeys.analyticsDependencies))
            ?? defaults.analyticsDependencies
        flowProperties =
            (try? decoder.decode(CodingKeys.flowProperties))
            ?? defaults.flowProperties
        viewControllableType =
            (try? decoder.decodeString(CodingKeys.viewControllableType))
            ?? defaults.viewControllableType
        viewControllableFlowType =
            (try? decoder.decodeString(CodingKeys.viewControllableFlowType))
            ?? defaults.viewControllableFlowType
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
    }
}
