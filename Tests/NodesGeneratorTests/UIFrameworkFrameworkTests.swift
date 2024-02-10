//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Codextended
import InlineSnapshotTesting
import Nimble
@testable import NodesGenerator
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

    func testDecoding() throws {
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

    func testDecodingThrowsTypeMismatchForUnsupportedFramework() throws {
        let data: Data = .init("AnyUnsupportedFrameworkName".utf8)
        expect(try data.decoded(as: UIFramework.Framework.self, using: YAMLDecoder()))
            .to(throwError(errorType: DecodingError.self) { error in
                assertInlineSnapshot(of: error, as: .dump) {
                    """
                    ▿ DecodingError
                      ▿ typeMismatch: (2 elements)
                        - .0: Framework
                        ▿ .1: Context
                          - codingPath: 0 elements
                          - debugDescription: "Unsupported framework: AnyUnsupportedFrameworkName"
                          - underlyingError: Optional<Error>.none
                    """ + "\n"
                }
            })
    }

    func testDecodingThrowsTypeMismatchForCustomFrameworkMustBeObject() throws {
        let data: Data = .init("Custom".utf8)
        expect(try data.decoded(as: UIFramework.Framework.self, using: YAMLDecoder()))
            .to(throwError(errorType: DecodingError.self) { error in
                assertInlineSnapshot(of: error, as: .dump) {
                    """
                    ▿ DecodingError
                      ▿ typeMismatch: (2 elements)
                        - .0: Framework
                        ▿ .1: Context
                          - codingPath: 0 elements
                          - debugDescription: "Custom framework must be an object."
                          - underlyingError: Optional<Error>.none
                    """ + "\n"
                }
            })
    }

    func testDecodingThrowsTypeMismatchForExpectedOnlyOneKey() throws {
        let data: Data = .init("custom:\ncustom:\n".utf8)
        expect(try data.decoded(as: UIFramework.Framework.self, using: YAMLDecoder()))
            .to(throwError(errorType: DecodingError.self) { error in
                assertInlineSnapshot(of: error, as: .dump) {
                    """
                    ▿ DecodingError
                      ▿ typeMismatch: (2 elements)
                        - .0: Framework
                        ▿ .1: Context
                          - codingPath: 0 elements
                          - debugDescription: "Expected only one key."
                          - underlyingError: Optional<Error>.none
                    """ + "\n"
                }
            })
    }

    func testDecodingThrowsTypeMismatchForExpectedToDecodeMapping() throws {
        let data: Data = .init("[]".utf8)
        expect(try data.decoded(as: UIFramework.Framework.self, using: YAMLDecoder()))
            .to(throwError(errorType: DecodingError.self) { error in
                assertInlineSnapshot(of: error, as: .dump) {
                    """
                    ▿ DecodingError
                      ▿ typeMismatch: (2 elements)
                        - .0: Mapping
                        ▿ .1: Context
                          - codingPath: 0 elements
                          - debugDescription: "Expected to decode Mapping but found Node instead."
                          - underlyingError: Optional<Error>.none
                    """ + "\n"
                }
            })
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
                    assertInlineSnapshot(of: error, as: .dump) {
                        """
                        ▿ DecodingError
                          ▿ dataCorrupted: Context
                            - codingPath: 0 elements
                            - debugDescription: "The given data was not valid YAML."
                            ▿ underlyingError: Optional<Error>
                              ▿ some: ConfigError
                                ▿ emptyStringNotAllowed: (1 element)
                                  - key: "\(key)"
                        """ + "\n"
                    }
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
