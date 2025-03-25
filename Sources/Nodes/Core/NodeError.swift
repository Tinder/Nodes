//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Foundation

/**
 * Errors that can occur within the Nodes framework.
 */
public enum NodeError: Error, LocalizedError, Equatable {
    /// Error thrown when a worker of a specific type cannot be found in the context.
    case workerNotFound(String)
    
    public var errorDescription: String? {
        switch self {
        case .workerNotFound(let type):
            return "Worker of type '\(type)' not found in context"
        }
    }
} 