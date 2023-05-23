//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest

final class UIFrameworkDefaultsTests: XCTestCase {

    func testDefaults() {
        let framework: UIFramework.Framework = .custom(name: "<uiFrameworkName>",
                                                       import: "<uiFrameworkImport>",
                                                       viewControllerType: "<viewControllerType>",
                                                       viewControllerSuperParameters: "<viewControllerSuperParameters>")
        assertSnapshot(matching: UIFramework.makeDefaultFramework(for: framework), as: .dump)
    }

    func testDefaultsAppKit() {
        assertSnapshot(matching: UIFramework.makeDefaultAppKitFramework(), as: .dump)
    }

    func testDefaultsUIKit() {
        assertSnapshot(matching: UIFramework.makeDefaultUIKitFramework(), as: .dump)
    }

    func testDefaultsSwiftUI() {
        assertSnapshot(matching: UIFramework.makeDefaultSwiftUIFramework(), as: .dump)
    }
}
