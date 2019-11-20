//
//  CALayer+Sketch.swift
//  GGUI
//
//  Created by John on 2019/05/21.
//  Copyright © 201p Ganguo. All rights reserved.
//

import UIKit

public extension CALayer {
    /// 增加阴影（Sketch 的参数）
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.25,
        x: CGFloat = 0,
        y: CGFloat = 3,
        blur: CGFloat = 6,
        spread: CGFloat = 0) {
        cornerRadius = shadowRadius
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
