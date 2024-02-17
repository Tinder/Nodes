//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

internal protocol XcodeTemplatePermutation {

    var name: String { get }
    var stencils: [StencilTemplate] { get }
    var stencilContext: StencilContext { get }
}
