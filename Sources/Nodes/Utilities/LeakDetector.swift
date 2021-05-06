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
            callStackSymbols?.forEach { print($0) }
            if isDebuggedProcessBeingTraced {
                DispatchQueue.main.sync {
                    _ = kill(getpid(), SIGSTOP)
                }
            } else {
                assertionFailure("Expected object to deallocate: \(object)")
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
