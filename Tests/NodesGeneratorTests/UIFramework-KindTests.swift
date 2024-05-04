// swiftlint:disable:this file_name
//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Nimble
import NodesGenerator
import XCTest

final class UIFrameworkKindTests: XCTestCase {

    func testAllCases() {
        expect(UIFramework.Kind.allCases) == [.appKit, .uiKit, .uiKitSwiftUI, .custom]
    }

    func testRawValues() {
        expect(UIFramework.Kind.allCases.map(\.rawValue)) == ["AppKit", "UIKit", "UIKit (SwiftUI)", "Custom"]
    }

    func testNames() {
        expect(UIFramework.Kind.allCases.map(\.name)) == ["AppKit", "UIKit", "UIKit (SwiftUI)", "Custom"]
    }

    func testIsHostingSwiftUI() {
        UIFramework.Kind.allCases.forEach { kind in
            switch kind {
            case .appKit, .uiKit, .custom:
                expect(kind.isHostingSwiftUI) == false
            case .uiKitSwiftUI:
                expect(kind.isHostingSwiftUI) == true
            }
        }
    }
}
