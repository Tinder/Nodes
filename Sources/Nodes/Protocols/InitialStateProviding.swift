//
//  InitialStateProviding.swift
//  Nodes
//
//  Created by Christopher Fuller on 5/1/21.
//

/**
 * View state types adopt `InitialStateProviding` to specify an initial state.
 */
public protocol InitialStateProviding {

    /// The value of `Self` to use as the initial state.
    static var initialState: Self { get }
}
