//
//  UINavigationBar+Addition.swift
//  Awesome
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    static func swizzedMethod()  {
        swizzling(
            UINavigationBar.self,
            #selector(UINavigationBar.layoutSubviews),
            #selector(UINavigationBar.swizzle_layoutSubviews))
    }
    
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

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}
