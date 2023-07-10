//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

import XCTest

private class ObjectReference<T: AnyObject> {

    private var object: T!

    init(_ object: T) {
        self.object = object
    }

    func callAsFunction() -> T {
        defer { object = nil }
        return object
    }
}

internal protocol TestCaseHelpers {}

extension TestCaseHelpers where Self: XCTestCase {

    internal func addTeardownBlock<T: AnyObject>(
        with object: T,
        _ block: @escaping (T) -> Void
    ) {
        let reference: ObjectReference = .init(object)
        addTeardownBlock { block(reference()) }
    }

    internal func tearDown<T>(
        keyPath: ReferenceWritableKeyPath<Self, T?>,
        initialValue: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock(for: keyPath, with: initialValue)
    }

    internal func tearDown<T: AnyObject>(
        keyPath: ReferenceWritableKeyPath<Self, T?>,
        initialValue object: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak object] in
            if object != nil {
                let message: String = """
                    Expected object to deallocate after test \
                    (after key path was set to nil during tear down)
                    """
                XCTFail(message, file: file, line: line)
            }
        }
        addTeardownBlock(for: keyPath, with: object)
    }

    internal func tearDown<T: Collection>(
        keyPath: ReferenceWritableKeyPath<Self, T?>,
        initialValue collection: T,
        file: StaticString = #file,
        line: UInt = #line
    ) where T.Element: AnyObject {
        collection.enumerated().forEach { index, object in
            let object: T.Element = object
            addTeardownBlock { [weak object] in
                if object != nil {
                    let message: String = """
                        Expected object in collection at index \(index) to deallocate after test \
                        (after collection key path was set to nil during tear down)
                        """
                    XCTFail(message, file: file, line: line)
                }
            }
        }
        addTeardownBlock(for: keyPath, with: collection)
    }

    private func addTeardownBlock<T>(
        for keyPath: ReferenceWritableKeyPath<Self, T?>,
        with initialValue: T
    ) {
        self[keyPath: keyPath] = initialValue
        // swiftlint:disable:next unowned_variable_capture
        addTeardownBlock { [unowned self] in
            self[keyPath: keyPath] = nil
        }
    }
}
