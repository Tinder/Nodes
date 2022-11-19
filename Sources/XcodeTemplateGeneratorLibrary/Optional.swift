//
//  OptionalExtensions.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Garric Nahapetian on 11/18/22.
//

extension Optional {

    // Source: https://www.swiftbysundell.com/tips/unwrapping-an-optional-or-throwing-an-error/
    internal func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw errorExpression()
        }
    }
}
