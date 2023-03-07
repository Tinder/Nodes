//
//  PathComponent.swift
//  NodesTesting
//
//  Created by Eman Haroutunian on 1/12/23.
//

import Foundation

internal class PathComponent: CustomStringConvertible {

    internal let description: String

    internal init<T>(for type: T.Type) {
        description = "\(T.self)"
            .components(separatedBy: ".")
            .reversed()[0]
    }
}
