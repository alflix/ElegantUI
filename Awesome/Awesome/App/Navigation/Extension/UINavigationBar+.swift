//
//  UINavigationBar+Addition.swift
//  Awesome
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 NleFlix. All rights reserved.
//

import UIKit

extension UINavigationBar {
    /// 通过 runtime 交换 layoutSubviews 方法
    static func swizzle() {
        swizzling(
            UINavigationBar.self,
            #selector(layoutSubviews),
            #selector(swizzle_layoutSubviews))
    }

    /// 实际的 layoutSubviews 方法
    @objc func swizzle_layoutSubviews() {
        swizzle_layoutSubviews()
        layoutMargins = .zero
        for view in subviews {
            if NSStringFromClass(view.classForCoder).contains("ContentView") {
                view.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            }
        }
    }
}

extension UINavigationBar {
    /// 改变背景 alpha
    func setBackground(alpha: CGFloat) {
        if let barBackgroundView = subviews.first {
            let valueForKey = barBackgroundView.value(forKey:)
            if let shadowView = valueForKey("_shadowView") as? UIView {
                shadowView.alpha = alpha
                shadowView.isHidden = alpha == 0
            }
            if isTranslucent {
                if #available(iOS 10.0, *) {
                    if let backgroundEffectView = valueForKey("_backgroundEffectView") as? UIView,
                        backgroundImage(for: .default) == nil {
                        backgroundEffectView.alpha = alpha
                        return
                    }
                } else {
                    if let adaptiveBackdrop = valueForKey("_adaptiveBackdrop") as? UIView,
                        let backdropEffectView = adaptiveBackdrop.value(forKey: "_backdropEffectView") as? UIView {
                        backdropEffectView.alpha = alpha
                        return
                    }
                }
            }
            barBackgroundView.alpha = alpha
        }
    }

    func removeShadowLine() {
        // setBackgroundImage, 传入 UIImage() 可以去掉分割线。
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }
}
