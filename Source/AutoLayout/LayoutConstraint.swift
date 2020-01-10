//
//  NavHeightConstraint.swift
//  ElegantUI
//
//  Created by John on 2018/12/5.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import UIKit

/// 导航栏高度的 NSLayoutConstraint
public class NavHeightConstraint: NSLayoutConstraint {
    override public var constant: CGFloat {
        set {
            super.constant = newValue
        }
        get {
            return Size.navigationBarHeight
        }
    }
}

/// 状态栏高度的 NSLayoutConstraint
public class StatusBarHeightConstraint: NSLayoutConstraint {
    override public var constant: CGFloat {
        set {
            super.constant = newValue
        }
        get {
            return Size.statusBarHeight
        }
    }
}

/// 底部安全区域高度的 NSLayoutConstraint
public class BottomSafeAreaHeightConstraint: NSLayoutConstraint {
    override public var constant: CGFloat {
        set {
            super.constant = newValue
        }
        get {
            return Size.bottomSafeAreaHeight
        }
    }
}
