//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

import Codextended
import Yams

// Enables Codextended with YAMLDecoder [https://github.com/JohnSundell/Codextended]
#if swift(>=5.9)
extension YAMLDecoder: @retroactive AnyDecoder {}
#else
extension YAMLDecoder: AnyDecoder {}
#endif
