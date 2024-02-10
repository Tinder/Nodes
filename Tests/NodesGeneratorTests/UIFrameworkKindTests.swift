//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Nimble
import NodesGenerator
import XCTest

final class UIFrameworkKindTests: XCTestCase {

    func testAllCases() {
        expect(UIFramework.Kind.allCases) == [.appKit, .uiKit, .swiftUI, .custom]
    }

    func testRawValues() {
        expect(UIFramework.Kind.allCases.map(\.rawValue)) == ["AppKit", "UIKit", "SwiftUI", "Custom"]
    }
}
