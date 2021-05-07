//
//  InitialStateProviding.swift
//  Nodes
//
//  Created by Christopher Fuller on 5/1/21.
//

/// @mockable
public protocol InitialStateProviding {

    static var initialState: Self { get }
}
