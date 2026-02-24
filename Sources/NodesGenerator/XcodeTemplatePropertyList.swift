//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Foundation

internal struct XcodeTemplatePropertyList: Codable, Equatable {

    internal struct Option: Codable, Equatable {

        // swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {

            case identifier = "Identifier"
            case required = "Required"
            case name = "Name"
            case description = "Description"
            case type = "Type"
            case notPersisted = "NotPersisted"
            case values = "Values"
            case requiredOptions = "RequiredOptions"
            case `default` = "Default"
        }

        internal let identifier: String
        internal let required: Bool
        internal let name: String
        internal let description: String
        internal let type: String
        internal let notPersisted: Bool
        internal let values: [String]
        internal let requiredOptions: [String: [String]]
        internal let `default`: String?

        internal init(
            identifier: String,
            name: String,
            description: String,
            type: String = "text",
            values: [String] = [],
            requiredOptions: [String: [String]] = [:],
            default: String? = nil
        ) {
            self.identifier = identifier
            self.required = true
            self.name = name
            self.description = description
            self.type = type
            self.notPersisted = true
            self.values = values
            self.requiredOptions = requiredOptions
            self.default = `default`
        }
    }

    @resultBuilder
    internal enum OptionBuilder {

        // swiftlint:disable:next nesting
        internal typealias Expression = Option

        // swiftlint:disable:next nesting
        internal typealias Component = [Option]

        // swiftlint:disable:next nesting
        internal typealias FinalResult = [Option]

        internal static func buildExpression(_ expression: Expression?) -> Component {
            guard let expression: Expression
            else { return [] }
            return [expression]
        }

        internal static func buildExpression(_ component: Component?) -> Component {
            guard let component: Component
            else { return [] }
            return component
        }

        internal static func buildBlock(_ components: Component...) -> Component {
            components.flatMap(\.self)
        }

        internal static func buildOptional(_ component: Component?) -> Component {
            component ?? []
        }

        internal static func buildEither(first component: Component) -> Component {
            component
        }

        internal static func buildEither(second component: Component) -> Component {
            component
        }

        internal static func buildArray(_ components: [Component]) -> Component {
            components.flatMap(\.self)
        }

        internal static func buildLimitedAvailability(_ component: Component) -> Component {
            component
        }

        internal static func buildFinalResult(_ component: Component) -> FinalResult {
            component
        }
    }

    private enum CodingKeys: String, CodingKey {

        case kind = "Kind"
        case sortOrder = "SortOrder"
        case allowedTypes = "AllowedTypes"
        case supportsSwiftPackage = "SupportsSwiftPackage"
        case platforms = "Platforms"
        case mainTemplateFile = "MainTemplateFile"
        case options = "Options"
    }

    internal let kind: String
    internal let sortOrder: Int
    internal let allowedTypes: [String]
    internal let supportsSwiftPackage: Bool
    internal let platforms: [String]
    internal let mainTemplateFile: String
    internal let options: [Option]

    internal init(sortOrder: Int, @OptionBuilder build: () -> [Option]) {
        self.kind = "Xcode.IDEFoundation.TextSubstitutionFileTemplateKind"
        self.sortOrder = sortOrder
        self.allowedTypes = ["public.swift-source"]
        self.supportsSwiftPackage = true
        self.platforms = []
        self.mainTemplateFile = "\(XcodeTemplateConstants.fileBaseName).swift"
        self.options = build()
    }

    internal func encode(outputFormat: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        let encoder: PropertyListEncoder = .init()
        encoder.outputFormat = outputFormat
        return try encoder.encode(self)
    }
}
