//
//  UIView+Style.swift
//  GGUI
//
//  Created by John on 2019/7/25.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UIView {
    /// 添加渐变色图层
    func gradientColor(startPoint: CGPoint, endPoint: CGPoint, colors: [Any], frame: CGRect) {
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }
        // 外界如果改变了self的大小，需要先刷新
        layoutIfNeeded()
        var gradientLayer: CAGradientLayer!
        removeGradientLayer()
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        layer.insertSublayer(gradientLayer, at: 0)
        // self如果是UILabel，masksToBounds设为true会导致文字消失
        layer.masksToBounds = false
    }

    /// 移除渐变图层（当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
    private func removeGradientLayer() {
        if let sublayers = layer.sublayers {
            for layer in sublayers {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}
