//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Codextended
import Nimble
@testable import NodesXcodeTemplatesGenerator
import SnapshotTesting
import XCTest
import Yams

final class UIFrameworkFrameworkTests: XCTestCase {

    func testAppKit() {
        let appKit: UIFramework.Framework = .appKit
        expect(appKit.kind) == .appKit
        expect(appKit.name) == "AppKit"
        expect(appKit.import) == "AppKit"
        expect(appKit.viewControllerType) == "NSViewController"
    }

    func testUIKit() {
        let uiKit: UIFramework.Framework = .uiKit
        expect(uiKit.kind) == .uiKit
        expect(uiKit.name) == "UIKit"
        expect(uiKit.import) == "UIKit"
        expect(uiKit.viewControllerType) == "UIViewController"
    }

    func testSwiftUI() {
        let swiftUI: UIFramework.Framework = .swiftUI
        expect(swiftUI.kind) == .swiftUI
        expect(swiftUI.name) == "SwiftUI"
        expect(swiftUI.import) == "SwiftUI"
        expect(swiftUI.viewControllerType) == "UIHostingController"
    }

    func testCustom() {
        let custom: UIFramework.Framework = .custom(name: "<uiFrameworkName>",
                                                    import: "<uiFrameworkImport>",
                                                    viewControllerType: "<viewControllerType>",
                                                    viewControllerSuperParameters: "<viewControllerSuperParameters>")
        expect(custom.kind) == .custom
        expect(custom.name) == "<uiFrameworkName>"
        expect(custom.import) == "<uiFrameworkImport>"
        expect(custom.viewControllerType) == "<viewControllerType>"
    }

    func testFrameworkInitFromDecoder() throws {
        let frameworks: [UIFramework.Framework] = [
            .appKit,
            .uiKit,
            .swiftUI,
            .custom(name: "<uiFrameworkName>",
                    import: "<uiFrameworkImport>",
                    viewControllerType: "<viewControllerType>",
                    viewControllerSuperParameters: "<viewControllerSuperParameters>")
        ]
        try frameworks.forEach { framework in
            let data: Data = .init(givenYAML(for: framework).utf8)
            expect(try data.decoded(as: UIFramework.Framework.self, using: YAMLDecoder())) == framework
        }
    }

    func testFrameworkInitFromDecoderThrowsError() throws {
        try ["Custom", "AnyUnsupportedFrameworkName", "custom:\ncustom:\n", "[]"]
            .map(\.utf8)
            .map(Data.init(_:))
            .forEach { data in
                expect(try data.decoded(as: UIFramework.Framework.self, using: YAMLDecoder())).to(throwError { error in
                    assertSnapshot(matching: error, as: .dump)
                })
            }
    }

    private func givenYAML(for framework: UIFramework.Framework) -> String {
        switch framework {
        case .appKit, .uiKit, .swiftUI:
            return framework.name
        case let .custom(name, `import`, viewControllerType, viewControllerSuperParameters):
            return """
                custom:
                  name: \(name)
                  import: \(`import`)
                  viewControllerType: \(viewControllerType)
                  viewControllerSuperParameters: \(viewControllerSuperParameters)
                """
        }
    }
}
