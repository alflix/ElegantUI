//
//  DispatchQueue+Once.swift
//  ElegantUI
//
//  Created by John on 2019/3/15.
//  Copyright © 2019 ElegantUI. All rights reserved.
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
