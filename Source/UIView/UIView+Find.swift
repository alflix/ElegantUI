//
//  UIView+Find.swift
//  GGUI
//
//  Created by John on 2019/7/25.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UIView {
    /// 是否是某 View 的子 view，不止判断一层，会递归所有层级
    ///
    /// - Parameter view: 某 View
    /// - Returns: 是或不是
    func isRecursiveSubView(of view: UIView) -> Bool {
        if superview == nil {
            return self == view
        } else if superview == view {
            return true
        }
        return superview!.isRecursiveSubView(of: view)
    }

    /// 递归查找子类 UIView
    ///
    /// - Parameter name: UIView 的类名称
    /// - Returns: 找到的 UIView
    func recursiveFindSubview(of name: String) -> UIView? {
        for view in subviews {
            if view.isKind(of: NSClassFromString(name)!) {
                return view
            }
        }
        for view in subviews {
            if let tempView = view.recursiveFindSubview(of: name) {
                return tempView
            }
        }
        return nil
    }

    /// 递归查找父类 UIView
    ///
    /// - Parameter name: UIView 的类名称
    /// - Returns: 找到的 UIView
    func recursiveFindSuperView(of name: String) -> UIView? {
        guard let superview = superview else { return nil }
        if superview.isKind(of: NSClassFromString(name)!) {
            return superview
        }
        return superview.recursiveFindSuperView(of: name)
    }

    /// 递归寻找所有 subviews
    func getAllSubview<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T {
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
