//
//  UserDefaults+Convience.swift
//  ElegantUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation

public extension UserDefaults {
    /// 是否第一次启动
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "ElegantUI-hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
