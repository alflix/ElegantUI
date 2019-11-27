//
//  NSObject+Convenient.swift
//  GGUI
//
//  Created by John on 2019/5/22.
//  Copyright © 2018 GGUI. All rights reserved.
//

import Foundation

// https://medium.com/@maximbilan/ios-objective-c-project-nsclassfromstring-method-for-swift-classes-dbadb721723
public extension NSObject {
    static func swiftClassFromString(_ className: String) -> AnyClass! {
        if let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            let fAppName = appName.replacingOccurrences(of: " ", with: "_")
            return NSClassFromString("\(fAppName).\(className)")
        }
        return nil
    }
}
