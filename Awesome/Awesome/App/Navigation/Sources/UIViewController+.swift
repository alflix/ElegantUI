//
//  UIViewController+.swift
//  Awesome
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit

public struct NavigationAppearance {
    var backgroundAlpha: CGFloat = 1.0
    var tintColor: UIColor = .white
}

extension UIViewController {
    fileprivate struct AssociatedKey {
        static var appearanceKey: UInt8 = 0
    }

    open var navigationAppearance: NavigationAppearance {
        get {
            return associatedObject(base: self, key: &AssociatedKey.appearanceKey) { return NavigationAppearance() }
        }
        set {
            navigationController?.navigationBar.tintColor = newValue.tintColor
            navigationController?.navigationBar.setBackground(alpha: newValue.backgroundAlpha)
            associateObject(base: self, key: &AssociatedKey.appearanceKey, value: newValue)
        }
    }
}
