//
//  UIView+Convenient.swift
//  GGUI
//
//  Created by John on 2019/7/25.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UIView {
    /// removeFromSuperview 之前增加 superview == nil 的判断
    func safeRemoveFromSuperview() {
        if superview == nil { return }
        removeFromSuperview()
    }

    convenience init(backgroundColor: UIColor?) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}
