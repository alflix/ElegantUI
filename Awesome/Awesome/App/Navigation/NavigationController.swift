//
//  NavigationController.swift
//  navigationController
//
//  Created by John on 2019/3/7.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit
import SwifterSwift
import ActionKit

class NavigationController: UINavigationController {
    /// 是否允许手势返回
    var enablePopGesture = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // 👇两个 delegate 解决设置 leftBarButtonItem 后返回手势失效的问题
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }

    /// override pushViewController，以统一创建返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        setupDefaultBackItem(push: viewController)
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension NavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return enablePopGesture
    }
}

// MARK: - UINavigationControllerDelegate
extension NavigationController: UINavigationControllerDelegate {
    /// 思路：以 navigationController.children 的数量判断是否可以手势返回
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let interactivePopGestureRecognizer = interactivePopGestureRecognizer else { return }
        interactivePopGestureRecognizer.isEnabled = navigationController.children.count > 1
        if navigationController.children.count == 1 {
            interactivePopGestureRecognizer.isEnabled = false
        } else {
            interactivePopGestureRecognizer.isEnabled = enablePopGesture
        }
    }
}

// MARK: - UI
private extension UINavigationController {
    func setupNavigationBar() {
        // default: 灰白色背景，白色文字 black: 纯黑色背景，白色文字，会被👇的设置项覆盖
        navigationBar.barStyle = .default
        // 标题的样式
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        // 标题的垂直位置偏移量
        navigationBar.setTitleVerticalPositionAdjustment(0, for: .default)
        // UIBarButtonItem 上的控件颜色，默认为按钮的蓝色
        navigationBar.tintColor = .black
        // 是否半透明效果
        navigationBar.isTranslucent = true
        // 背景颜色(会使 isTranslucent = true 失效)
        navigationBar.barTintColor = .white
        // 设置背景图片(会使 barTintColor，isTranslucent = true 失效)
        navigationBar.setBackgroundImage(UIImage(color: .white, size: CGSize.zero), for: .default)
        // 设置底部分割线颜色
        navigationBar.shadowImage = UIImage(color: .red, size: CGSize(width: navigationBar.width, height: 0.5))
        // 移除分割线
        navigationBar.removeShadowLine()
    }

    /// 设置默认的返回按钮
    func setupDefaultBackItem(push viewController: UIViewController) {
        if viewControllers.count > 0 && (viewController.navigationItem.leftBarButtonItem == nil) {
            viewController.hidesBottomBarWhenPushed = true
            let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back")!) { (_)  in
                self.popViewController(animated: true)
            }
            viewController.navigationItem.leftBarButtonItem = backBarButtonItem
        }
    }
}
