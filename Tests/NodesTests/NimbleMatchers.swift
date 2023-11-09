// swiftlint:disable:this file_name
//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import Nimble
import Nodes
import XCTest

extension XCTestCase {

    internal func notBeNilAndToDeallocateAfterTest<T: AnyObject>(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Matcher<T> {
        // swiftlint:disable:next unowned_variable_capture
        Matcher { [unowned self] expression in
            guard let object: AnyObject = try expression.evaluate()
            else { return MatcherResult(status: .fail, message: .expectedTo("not be nil, got <nil>")) }
            addTeardownBlock { [weak object] in
                if object != nil {
                    let message: String = "Expected object of type `\(T.self)` to deallocate after test"
                    XCTFail(message, file: file, line: line)
                }
            }
            return MatcherResult(bool: true, message: .fail(""))
        }
    }

    internal func notBeNilAndElementsToDeallocateAfterTest<T: Collection>(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Matcher<T> where T.Element: AnyObject {
        // swiftlint:disable:next unowned_variable_capture
        Matcher { [unowned self] expression in
            guard let collection: T = try expression.evaluate()
            else { return MatcherResult(status: .fail, message: .expectedTo("not be nil, got <nil>")) }
            collection.enumerated().forEach { index, object in
                let object: T.Element = object
                addTeardownBlock { [weak object] in
                    if object != nil {
                        let message: String = "Expected object in collection at index \(index) to deallocate after test"
                        XCTFail(message, file: file, line: line)
                    }
                }
            }
            return MatcherResult(bool: true, message: .fail(""))
        }
    }

    internal func allBeStarted() -> Matcher<[Flow]> {
        allPass(beStarted())
    }

    internal func beStarted() -> Matcher<Flow> {
        Matcher.simple("be started") { expression in
            let flow: Flow? = try expression.evaluate()
            return MatcherStatus(bool: flow?.isStarted ?? false)
        }
    }

    internal func allBeActive() -> Matcher<[Context]> {
        allPass(beActive())
    }

    internal func beActive() -> Matcher<Context> {
        Matcher.simple("be active") { expression in
            let context: Context? = try expression.evaluate()
            return MatcherStatus(bool: context?.isActive ?? false)
        }
    }

    internal func allBeWorking() -> Matcher<[Worker]> {
        allPass(beWorking())
    }

    internal func beWorking() -> Matcher<Worker> {
        Matcher.simple("be working") { expression in
            let worker: Worker? = try expression.evaluate()
            return MatcherStatus(bool: worker?.isWorking ?? false)
        }
    }

    internal func allBeCancelled() -> Matcher<[CancellableMock]> {
        allPass(beCancelled())
    }

    internal func beCancelled() -> Matcher<CancellableMock> {
        Matcher.simple("be cancelled") { expression in
            let cancellable: CancellableMock? = try expression.evaluate()
            return MatcherStatus(bool: cancellable?.isCancelled ?? false)
        }
    }
}
