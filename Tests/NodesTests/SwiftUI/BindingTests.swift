//
//  BindingTests.swift
//  NodesTests
//
//  Created by Seppe Snoeck on 21/10/22.
//

import Nimble
@testable import Nodes
import SwiftUI
import XCTest

@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
final class BindingTests: XCTestCase {

    func testBinding() {
        expect(Binding.binding(to: 1, onChange: { _ in })).to(beAKindOf(Binding<Int>.self))
        expect(Binding.binding(to: 1, onChange: nil)).to(beAKindOf(Binding<Int>.self))
        expect(Binding.binding(to: "Tinder", onChange: nil)).notTo(beAKindOf(Binding<Int>.self))
        expect(Binding.binding(to: true, onChange: nil)).to(beAKindOf(Binding<Bool>.self))
    }
}
