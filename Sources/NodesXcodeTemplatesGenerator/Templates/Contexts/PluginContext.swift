//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct PluginContext: Context {

    private let fileHeader: String
    private let pluginName: String
    private let returnType: String?
    private let pluginImports: [String]
    private let isDocumentationEnabled: Bool
    private let isPeripheryCommentEnabled: Bool

    internal var dictionary: [String: Any] {
        var dictionary: [String: Any] = [
            "file_header": fileHeader,
            "plugin_name": pluginName,
            "plugin_imports": pluginImports,
            "is_documentation_enabled": isDocumentationEnabled,
            "is_periphery_comment_enabled": isPeripheryCommentEnabled
        ]
        if let returnType: String {
            dictionary["return_type"] = returnType
        }
        return dictionary
    }

    public init(
        fileHeader: String,
        pluginName: String,
        pluginImports: Set<String>,
        isDocumentationEnabled: Bool,
        isPeripheryCommentEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.pluginName = pluginName
        self.returnType = nil
        self.pluginImports = pluginImports.sortedImports()
        self.isDocumentationEnabled = isDocumentationEnabled
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
    }

    public init(
        fileHeader: String,
        pluginName: String,
        returnType: String,
        pluginImports: Set<String>,
        isDocumentationEnabled: Bool,
        isPeripheryCommentEnabled: Bool
    ) {
        self.fileHeader = fileHeader
        self.pluginName = pluginName
        self.returnType = returnType
        self.pluginImports = pluginImports.sortedImports()
        self.isDocumentationEnabled = isDocumentationEnabled
        self.isPeripheryCommentEnabled = isPeripheryCommentEnabled
    }
}
