//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal enum XcodeTemplateConstants {

    internal static let fileBaseName: String = "___FILEBASENAME___"
    internal static let fileHeader: String = "___FILEHEADER___"

    // Apple requires the product name identifier to be camel case.
    internal static let productName: String = "productName"

    // Custom identifiers use pascal case for readability.
    internal static let uiFramework: String = "UIFramework"
    internal static let createdForPluginList: String = "CreatedForPluginList"
    internal static let pluginListName: String = "PluginListName"

    internal static func variable(_ name: String) -> String {
        "___VARIABLE_\(name)___"
    }
}
