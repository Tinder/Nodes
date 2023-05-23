//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Nimble
@testable import Nodes
import SwiftUI
import XCTest

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class BindingTests: XCTestCase {

    func testBindingFactory() {
        expect(Binding.bind(to: true) { _ in }).to(beAKindOf(Binding<Bool>.self))
        expect(Binding.bind(to: 23) { _ in }).to(beAKindOf(Binding<Int>.self))
        expect(Binding.bind(to: "Hello World") { _ in }).to(beAKindOf(Binding<String>.self))
    }

    func testBindingFactoryWithOptionalSetter() {
        expect(Binding.bind(to: true, onChange: nil)).to(beAKindOf(Binding<Bool>.self))
        expect(Binding.bind(to: 23, onChange: nil)).to(beAKindOf(Binding<Int>.self))
        expect(Binding.bind(to: "Hello World", onChange: nil)).to(beAKindOf(Binding<String>.self))
    }
}
