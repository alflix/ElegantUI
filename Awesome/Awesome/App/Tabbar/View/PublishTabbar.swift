//
//  PublishTabbar.swift
//  Awesome
//
//  Created by John on 2019/3/18.
//  Copyright © 2019 NleFlix. All rights reserved.
//

import UIKit

class PublishTabbar: UITabBar {
    lazy var publishButton: UIButton = {
        let publishButton = UIButton()
        publishButton.setImage(UIImage(named: "icon_publish"), for: .normal)
        publishButton.addTarget(self, action: #selector(publishButtonDidClick), for: .touchUpInside)
        publishButton.sizeToFit()
        return publishButton
    }()

    private var itemFrames = [CGRect]()
    private var tabBarItems = [UIView]()
    var publishHandler: VoidBlock?

    init() {
        super.init(frame: .null)
        addSubview(publishButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //处理超出区域点击无效的问题
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isHidden {
            //转换坐标
            let tempPoint = publishButton.convert(point, from: self)
            //判断点击的点是否在按钮区域内
            if publishButton.bounds.contains(tempPoint) {
                // 返回按钮
                return publishButton
            }
        }
        return super.hitTest(point, with: event)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(publishButton)
        if itemFrames.isEmpty, let UITabBarButtonClass = NSClassFromString("UITabBarButton") as? NSObject.Type {
            tabBarItems = subviews.filter({$0.isKind(of: UITabBarButtonClass)})
            tabBarItems.forEach({itemFrames.append($0.frame)})
        }

        if !itemFrames.isEmpty, !tabBarItems.isEmpty, itemFrames.count == items?.count {
            tabBarItems.enumerated().forEach({$0.element.frame = itemFrames[$0.offset]})
        }

        publishButton.center = CGPoint(x: width/2, y: 20)

        let buttonW = (width - 48) / 2
        var buttonIndex = 0

        for subview in subviews {
            let className = NSStringFromClass(type(of: subview))
            if className == "UITabBarButton" {
                let buttonX: CGFloat = CGFloat(buttonIndex) * (buttonW + 48)
                subview.x = buttonX
                subview.y += 6
                subview.width = buttonW
                buttonIndex += 1
            }
        }
    }

    @objc private func publishButtonDidClick() {
        publishHandler?()
    }
}
