//
//  UIControl+EnlargeEdge.swift
//  GGUI
//
//  Created by John on 2018/12/11.
//  Copyright © 2018 Ganguo. All rights reserved.
//

import UIKit
import Foundation

public extension UIControl {
    fileprivate struct AssociatedKeys {
        static var topKey: String = "com.ganguo.button.topKey"
        static var bottomKey: String = "com.ganguo.button.bottomKey"
        static var leftKey: String = "com.ganguo.button.leftKey"
        static var rightKey: String = "com.ganguo.button.rightKey"
    }

    var largeTop: NSNumber {
        get {
            if let value = associatedObject(forKey: &AssociatedKeys.topKey) as? NSNumber { return value }
            return 0
        }
        set {
            associate(retainObject: newValue, forKey: &AssociatedKeys.topKey)
        }
    }

    var largeBottom: NSNumber {
        get {
            if let value = associatedObject(forKey: &AssociatedKeys.bottomKey) as? NSNumber { return value }
            return 0
        }
        set {
            associate(retainObject: newValue, forKey: &AssociatedKeys.bottomKey)
        }
    }

    var largeLeft: NSNumber {
        get {
            if let value = associatedObject(forKey: &AssociatedKeys.leftKey) as? NSNumber { return value }
            return 0
        }
        set {
            associate(retainObject: newValue, forKey: &AssociatedKeys.leftKey)
        }
    }

    var largeRight: NSNumber {
        get {
            if let value = associatedObject(forKey: &AssociatedKeys.rightKey) as? NSNumber { return value }
            return 0
        }
        set {
            associate(retainObject: newValue, forKey: &AssociatedKeys.rightKey)
        }
    }

    /// 增加 UIControl 的点击范围
    ///
    /// - Parameters:
    ///   - top: 上
    ///   - bottom: 下
    ///   - left: 左
    ///   - right: 右
    func setEnlargeEdge(top: Float, bottom: Float, left: Float, right: Float) {
        self.largeTop = NSNumber(value: top)
        self.largeBottom = NSNumber(value: bottom)
        self.largeLeft = NSNumber(value: left)
        self.largeRight = NSNumber(value: right)
    }

    private func enlargedRect() -> CGRect {
        let top = self.largeTop
        let bottom = self.largeBottom
        let left = self.largeLeft
        let right = self.largeRight
        if top.floatValue >= 0, bottom.floatValue >= 0, left.floatValue >= 0, right.floatValue >= 0 {
            return CGRect(x: self.bounds.origin.x - CGFloat(left.floatValue),
                          y: self.bounds.origin.y - CGFloat(top.floatValue),
                          width: self.bounds.size.width + CGFloat(left.floatValue) + CGFloat(right.floatValue),
                          height: self.bounds.size.height + CGFloat(top.floatValue) + CGFloat(bottom.floatValue))
        } else {
            return self.bounds
        }
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.enlargedRect()
        if rect.equalTo(self.bounds) {
            return super.point(inside: point, with: event)
        }
        return rect.contains(point) ? true : false
    }
}
