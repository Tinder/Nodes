//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct PluginStencilContext: StencilContext {

    private let fileHeader: String
    private let pluginName: String
    private let returnType: String?
    private let pluginImports: [String]
    private let pluginTestsImports: [String]
    private let isPeripheryCommentEnabled: Bool
    private let isNimbleEnabled: Bool

    internal var dictionary: [String: Any] {
        let dictionary: [String: Any]
        if let returnType: String {
            dictionary = [
                "file_header": fileHeader,
                "plugin_name": pluginName,
                "return_type": returnType,
                "plugin_imports": pluginImports,
                "plugin_tests_imports": pluginTestsImports,
                "is_periphery_comment_enabled": isPeripheryCommentEnabled,
                "is_nimble_enabled": isNimbleEnabled
            ]
        } else {
            dictionary = [
                "file_header": fileHeader,
                "plugin_name": pluginName,
                "plugin_imports": pluginImports,
                "plugin_tests_imports": pluginTestsImports,
                "is_periphery_comment_enabled": isPeripheryCommentEnabled,
                "is_nimble_enabled": isNimbleEnabled
            ]
        }
        return dictionary
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
        self.returnType = nil
        self.pluginImports = pluginImports.sortedImports()
        self.pluginTestsImports = pluginTestsImports.sortedImports()
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }

    public init(
        fileHeader: String,
        pluginName: String,
        returnType: String,
        pluginImports: Set<String>,
        pluginTestsImports: Set<String>,
        isPeripheryCommentEnabled: Bool,
        isNimbleEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.pluginName = pluginName
        self.returnType = returnType
        self.pluginImports = pluginImports.sortedImports()
        self.pluginTestsImports = pluginTestsImports.sortedImports()
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
        self.isNimbleEnabled = isNimbleEnabled
    }
}
