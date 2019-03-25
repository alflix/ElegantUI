//
//  BulgeTabBar.swift
//  Awesome
//
//  Created by John on 2019/3/25.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit

class BulgeTabBar: UITabBar {
    /// 往上移动的偏移量
    var offsetY: CGFloat = 0
    private var bulgeIndexs: [Int] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var tabBarButtonIndex = -1
        for subview in subviews where NSStringFromClass(type(of: subview)) == "UITabBarButton" {
            tabBarButtonIndex += 1
            if bulgeIndexs.contains(tabBarButtonIndex) {
                subview.y -= offsetY
            }
        }
    }

    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        var tabBarButtonIndex = -1
        for subview in subviews where NSStringFromClass(type(of: subview)) == "UITabBarButton" {
            tabBarButtonIndex += 1
            if bulgeIndexs.contains(tabBarButtonIndex) {
                print(subview.frame)
            }
        }
        layoutSubviews()
    }

    // 处理超出区域点击无效的问题
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isHidden {
            for subview in subviews where NSStringFromClass(type(of: subview)) == "UITabBarButton" {
                let tempPoint = subview.convert(point, from: self)
                if subview.bounds.contains(tempPoint) {
                    return subview
                }
            }
        }
        return super.hitTest(point, with: event)
    }

    func addBulgeIndexs(index: Int) {
        bulgeIndexs.append(index)
    }
}
