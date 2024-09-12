//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Codextended
import Nimble
@testable import NodesGenerator
import SnapshotTesting
import XCTest
import Yams

final class UIFrameworkTests: XCTestCase {

    func testInitWithFrameworkAppKit() {
        let framework: UIFramework = .init(framework: .appKit)
        expect(framework.kind) == .appKit
        expect(framework.name) == "AppKit"
        expect(framework.import) == "AppKit"
        expect(framework.viewControllerType) == "NSViewController"
        expect(framework.viewControllerSuperParameters) == "nibName: nil, bundle: nil"
        expect(framework.viewControllerMethods) == """
            @available(*, unavailable)
            internal required init?(coder: NSCoder) {
                preconditionFailure("init(coder:) has not been implemented")
            }

            override internal func loadView() {
                view = NSView()
            }

            override internal func viewDidLoad() {
                super.viewDidLoad()
                update(with: initialState)
            }

            override internal func viewWillAppear() {
                super.viewWillAppear()
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewWillDisappear() {
                super.viewWillDisappear()
                cancellables.cancelAll()
            }
            """
    }

    func testInitWithFrameworkAppKitSwiftUI() {
        let framework: UIFramework = .init(framework: .appKitSwiftUI)
        expect(framework.kind) == .appKitSwiftUI
        expect(framework.name) == "AppKit (SwiftUI)"
        expect(framework.import) == "SwiftUI"
        expect(framework.viewControllerType) == "NSHostingController"
        expect(framework.viewControllerSuperParameters).to(beEmpty())
        expect(framework.viewControllerMethods).to(beEmpty())
    }

    func testInitWithFrameworkUIKit() {
        let framework: UIFramework = .init(framework: .uiKit)
        expect(framework.kind) == .uiKit
        expect(framework.name) == "UIKit"
        expect(framework.import) == "UIKit"
        expect(framework.viewControllerType) == "UIViewController"
        expect(framework.viewControllerSuperParameters) == "nibName: nil, bundle: nil"
        expect(framework.viewControllerMethods) == """
            @available(*, unavailable)
            internal required init?(coder: NSCoder) {
                preconditionFailure("init(coder:) has not been implemented")
            }

            override internal func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = .systemBackground
                update(with: initialState)
            }

            override internal func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                observe(statePublisher).store(in: &cancellables)
            }

            override internal func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                cancellables.cancelAll()
            }
            """
    }

    func testInitWithFrameworkUIKitSwiftUI() {
        let framework: UIFramework = .init(framework: .uiKitSwiftUI)
        expect(framework.kind) == .uiKitSwiftUI
        expect(framework.name) == "UIKit (SwiftUI)"
        expect(framework.import) == "SwiftUI"
        expect(framework.viewControllerType) == "UIHostingController"
        expect(framework.viewControllerSuperParameters).to(beEmpty())
        expect(framework.viewControllerMethods).to(beEmpty())
    }

    func testInitWithFrameworkCustom() {
        let custom: UIFramework.Framework = .custom(name: "<uiFrameworkName>",
                                                    import: "<uiFrameworkImport>",
                                                    viewControllerType: "<viewControllerType>",
                                                    viewControllerSuperParameters: "<viewControllerSuperParameters>",
                                                    viewControllerMethods: "<viewControllerMethods>")
        let framework: UIFramework = .init(framework: custom)
        expect(framework.kind) == .custom
        expect(framework.name) == "<uiFrameworkName>"
        expect(framework.import) == "<uiFrameworkImport>"
        expect(framework.viewControllerType) == "<viewControllerType>"
        expect(framework.viewControllerSuperParameters) == "<viewControllerSuperParameters>"
        expect(framework.viewControllerMethods) == "<viewControllerMethods>"
    }

    func testDecoding() throws {
        try UIFramework.Kind
            .allCases
            .map(givenYAML)
            .map(\.utf8)
            .map(Data.init(_:))
            .map { try $0.decoded(as: UIFramework.self, using: YAMLDecoder()) }
            .forEach { assertSnapshot(of: $0, as: .dump, named: $0.kind.name.sanitized) }
    }

    private func givenYAML(for kind: UIFramework.Kind) -> String {
        switch kind {
        case .appKit, .appKitSwiftUI, .uiKit, .uiKitSwiftUI:
            return "framework: \(kind.name)"
        case .custom:
            return """
                framework:
                  custom:
                    name: <uiFrameworkName>
                    import: <uiFrameworkImport>
                    viewControllerType: <viewControllerType>
                    viewControllerSuperParameters: <viewControllerSuperParameters>
                    viewControllerMethods: <viewControllerMethods>
                """
        }
    }
}
