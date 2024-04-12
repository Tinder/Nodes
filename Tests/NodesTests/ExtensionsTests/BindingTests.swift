//
//  Copyright © 2022 Tinder (Match Group, LLC)
//

import Nimble
import Nodes
import SwiftUI
import XCTest

final class BindingTests: XCTestCase {

    @MainActor
    func testBindingFactory() {
        expect(Binding.bind(to: true) { _ in }).to(beAKindOf(Binding<Bool>.self))
        expect(Binding.bind(to: 23) { _ in }).to(beAKindOf(Binding<Int>.self))
        expect(Binding.bind(to: "Hello World") { _ in }).to(beAKindOf(Binding<String>.self))
    }

    @MainActor
    func testBindingFactoryWithOptionalSetter() {
        expect(Binding.bind(to: true, onChange: nil)).to(beAKindOf(Binding<Bool>.self))
        expect(Binding.bind(to: 23, onChange: nil)).to(beAKindOf(Binding<Int>.self))
        expect(Binding.bind(to: "Hello World", onChange: nil)).to(beAKindOf(Binding<String>.self))
    }
}
