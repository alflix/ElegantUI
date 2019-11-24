//
//  SingleLineView.swift
//  GGUI
//
//  Created by John on 2019/2/27.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public enum LineStyle: Int {
    case solid
    case dash
}

@IBDesignable
open class SingleLineView: UIView {
    private let singleLineAdjustOffset = ((1/UIScreen.main.scale)/2)

    /// 实线还是虚线 - solid: 实线 - dash: 点线
    public var lineStyle: LineStyle = .solid {
        didSet { setNeedsDisplay() }
    }

    /// 实线还是虚线 - 0: 实线 - 1: 点线 (由于 enum 类型不可以在 Xib 中设置)
    @IBInspectable public var lineStyleInt: Int {
        get {
            return lineStyle.rawValue
        }
        set {
            lineStyle = LineStyle(rawValue: newValue) ?? .solid
        }
    }

    /// 线高, 默认 1.0，可以通过 GGUI.Config.LineView.lineWidth 全局修改
    @IBInspectable public var lineWidth: CGFloat = Config.LineView.lineWidth {
        didSet { setNeedsDisplay() }
    }

    /// 线的颜色  默认 lightGray，可以通过 GGUI.Config.LineView.color 全局修改
    @IBInspectable public var lineColor: UIColor = Config.LineView.color {
        didSet {
            // 这个方法会调用 draw 方法, 所以不是 layoutSubviews()
            setNeedsDisplay()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
    }

    override public func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(lineColor.cgColor)
        context?.setShouldAntialias(false)

        if lineStyle == .dash || lineStyleInt == 1 {
            let dash: [CGFloat] = [1.0, 1.0]
            context?.setLineDash(phase: 0, lengths: dash)
        }

        var adjustPixelOffset: CGFloat = 0
        //画一像素线
        let actualWidth = (lineWidth / UIScreen.main.scale)

        if actualWidth <= CGFloat(1.0), Int((lineWidth + CGFloat(1))) % 2 == 0 {
            adjustPixelOffset = singleLineAdjustOffset
        }

        context?.setLineWidth(lineWidth)

        var startPoint: CGPoint?
        var endPoint: CGPoint?

        if bounds.height > bounds.width {
            startPoint = CGPoint(x: bounds.width -  adjustPixelOffset, y: 0)
            endPoint = CGPoint(x: bounds.width - adjustPixelOffset, y: bounds.height)
        } else {
            startPoint = CGPoint(x: 0, y: bounds.height - adjustPixelOffset)
            endPoint = CGPoint(x: bounds.width, y: bounds.height - adjustPixelOffset)
        }

        context?.move(to: startPoint!)
        context?.addLine(to: endPoint!)
        context?.strokePath()
    }
}
