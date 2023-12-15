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
            expect(try YAMLDecoder().decode(UIFramework.Framework.self, from: data)) == framework
        }
    }

    func testFrameworkInitFromDecoderThrowsError() throws {
        try ["Custom", "AnyUnsupportedFrameworkName", "custom:\ncustom:\n", "[]"]
            .map(\.utf8)
            .map(Data.init(_:))
            .forEach { data in
                expect(try YAMLDecoder().decode(UIFramework.Framework.self, from: data)).to(throwError { error in
                    assertSnapshot(matching: error, as: .dump)
                })
            }
    }

    func testDecodingThrowsEmptyStringNotAllowed() throws {
        let requiredKeys: [(key: String, yaml: String)] = [
            (key: "name", yaml: givenCustomYAML(name: "")),
            (key: "import", yaml: givenCustomYAML(import: "")),
            (key: "viewControllerType", yaml: givenCustomYAML(viewControllerType: ""))
        ]
        for (key, yaml): (String, String) in requiredKeys {
            expect(try Data(yaml.utf8).decoded(as: UIFramework.Framework.self, using: YAMLDecoder()))
                .to(throwError(errorType: DecodingError.self) { error in
                    guard case let .dataCorrupted(context) = error,
                          let configError: Config.ConfigError = context.underlyingError as? Config.ConfigError
                    else { return fail("expected data corrupted case with underlying config error") }
                    expect(configError) == .emptyStringNotAllowed(key: key)
                    expect(configError.localizedDescription) == """
                        ERROR: Empty String Not Allowed [key: \(key)] \
                        (TIP: Omit from config for the default value to be used instead)
                        """
                })
        }
    }

    private func givenYAML(for framework: UIFramework.Framework) -> String {
        switch framework {
        case .appKit, .uiKit, .swiftUI:
            return framework.name
        case let .custom(name, `import`, viewControllerType, viewControllerSuperParameters):
            return givenCustomYAML(name: name,
                                   import: `import`,
                                   viewControllerType: viewControllerType,
                                   viewControllerSuperParameters: viewControllerSuperParameters)
        }
    }

    private func givenCustomYAML(
        name: String = "<name>",
        import: String = "<import>",
        viewControllerType: String = "<viewControllerType>",
        viewControllerSuperParameters: String = "<viewControllerSuperParameters>"
    ) -> String {
        """
        custom:
          name: \(name)
          import: \(`import`)
          viewControllerType: \(viewControllerType)
          viewControllerSuperParameters: \(viewControllerSuperParameters)
        """
    }
}
