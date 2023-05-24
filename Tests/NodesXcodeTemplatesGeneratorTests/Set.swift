//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

extension Set where Element == String {

    internal static func mockStrings(_ string: String, count: Int) -> Self {
        guard count > 0
        else { return [] }
        guard count > 1
        else { return ["<\(string)>"] }
        let strings: [String] = (1...count).map { "<\(string)\($0)>" }
        return Set(strings)
    }
}
