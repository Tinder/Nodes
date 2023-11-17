//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

extension DecodingError {

    internal var context: DecodingError.Context? {
        switch self {
        case let .typeMismatch(_, context):
            return context
        case let .valueNotFound(_, context):
            return context
        case let .keyNotFound(_, context):
            return context
        case let .dataCorrupted(context):
            return context
        @unknown default:
            return nil
        }
    }
}
