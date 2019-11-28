//
//  UIView+Convenient.swift
//  GGUI
//
//  Created by John on 2019/7/25.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UIView {
    /// removeFromSuperview 之前增加 superview == nil 的判断
    func safeRemoveFromSuperview() {
        if superview == nil { return }
        removeFromSuperview()
    }

    convenience init(backgroundColor: UIColor?) {
        self.init()
        self.backgroundColor = backgroundColor
    }
}

extension CGRect {
    init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
}

public extension UIView {
    // TODO: 可封装 -> GGUI
    /// 添加虚线边框
    @discardableResult
    func drawDottedLine(start point0: CGPoint,
                        end point1: CGPoint,
                        strokeColor: UIColor? = nil,
                        lineWidth: CGFloat? = nil,
                        lineDashPattern: [NSNumber]? = nil) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = strokeColor?.cgColor ?? UIColor.lightGray.cgColor
        shapeLayer.lineWidth = lineWidth ?? 1
        // 4 虚线高, 3 间隔高.
        shapeLayer.lineDashPattern = lineDashPattern ?? [4, 1]
        let path = CGMutablePath()
        path.addLines(between: [point0, point1])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
        return shapeLayer
    }
}
