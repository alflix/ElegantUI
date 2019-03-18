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
        tabBar.barStyle = .black
        tabBar.barTintColor = .white
        tabBar.tintColor = .black
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
        addChild(FirstViewController.instantiate(), imageName: "icon_home")
        addChild(SecondViewController.instantiate(), imageName: "icon_me")
    }

    func addChild(_ childController: UIViewController, imageName: String) {
        childController.tabBarItem.image = UIImage(named: imageName)
        let navigationController = UINavigationController(rootViewController: childController)
        addChild(navigationController)
    }
}
