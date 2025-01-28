//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

public enum Preset: String, CaseIterable {

    case app = "App"
    case scene = "Scene"
    case window = "Window"
    case root = "Root"

    public var nodeName: String {
        self == .scene ? "Window\(rawValue)" : rawValue
    }

    public var isViewInjected: Bool {
        switch self {
        case .app:
            return true
        case .scene:
            return true
        case .window:
            return true
        case .root:
            return false
        }
    }

    internal var componentDependencies: String {
        self == .app ? "fileprivate let appService: AppService = AppServiceImp()" : ""
    }

    internal static func isPresetNodeName(_ nodeName: String) -> Bool {
        allCases.map(\.nodeName).contains(nodeName)
    }
}
