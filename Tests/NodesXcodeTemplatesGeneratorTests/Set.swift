//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

extension Set where Element == String {

    internal static func mock(with identifier: String, count: Int) -> Self {
        guard count > 0
        else { return [] }
        guard count > 1
        else { return ["<\(identifier)>"] }
        let strings: [String] = (1...count).map { "<\(identifier)\($0)>" }
        return Set(strings)
    }
}
