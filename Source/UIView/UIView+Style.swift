//
//  UIView+Style.swift
//  GGUI
//
//  Created by John on 2019/7/25.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public struct UIRectSide: OptionSet {
    public let rawValue: Int
    public static let left = UIRectSide(rawValue: 1 << 0)
    public static let top = UIRectSide(rawValue: 1 << 1)
    public static let right = UIRectSide(rawValue: 1 << 2)
    public static let bottom = UIRectSide(rawValue: 1 << 3)
    public static let all: UIRectSide = [.top, .right, .left, .bottom]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension UIView {
    ///  画虚线边框
    ///
    /// - Parameters:
    ///   - strokeColor: 边框的颜色
    ///   - lineWidth: 边框的宽度
    ///   - lineLength: 虚线长度
    ///   - lineSpacing: 两段虚线之间的间隔
    ///   - realSize: 该view的真正大小
    ///   - rectSide: 要画哪些边
    func drawDashLine(strokeColor: UIColor,
                      lineWidth: CGFloat = 1,
                      lineLength: Float = 2,
                      lineSpacing: Float = 2,
                      realSize: CGSize? = nil,
                      rectSide: UIRectSide) {
        let viewSize: CGSize! = realSize == nil ? frame.size : realSize
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = .round
        // 每一段虚线长度和每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        let path = CGMutablePath()
        if rectSide.contains(.left) {
            path.move(to: CGPoint(x: 0, y: viewSize.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
        if rectSide.contains(.top) {
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: viewSize.width, y: 0))
        }
        if rectSide.contains(.right) {
            path.move(to: CGPoint(x: viewSize.width, y: 0))
            path.addLine(to: CGPoint(x: viewSize.width, y: viewSize.height))
        }
        if rectSide.contains(.bottom) {
            path.move(to: CGPoint(x: viewSize.width, y: viewSize.height))
            path.addLine(to: CGPoint(x: 0, y: viewSize.height))
        }
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }

    /// 添加渐变色图层
    func gradientColor(startPoint: CGPoint, endPoint: CGPoint, colors: [Any], frame: CGRect) {
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1,
            endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
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
        guard let sublayers = layer.sublayers else { return }
        for layer in sublayers {
            if layer.isKind(of: CAGradientLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
    }
}
