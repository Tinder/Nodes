//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

public struct PluginStencilContext: StencilContext {

    private let fileHeader: String
    private let pluginName: String
    private let pluginImports: [String]
    private let pluginTestsImports: [String]
    private let isPeripheryCommentEnabled: Bool
    private let isNimbleEnabled: Bool

    internal var dictionary: [String: Any] {
        [
            "file_header": fileHeader,
            "plugin_name": pluginName,
            "plugin_imports": pluginImports,
            "plugin_tests_imports": pluginTestsImports,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled,
            "is_nimble_enabled": isNimbleEnabled
        ]
    }

    public init(
        fileHeader: String,
        pluginName: String,
        pluginImports: Set<String>,
        pluginTestsImports: Set<String>,
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.pluginName = pluginName
        self.pluginImports = pluginImports.sortedImports()
        self.pluginTestsImports = pluginTestsImports.sortedImports()
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }
}
