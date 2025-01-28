// swiftlint:disable:this file_name
//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Nimble
import NodesGenerator
import XCTest

final class UIFrameworkKindTests: XCTestCase {

    func testAllCases() {
        expect(UIFramework.Kind.allCases) == [
            .appKit,
            .appKitSwiftUI,
            .uiKit,
            .uiKitSwiftUI,
            .custom
        ]
    }

    func testRawValues() {
        expect(UIFramework.Kind.allCases.map(\.rawValue)) == [
            "AppKit",
            "AppKit (SwiftUI)",
            "UIKit",
            "UIKit (SwiftUI)",
            "Custom"
        ]
    }

    func testNames() {
        expect(UIFramework.Kind.allCases.map(\.name)) == [
            "AppKit",
            "AppKit (SwiftUI)",
            "UIKit",
            "UIKit (SwiftUI)",
            "Custom"
        ]
    }

    func testIsHostingSwiftUI() {
        UIFramework.Kind.allCases.forEach { kind in
            switch kind {
            case .appKitSwiftUI, .uiKitSwiftUI:
                expect(kind.isHostingSwiftUI) == true
            case .appKit, .uiKit, .custom:
                expect(kind.isHostingSwiftUI) == false
            }
        }
    }
}
