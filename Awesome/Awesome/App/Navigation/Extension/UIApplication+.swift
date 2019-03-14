//
//  UIApplication+.swift
//  Awesome
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit

extension UIApplication {
    /// Swift 3.1 之后，必须通过这种方法使得 swizzed 生效
    private static let classSwizzedMethodRunOnce: Void = {
        if #available(iOS 11.0, *) {
            UINavigationBar.swizzedMethod()
        }
    }()

    open override var next: UIResponder? {
        UIApplication.classSwizzedMethodRunOnce
        return super.next
    }
}
