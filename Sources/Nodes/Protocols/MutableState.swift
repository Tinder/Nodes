//
//  MutableState.swift
//  Nodes
//
//  Created by Seppe Snoeck on 21/10/22.
//

public protocol MutableState {

    mutating func apply(_ mutation: (inout Self) throws -> Void) rethrows

    func with(_ mutation: (inout Self) throws -> Void) rethrows -> Self
}

extension MutableState {

    public mutating func apply(_ mutation: (inout Self) throws -> Void) rethrows {
        self = try with(mutation)
    }

    public func with(_ mutation: (inout Self) throws -> Void) rethrows -> Self {
        var value: Self = self
        try mutation(&value)
        return value
    }
}
