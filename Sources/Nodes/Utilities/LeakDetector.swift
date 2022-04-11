//
//  LeakDetector.swift
//  Nodes
//
//  Created by Christopher Fuller on 10/3/20.
//

import Foundation

#if canImport(UIKit) && !os(watchOS)
import UIKit
#endif

/**
 * `LeakDetector` is used internally (within Nodes' source code) to detect leaks of a Node's objects when the
 * Node is detached.
 *
 * Leak detection is typically scheduled for an instance's stored properties within `deinit`. Detection is
 * delayed `1` second to allow time for the objects to be released (`5` seconds for `UIViewController`
 * instances to allow additional time for animated dismissal).
 *
 * > Important: Leak detection only occurs in `DEBUG` builds.
 *
 * > Tip: `LeakDetector` may be used within application code to detect leaks of custom objects.
 */
public enum LeakDetector {

    #if DEBUG

    private static let queue: DispatchQueue = .init(label: "Leak Detector",
                                                    qos: .background,
                                                    attributes: .concurrent)

    private static var isDebuggedProcessBeingTraced: Bool {
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var info: kinfo_proc = .init()
        var size: Int = MemoryLayout<kinfo_proc>.stride
        let junk: Int32 = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        guard junk == 0
        else { return false } // swiftlint:disable:this implicit_return
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }

    /// Detects whether the given `object` deallocates from memory as expected.
    ///
    /// - Parameter object: The instance with which to detect the expected deallocation.
    public static func detect(_ object: AnyObject) {
        // swiftlint:disable:next discouraged_optional_collection
        let callStackSymbols: [String]? = self.callStackSymbols()
        let timeInterval: TimeInterval
        #if canImport(UIKit) && !os(watchOS)
        timeInterval = object is UIViewController ? 5 : 1
        #else
        timeInterval = 1
        #endif
        queue.asyncAfter(deadline: .now() + timeInterval) { [weak object] in
            guard let object: AnyObject = object
            else { return }
            DispatchQueue.main.async {
                if let callStack: String = callStackSymbols?.joined(separator: "\n") {
                    print(callStack)
                }
                let message: String = "Expected object to deallocate: \(object)"
                guard isDebuggedProcessBeingTraced
                else { return assertionFailure(message) }
                print(message)
                _ = kill(getpid(), SIGSTOP)
            }
        }
    }

    // swiftlint:disable:next discouraged_optional_collection
    private static func callStackSymbols() -> [String]? {
        let environment: [String: String] = ProcessInfo.processInfo.environment
        guard ["1", "true", "TRUE", "yes", "YES"].contains(environment["LEAK_DETECTOR_CAPTURES_CALL_STACK"])
        else { return nil }
        return Thread.callStackSymbols
    }

    #else

    public static func detect(_ object: AnyObject) {}

    #endif
}
