//
//  UIViewController+Rotate.swift
//  GGUI
//
//  Created by John on 2019/12/13.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UIViewController {
    fileprivate struct AssociatedKey {
        static var rotateOrientation: String = "rotateOrientation.UIViewcontroller"
    }

    /// 强制设置设备方向，需同时实现 shouldAutorotate 和 supportedInterfaceOrientations，通常在 viewWillAppear & viewWillDisappear 调用
    public var rotateOrientations: UIInterfaceOrientation {
        get {
            guard let rotateOrientation = associatedObject(forKey: &AssociatedKey.rotateOrientation) as? UIInterfaceOrientation else {
                return .portrait
            }
            return rotateOrientation
        }
        set {
            associate(retainObject: newValue, forKey: &AssociatedKey.rotateOrientation)
            UIDevice.current.setValue(newValue.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
            UITabBarController.attemptRotationToDeviceOrientation()
        }
    }
}

extension UINavigationController {
    open override var shouldAutorotate: Bool {
        return visibleViewController?.shouldAutorotate ?? false
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return visibleViewController?.supportedInterfaceOrientations ?? .portrait
    }
}

extension UITabBarController {
    open override var shouldAutorotate: Bool {
        if let selectedViewController = selectedViewController as? UINavigationController {
            return selectedViewController.visibleViewController?.shouldAutorotate ?? false
        }
        return selectedViewController?.shouldAutorotate ?? false
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let selectedViewController = selectedViewController as? UINavigationController {
            return selectedViewController.visibleViewController?.supportedInterfaceOrientations ?? .portrait
        }
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
