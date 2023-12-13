//
//  Copyright © 2023 Tinder (Match Group, LLC)
//

@testable import NodesXcodeTemplatesGenerator

internal struct TestXcodeTemplate: XcodeTemplate {

    private struct TestStencilContext: StencilContext {

        let dictionary: [String: Any] = ["key": "value"]
    }

    let name: String = "name"
    let type: String = "type"
    let stencils: [StencilTemplate] = []
    let stencilContext: StencilContext = TestStencilContext()
    let propertyList: PropertyList = .init(description: "description", sortOrder: 23) {}
}
