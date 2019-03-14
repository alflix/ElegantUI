//
//  UIViewController+.swift
//  Awesome
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit

public struct NavigationAppearance {
    var backgroundAlpha: CGFloat = 1.0
    var tintColor: UIColor = .white
}

extension UIViewController {
    fileprivate struct AssociatedKeys {
        static var appearanceKey: UInt8 = 0
    }

    open var navigationAppearance: NavigationAppearance {
        get {
            return associatedObject(base: self, key: &AssociatedKeys.appearanceKey) { return NavigationAppearance() }
        }
        set {
            navigationController?.navigationBar.tintColor = newValue.tintColor
            navigationController?.navigationBar.setBackground(alpha: newValue.backgroundAlpha)
            associateObject(base: self, key: &AssociatedKeys.appearanceKey, value: newValue)
        }
    }
}
