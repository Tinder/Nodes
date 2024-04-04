//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal enum XcodeTemplateConstants {

    internal static let fileBaseName: String = "___FILEBASENAME___"
    internal static let fileHeader: String = "___FILEHEADER___"

    internal static let productName: String = "productName"
    internal static let usePluginList: String = "usePluginList"
    internal static let pluginListName: String = "pluginListName"

    internal static func variable(_ name: String) -> String {
        "___VARIABLE_\(name)___"
    }
}
