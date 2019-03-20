//
//  UITabBarController+.swift
//  Awesome
//
//  Created by John on 2019/3/19.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit

extension UITabBarController {
    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - controller: 子控制器
    ///   - imageName: 图标, 选中/未选中图标根据 tintColor/unselectedTintColor 而定
    ///   - title: 文字
    open func add(child controller: UIViewController, imageName: String, title: String? = nil) {
        add(child: controller, imageName: imageName, selectImageName: nil,
            title: title, withNavigationClass: UINavigationController.self)
    }

    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - controller: 子控制器
    ///   - imageName: 图标
    ///   - selectImageName: 选中的图标，不为空时，imageName 对应为未选中的图标，为空时，选中/未选中图标根据 imageName 以及 tintColor/unselectedTintColor 而定
    ///   - title: 文字
    ///   - name: UINavigationController class 的名称
    ///   - handler: 暴露出 UITabBarItem，可以设置额外的属性
    open func add<T: UINavigationController>(child controller: UIViewController,
                                        imageName: String,
                                        selectImageName: String?,
                                        title: String? = nil,
                                        withNavigationClass name: T.Type,
                                        tabBarItemUpdate: ((UITabBarItem) -> Void)? = nil) {
        guard let image = UIImage(named: imageName) else {
            fatalError("cant find image by imageName!")
        }
        let tabBarItem = UITabBarItem(title: title)
        if let selectImageName = selectImageName {
            guard let selectedImage = UIImage(named: selectImageName) else {
                fatalError("cant find image by selectImageName!")
            }
            tabBarItem.image = image.original
            tabBarItem.selectedImage = selectedImage.original
        }
        if #available(iOS 10.0, *) {
             tabBarItem.image = image
        } else {
            let unselectedTintColor: UIColor! = tabBar.unselectedTintColor ?? tabBar.tintColor
            // 未选中状态下的图片
            let unselectImage = image.tint(unselectedTintColor, blendMode: .destinationOver)
            tabBarItem.image = unselectImage
            // 选中状态下的图片
            let selectImage = image.template
            tabBarItem.selectedImage = selectImage

            // 未选中状态下的文字属性, 这个属性会使得 self.tabBar.tintColor 对文字的设置不再生效，所以需要重新设置选中状态下的文字属性
            let textAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: unselectedTintColor]
            tabBarItem.setTitleTextAttributes(textAttrs, for: .normal)
            // 选中状态下的文字属性
            let selectedTextAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: tabBar.tintColor]
            tabBarItem.setTitleTextAttributes(selectedTextAttrs, for: .selected)
        }
        controller.tabBarItem = tabBarItem
        tabBarItemUpdate?(tabBarItem)
        let navigationController = T(rootViewController: controller)
        addChild(navigationController)
    }
}
