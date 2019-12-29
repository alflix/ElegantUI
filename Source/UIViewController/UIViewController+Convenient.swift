//
//  UIViewController+Convenient.swift
//  GGUI
//
//  Created by John on 2018/12/29.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UIViewController {
    /// 检查是否是 present 出来的（会检查父视图）
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }

    /// dismiss/popToRootViewController 取决于是否是 present 出来的
    func popToRootOrDismiss() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }

    /// dismiss/popToRootViewController 取决于是否是 present 出来的
    @objc func popBackOrDismiss() {
        if navigationController?.children.count ?? 0 > 1 {
            navigationController?.popViewController(animated: true)
        } else if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            assert(true, "can't dismiss or pop back")
        }
    }

    /// 全屏 present 方法（以兼容 iOS 13）
    func fullPresent(_ viewControllerToPresent: UIViewController) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}
