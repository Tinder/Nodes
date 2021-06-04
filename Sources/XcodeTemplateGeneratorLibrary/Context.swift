//
//  Context.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 6/3/21.
//

internal protocol Context {

    var dictionary: [String: Any] { get }
}

extension Set where Element == String {

    internal func sortedImports() -> [Element] {
        func compare(_ lhs: String, _ rhs: String) -> Bool {
            lhs.compare(rhs, options: [.caseInsensitive, .numeric]) == .orderedAscending
        }
        return self
            .filter { !$0.isEmpty }
            .sorted {
                let lhs: [String] = $0.components(separatedBy: " ")
                let rhs: [String] = $1.components(separatedBy: " ")
                switch (lhs.count, rhs.count) {
                case (2, 2):
                    guard lhs[0] == rhs[0]
                    else { return compare(lhs[0], rhs[0]) }
                    return compare(lhs[1], rhs[1])
                case (2, 1):
                    return compare(lhs[1], rhs[0])
                case (1, 2):
                    return compare(lhs[0], rhs[1])
                default:
                    return compare(lhs[0], rhs[0])
                }
            }
    }
}
