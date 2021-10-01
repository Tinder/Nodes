//
//  Bundle.swift
//  XcodeTemplateGeneratorLibrary
//
//  Created by Christopher Fuller on 9/24/21.
//

import Foundation

extension Bundle {

    internal static var moduleRelativeToExecutable: Bundle? {
        guard let url: URL = Bundle.main.executableURL
        else { return nil }
        let name: String = "Nodes_XcodeTemplateGeneratorLibrary.bundle"
        return Bundle(url: url.deletingLastPathComponent().appendingPathComponent(name))
    }
}
