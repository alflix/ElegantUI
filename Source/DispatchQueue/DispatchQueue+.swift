//
//  DispatchQueue+.swift
//  GGUI
//
//  Created by John on 2019/3/15.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    private static var onceTracker = [String]()

    static func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }

    static func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}

public typealias DelayTask = (_ cancel: Bool) -> Void

/// 延时执行任务
///
/// - Parameters:
///   - time: 秒数
///   - task: 任务
/// - Returns: 可取消的 Block
@discardableResult
public func delay(_ time: TimeInterval, task: @escaping () -> Void) -> DelayTask? {
    func dispatch_later(block: @escaping () -> Void) {
        let after = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: after, execute: block)
    }

    var closure: (() -> Void)? = task
    var result: DelayTask?

    let delayedClosure: DelayTask = { cancel in
        if let internalClosure = closure, !cancel {
            DispatchQueue.main.async(execute: internalClosure)
        }
        closure = nil
        result = nil
    }

    result = delayedClosure

    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

public func cancel(_ task: DelayTask?) {
    task?(true)
}
