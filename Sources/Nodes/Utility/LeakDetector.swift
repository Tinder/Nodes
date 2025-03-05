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
 * ``LeakDetector`` is used internally (within Nodes' source code) to detect leaks of certain instances.
 *
 * > Important: Leak detection only occurs in `DEBUG` builds.
 *
 * > Tip: ``LeakDetector`` may be used within application code to detect leaks of custom objects.
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
        else { return false }
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }

    /// Detects whether the given `object` instance deallocates from memory as expected.
    ///
    /// - Parameters:
    ///   - object: The instance with which to detect the expected deallocation.
    ///   - delay: The time interval in seconds to wait before leak detection occurs.
    public static func detect(
        _ object: AnyObject,
        delay: TimeInterval = 1
    ) {
        struct WeakBox: @unchecked Sendable {
            weak var object: AnyObject?
        }
        let box: WeakBox = .init(object: object)
        // swiftlint:disable:next discouraged_optional_collection
        let callStackSymbols: [String]? = callStackSymbols()
        queue.asyncAfter(deadline: .now() + delay) {
            guard let object: AnyObject = box.object
            else { return }
            let message: String = "Expected object to deallocate: \(object)"
            DispatchQueue.main.async {
                if let callStackSymbols: [String] {
                    print(callStackSymbols.joined(separator: "\n"))
                }
                guard isDebuggedProcessBeingTraced
                else { return assertionFailure(message) }
                print(message)
                _ = kill(getpid(), SIGSTOP)
            }
        }
    }

    /// Detects whether the instance returned by the given `object` closure deallocates from memory as expected.
    ///
    /// - Parameters:
    ///   - root: The root instance to be passed to the `object` closure.
    ///   - delay: The time interval in seconds to wait before leak detection occurs.
    ///   - object: The closure returning the instance with which to detect the expected deallocation.
    internal static func detect<Root>(
        _ root: Root,
        delay: TimeInterval = 1,
        _ object: @MainActor (Root) -> AnyObject
    ) {
        typealias Object = (Root) -> AnyObject
        withoutActuallyEscaping(object) { object in
            let object: Object = unsafeBitCast(object, to: Object.self)
            detect(object(root), delay: delay)
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

    // swiftlint:disable unused_parameter

    public static func detect(
        _ object: AnyObject,
        delay: TimeInterval = 1
    ) {}

    public static func detect<Root>(
        _ root: Root,
        delay: TimeInterval = 1,
        _ object: @MainActor (Root) -> AnyObject
    ) {}

    // swiftlint:enable unused_parameter

    #endif
}
