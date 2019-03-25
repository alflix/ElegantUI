//
//  TabBarController.swift
//  Awesome
//
//  Created by John on 2019/3/18.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addChilds()
    }

    private func addChilds() {
        self.bulgeOffsetY = 8
        // 通过封装好的方法设置 title，image，selectedImage 等元素（此处只是示例调用）
        add(child: ExampleViewController(title: "Home"),
            imageName: "icon_home",
            navigationClass: NavigationController.self,
            tabBarItemUpdate: { (item) in
            // 支持设置 UITabBarItem 的其他属性
            // 文字位置调整
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
            // 角标背景颜色，文字颜色调整，只支持 iOS 10.0 以上
            if #available(iOS 10.0, *) {
                item.badgeColor = .green
                item.setBadgeTextAttributes([.foregroundColor: UIColor.black], for: .normal)
            }
            // 角标显示的文字
            item.badgeValue = "2"
        }, closure: nil)
        add(child: UIViewController(),
            imageName: "icon_publish",
            selectImageName: "icon_publish_hl",
            isBulge: true,
            navigationClass: NavigationController.self) {
            print("😄")
        }
        add(child: ExampleViewController(title: "Me"), imageName: "icon_me")
    }
}

// MARK: - UI
private extension TabBarController {
    func setupUI() {
        // 背景颜色, 会覆盖掉 barStyle 属性
        tabBar.barTintColor = .white
        // 控件选中状态下的着色
        tabBar.tintColor = .black
        // 是否毛玻璃效果
        tabBar.isTranslucent = true
        // 拓展方法：移除顶部的分割线
        tabBar.removeShadowLine()
        // 拓展方法：设置未选中状态的控件颜色
        tabBar.unselectedTintColor = .gray
    }

    /// 很少用到的设置项
    func setupAdditionUI() {
        // 样式，在没有设置 barTintColor 的时候起作用，比较少用
        tabBar.barStyle = .black
        // 背景图片，注意图片是平铺的，需要处理好图片再进行设置或设置 clipsToBounds = true（会覆盖掉 barStyle,isTranslucent 属性）
        tabBar.backgroundImage = UIImage(named: "trello")
        // item 选中之后会额外显示的图片，很奇怪的接口，一般不用
        tabBar.selectionIndicatorImage = UIImage(named: "icon_back")
        // item 的布局方式，一般默认即可
        tabBar.itemPositioning = .centered
        // item 的宽度（itemPositioning = .centered 时有效）
        tabBar.itemWidth = 44
        // item 的间距（itemPositioning = .centered 时有效）
        tabBar.itemSpacing = 88
    }
}
