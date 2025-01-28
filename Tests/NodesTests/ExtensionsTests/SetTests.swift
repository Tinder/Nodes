//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Combine
import Nimble
import Nodes
import XCTest

final class SetTests: XCTestCase {

    func testCancelAll() {
        var cancellables: Set<AnyCancellable> = []
        var count: Int = 0
        for _ in 1...3 {
            cancellables.insert(AnyCancellable { count += 1 })
        }
        expect(cancellables.count) == 3
        expect(count) == 0
        cancellables.cancelAll()
        expect(cancellables.isEmpty) == true
        expect(count) == 3
    }

    func testCancelAllKeepingCancellables() {
        var cancellables: Set<AnyCancellable> = []
        var count: Int = 0
        for _ in 1...3 {
            cancellables.insert(AnyCancellable { count += 1 })
        }
        expect(cancellables.count) == 3
        expect(count) == 0
        cancellables.cancelAll(keepingCancellables: true)
        expect(cancellables.count) == 3
        expect(count) == 3
    }
}
