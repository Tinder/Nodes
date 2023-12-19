//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

@testable import NodesXcodeTemplatesGenerator
import XCTest

final class UIFrameworkDefaultsTests: XCTestCase {

    func testDefaults() {
        let framework: UIFramework.Framework = .custom(name: "<uiFrameworkName>",
                                                       import: "<uiFrameworkImport>",
                                                       viewControllerType: "<viewControllerType>",
                                                       viewControllerSuperParameters: "<viewControllerSuperParameters>")
        assertSnapshot(of: UIFramework.makeDefaultFramework(for: framework), as: .dump)
    }

    func testDefaultsAppKit() {
        assertSnapshot(of: UIFramework.makeDefaultAppKitFramework(), as: .dump)
    }

    func testDefaultsUIKit() {
        assertSnapshot(of: UIFramework.makeDefaultUIKitFramework(), as: .dump)
    }

    func testDefaultsSwiftUI() {
        assertSnapshot(of: UIFramework.makeDefaultSwiftUIFramework(), as: .dump)
    }
}
