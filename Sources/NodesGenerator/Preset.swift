//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

public enum Preset: String {

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
}
