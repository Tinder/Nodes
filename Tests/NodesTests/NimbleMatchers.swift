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
    ) -> Predicate<T> {
        // swiftlint:disable:next unowned_variable_capture
        Predicate { [unowned self] expression in
            guard let object: AnyObject = try expression.evaluate()
            else { return PredicateResult(status: .fail, message: .expectedTo("not be nil, got <nil>")) }
            addTeardownBlock { [weak object] in
                if object != nil {
                    let message: String = "Expected object of type `\(T.self)` to deallocate after test"
                    XCTFail(message, file: file, line: line)
                }
            }
            return PredicateResult(bool: true, message: .fail(""))
        }
    }

    internal func notBeNilAndElementsToDeallocateAfterTest<T: Collection>(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Predicate<T> where T.Element: AnyObject {
        // swiftlint:disable:next unowned_variable_capture
        Predicate { [unowned self] expression in
            guard let collection: T = try expression.evaluate()
            else { return PredicateResult(status: .fail, message: .expectedTo("not be nil, got <nil>")) }
            collection.enumerated().forEach { index, object in
                let object: T.Element = object
                addTeardownBlock { [weak object] in
                    if object != nil {
                        let message: String = "Expected object in collection at index \(index) to deallocate after test"
                        XCTFail(message, file: file, line: line)
                    }
                }
            }
            return PredicateResult(bool: true, message: .fail(""))
        }
    }

    internal func allBeStarted() -> Predicate<[Flow]> {
        allPass(beStarted())
    }

    internal func beStarted() -> Predicate<Flow> {
        Predicate.simple("be started") { expression in
            let flow: Flow? = try expression.evaluate()
            return PredicateStatus(bool: flow?.isStarted ?? false)
        }
    }

    internal func allBeActive() -> Predicate<[Context]> {
        allPass(beActive())
    }

    internal func beActive() -> Predicate<Context> {
        Predicate.simple("be active") { expression in
            let context: Context? = try expression.evaluate()
            return PredicateStatus(bool: context?.isActive ?? false)
        }
    }

    internal func allBeWorking() -> Predicate<[Worker]> {
        allPass(beWorking())
    }

    internal func beWorking() -> Predicate<Worker> {
        Predicate.simple("be working") { expression in
            let worker: Worker? = try expression.evaluate()
            return PredicateStatus(bool: worker?.isWorking ?? false)
        }
    }

    internal func allBeCancelled() -> Predicate<[CancellableMock]> {
        allPass(beCancelled())
    }

    internal func beCancelled() -> Predicate<CancellableMock> {
        Predicate.simple("be cancelled") { expression in
            let cancellable: CancellableMock? = try expression.evaluate()
            return PredicateStatus(bool: cancellable?.isCancelled ?? false)
        }
    }
}
