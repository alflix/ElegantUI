//
//  TabBarController.swift
//  Awesome
//
//  Created by John on 2019/3/18.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupUI()
        addChilds()
    }
}

// MARK: - UI
private extension TabBarController {
    func setupUI() {
        // 背景颜色
        tabBar.barTintColor = .white
        // 控件颜色
        tabBar.tintColor = .black
    }

    /// 移除顶部的分割线
    func removeShadowLine() {
        if #available(iOS 10.0, *) {
            tabBar.barStyle = .black
        } else {
            tabBar.backgroundImage = UIImage()
            tabBar.shadowImage = UIImage()
        }
    }

    /// 未选中状态的控件颜色
    func setupUnselectColor() {
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = .gray
        }
    }

    func setupCustomTabBar() {
        setValue(PublishTabbar(), forKey: "tabBar")
    }
}

// MARK: - Function
private extension TabBarController {
    func addChilds() {
        addChild(ExampleViewController(title: "Home"), imageName: "icon_home")
        addChild(ExampleViewController(title: "Me"), imageName: "icon_me")
    }

    func addChild(_ childController: UIViewController, imageName: String, selectImageName: String, title: String? = nil) {

    }

    func addChild(_ childController: UIViewController, imageName: String, title: String? = nil) {
        if #available(iOS 10.0, *) {
            childController.tabBarItem.image = UIImage(named: imageName)
            childController.tabBarItem.title = title
            let navigationController = UINavigationController(rootViewController: childController)
            addChild(navigationController)
        } else {
            let templeImage = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            childController.tabBarItem.image = templeImage

            // 未选中状态下的文字属性, 这个属性会使得 self.tabBar.tintColor 对文字的设置不再生效，所以需要重新设置选中状态下的文字属性
            let textAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: tabBar.tintColor]
            tabBarItem.setTitleTextAttributes(textAttrs, for: .normal)
            // 选中状态下的文字属性
            let selectedTextAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: tabBar.tintColor]
            tabBarItem.setTitleTextAttributes(selectedTextAttrs, for: .selected)
            childController.tabBarItem.title = title
            
            let navigationController = UINavigationController(rootViewController: childController)
            addChild(navigationController)
        }
    }
}
