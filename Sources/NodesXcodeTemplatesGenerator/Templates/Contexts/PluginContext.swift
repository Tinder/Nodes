//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

public struct PluginContext: Context {

    private let fileHeader: String
    private let pluginName: String
    private let returnType: String?
    private let pluginImports: [String]
    private let includePeripheryIgnores: Bool

    internal var dictionary: [String: Any] {
        let dictionary: [String: Any]
        if let returnType: String {
            dictionary = [
                "file_header": fileHeader,
                "plugin_name": pluginName,
                "return_type": returnType,
                "plugin_imports": pluginImports,
                "include_periphery_ignores": includePeripheryIgnores
            ]
        } else {
            dictionary = [
                "file_header": fileHeader,
                "plugin_name": pluginName,
                "plugin_imports": pluginImports,
                "include_periphery_ignores": includePeripheryIgnores
            ]
        }
        return dictionary
    }

    public init(
        fileHeader: String,
        pluginName: String,
        pluginImports: Set<String>,
        includePeripheryIgnores: Bool
    ) {
        self.fileHeader = fileHeader
        self.pluginName = pluginName
        self.returnType = nil
        self.pluginImports = pluginImports.sortedImports()
        self.includePeripheryIgnores = includePeripheryIgnores
    }

    public init(
        fileHeader: String,
        pluginName: String,
        returnType: String,
        pluginImports: Set<String>,
        includePeripheryIgnores: Bool
    ) {
        self.fileHeader = fileHeader
        self.pluginName = pluginName
        self.returnType = returnType
        self.pluginImports = pluginImports.sortedImports()
        self.includePeripheryIgnores = includePeripheryIgnores
    }
}
