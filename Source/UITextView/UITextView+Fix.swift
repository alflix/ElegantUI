//
//  UITextView+.swift
//  GGUI
//
//  Created by John on 2019/7/8.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

/// https://stackoverflow.com/questions/58657087/after-upgrading-to-xcode-11-2-from-xcode-11-1-app-crashes-due-to-uitextlayoutv
@objc
public class UITextViewWorkaround: NSObject {
    public static func executeWorkaround() {
        if #available(iOS 13.2, *) {
        } else {
            let className = "_UITextLayoutView"
            let theClass = objc_getClass(className)
            if theClass == nil {
                let classPair: AnyClass? = objc_allocateClassPair(UIView.self, className, 0)
                objc_registerClassPair(classPair!)
            }
        }
    }
}
