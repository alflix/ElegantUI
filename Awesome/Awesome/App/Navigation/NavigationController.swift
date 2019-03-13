//
//  NavigationController.swift
//  navigationController
//
//  Created by John on 2019/3/7.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit
import SwifterSwift

class NavigationController: UINavigationController {
    
    var enablePopGesture = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
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
private extension NavigationController {
    
    func setupNavigationBar() {
        // default: 灰色背景 白色文字 black: 纯黑色背景 白色文字，会被👇的设置项覆盖
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
        navigationBar.setBackgroundImage(UIImage(named: "trello"), for: .default)
    }
    
    func hideBottomLine() {
        // 设置底部分割线，如果传入 UIImage() 可以去掉分割线。
        navigationBar.shadowImage = UIImage(color: .red, size: CGSize(width: navigationBar.width, height: 0.5))
        navigationBar.shadowImage = UIImage()
        
        // 去掉分割线的另外一种方式（会影响到 statusBar，不建议使用这个属性）
        navigationBar.clipsToBounds = true
    }
    
    func setupDefaultBackItem(push viewController: UIViewController) {
        if viewControllers.count > 0 && (viewController.navigationItem.leftBarButtonItem == nil) {
            viewController.hidesBottomBarWhenPushed = true
            let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain,
                                                    target: self, action: #selector(backAction))
            viewController.navigationItem.leftBarButtonItem = backBarButtonItem
        }
    }
}

private extension NavigationController {
    
    @objc func backAction(){
        popViewController(animated: true)
    }
}
