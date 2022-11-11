//
//  File.swift
//  
//
//  Created by Garric Nahapetian on 11/10/22.
//

import Foundation

public extension UIFramework {

    struct CustomOptions: Equatable, Decodable, Encodable {

        var uiFrameworkImport: String
        var viewControllerMethods: String
        var viewControllerMethodsForRootNode: String
        var viewControllerProperties: String
        var viewControllerSuperParameters: String
        var viewControllerType: String
    }
}
