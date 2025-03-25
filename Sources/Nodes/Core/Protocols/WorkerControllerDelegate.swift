//
//  All Contributions by Match Group
//
//  Copyright © 2025 Tinder (Match Group, LLC)
//
//  Licensed under the Match Group Modified 3-Clause BSD License.
//  See https://github.com/Tinder/Nodes/blob/main/LICENSE for license information.
//

/**
 * The delegate protocol for ``WorkerController`` to handle worker-related events.
 */
@preconcurrency
@MainActor
public protocol WorkerControllerDelegate: AnyObject {
    /// Called when a worker of a specific type is not found in the controller.
    ///
    /// - Parameter type: The type of worker that was not found.
    func workerController(_ controller: WorkerController, didFailToFindWorkerOfType type: String)
} 