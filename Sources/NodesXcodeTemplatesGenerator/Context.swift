//
//  Copyright © 2021 Tinder (Match Group, LLC)
//

internal protocol Context {

    var dictionary: [String: Any] { get }
}

extension Set where Element == String {

    internal func sortedImports() -> [Element] {
        func prepare(_ string: String) -> [String] {
            string
                .components(separatedBy: "//")[0]
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: " ")
        }
        func compare(_ lhs: String, _ rhs: String) -> Bool {
            lhs.compare(rhs, options: [.caseInsensitive, .numeric]) == .orderedAscending
        }
        return self
            .filter { !$0.isEmpty }
            .sorted { lhs, rhs  in
                let lhs: [String] = prepare(lhs)
                let rhs: [String] = prepare(rhs)
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
