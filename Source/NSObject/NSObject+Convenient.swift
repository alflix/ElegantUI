//
//  NSObject+Convenient.swift
//  GGUI
//
//  Created by John on 2019/5/22.
//  Copyright © 2018 Ganguo. All rights reserved.
//
import Foundation

public extension NSObject {
    // create a static method to get a swift class for a string name
    static func swiftClassFromString(_ className: String) -> AnyClass! {
        // get the project name
        if let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
            let classStringName = "_TtC\(appName.utf16.count)\(appName)\(className.count)\(className)"
            // return the class!
            return NSClassFromString(classStringName)
        }
        return nil
    }
}
