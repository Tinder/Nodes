//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

public enum NodePreset: String {

    case app = "App"
    case scene = "Scene"
    case window = "Window"
    case root = "Root"

    public var nodeName: String {
        rawValue
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
