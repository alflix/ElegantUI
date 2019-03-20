//
//  UITabBar+.swift
//  Awesome
//
//  Created by John on 2019/3/19.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit

extension UITabBar {
    fileprivate struct AssociatedKey {
        static var unselectedTintColor: UInt8 = 0
    }

    /// 未选中状态的控件颜色
    open var unselectedTintColor: UIColor? {
        get {
            if #available(iOS 10.0, *) {
                return unselectedItemTintColor
            }
            return associatedObject(base: self, key: &AssociatedKey.unselectedTintColor) { return tintColor }
        }
        set {
            if #available(iOS 10.0, *) {
                unselectedItemTintColor = unselectedTintColor
            }
            associateObject(base: self, key: &AssociatedKey.unselectedTintColor, value: newValue)
        }
    }

    /// 移除顶部的分割线
    open func removeShadowLine() {
        backgroundImage = UIImage()
        shadowImage = UIImage()
    }
}
