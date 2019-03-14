//
//  UINavigationBar+Addition.swift
//  Awesome
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit

extension UINavigationBar {
    /// 通过 runtime 交互 layoutSubviews 方法
    static func swizzedMethod() {
        swizzling(
            UINavigationBar.self,
            #selector(UINavigationBar.layoutSubviews),
            #selector(UINavigationBar.swizzle_layoutSubviews))
    }

    /// 实际的 layoutSubviews 方法
    @objc func swizzle_layoutSubviews() {
        swizzle_layoutSubviews()

        layoutMargins = .zero
        for view in subviews {
            if NSStringFromClass(view.classForCoder).contains("ContentView") {
                view.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            }
        }
    }
}

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

/// 封装 swizzed 方法
private let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}
