//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Foundation

internal struct XcodeTemplatePropertyList: Equatable, Codable {

    internal struct Option: Equatable, Codable {

        // swiftlint:disable:next nesting
        private enum CodingKeys: String, CodingKey {

            case identifier = "Identifier"
            case required = "Required"
            case name = "Name"
            case description = "Description"
            case type = "Type"
            case notPersisted = "NotPersisted"
            case `default` = "Default"
        }

        internal let identifier: String
        internal let required: Bool
        internal let name: String
        internal let description: String
        internal let type: String
        internal let notPersisted: Bool
        internal let `default`: String?

        internal init(
            identifier: String,
            name: String,
            description: String,
            default: String? = nil
        ) {
            self.identifier = identifier
            self.required = true
            self.name = name
            self.description = description
            self.type = "text"
            self.notPersisted = true
            self.default = `default`
        }
    }

    @resultBuilder
    internal enum OptionBuilder {

        // swiftlint:disable:next nesting
        internal typealias Component = [Option]

        // swiftlint:disable:next nesting
        internal typealias Expression = Option

        internal static func buildExpression(_ element: Expression) -> Component {
            [element]
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
            Array(components.joined())
        }

        internal static func buildBlock(_ components: Component...) -> Component {
            Array(components.joined())
        }
    }

    private enum CodingKeys: String, CodingKey {

        case kind = "Kind"
        case description = "Description"
        case summary = "Summary"
        case sortOrder = "SortOrder"
        case allowedTypes = "AllowedTypes"
        case supportsSwiftPackage = "SupportsSwiftPackage"
        case platforms = "Platforms"
        case mainTemplateFile = "MainTemplateFile"
        case options = "Options"
    }

    internal let kind: String
    internal let description: String
    internal let summary: String
    internal let sortOrder: Int
    internal let allowedTypes: [String]
    internal let supportsSwiftPackage: Bool
    internal let platforms: [String]
    internal let mainTemplateFile: String
    internal let options: [Option]

    internal init(description: String, sortOrder: Int, @OptionBuilder build: () -> [Option]) {
        self.kind = "Xcode.IDEFoundation.TextSubstitutionFileTemplateKind"
        self.description = description
        self.summary = description.replacingOccurrences(of: "[.]+$", with: "", options: .regularExpression)
        self.sortOrder = sortOrder
        self.allowedTypes = ["public.swift-source"]
        self.supportsSwiftPackage = true
        self.platforms = []
        self.mainTemplateFile = "___FILEBASENAME___.swift"
        self.options = build()
    }

    internal func encode(outputFormat: PropertyListSerialization.PropertyListFormat = .xml) throws -> Data {
        let encoder: PropertyListEncoder = .init()
        encoder.outputFormat = outputFormat
        return try encoder.encode(self)
    }
}
