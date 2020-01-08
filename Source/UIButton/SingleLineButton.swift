//
//  SingleLineButton.swift
//  GGUI
//
//  Created by John on 2019/5/21.
//

import UIKit

/// 可以方便的对 Button 的上下左右设置横线
// TODO： 可能有问题，调用太多layoutSubviews
open class SingleLineButton: UIButton {
    /// 上横线
    @IBInspectable public var top: CGFloat = 0 {
        // 不能再次调用 layoutSubviews，否则会引发死循环
        didSet { layoutSubviews() }
    }
    /// 左横线
    @IBInspectable public var left: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    /// 下横线
    @IBInspectable public var bottom: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    /// 右横线
    @IBInspectable public var right: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    /// 上横线左右 Offset
    @IBInspectable public var topOffset: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    /// 左横线上下 Offset
    @IBInspectable public var leftOffset: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    /// 下横线左右 Offset
    @IBInspectable public var bottomOffset: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    /// 右横线上下 Offset
    @IBInspectable public var rightOffset: CGFloat = 0 {
        didSet { layoutSubviews() }
    }

    private lazy var topLineView: SingleLineView = SingleLineView(frame: .zero)
    private lazy var leftLineView: SingleLineView = SingleLineView(frame: .zero)
    private lazy var bottomLineView: SingleLineView = SingleLineView(frame: .zero)
    private lazy var rightLineView: SingleLineView = SingleLineView(frame: .zero)

    override open func layoutSubviews() {
        super.layoutSubviews()
        if top > 0 {
            if topLineView.superview == nil {
                addSubview(topLineView)
            }
            topLineView.frame = CGRect(x: topOffset, y: 0, width: bounds.width-topOffset*2, height: top)
        }
        if left > 0 {
            if leftLineView.superview == nil {
                addSubview(leftLineView)
            }
            leftLineView.frame = CGRect(x: 0, y: leftOffset, width: left, height: bounds.height-leftOffset*2)
        }
        if bottom > 0 {
            if bottomLineView.superview == nil {
                addSubview(bottomLineView)
            }
            bottomLineView.frame = CGRect(x: bottomOffset, y: bounds.height - bottom, width: bounds.width-bottomOffset*2, height: bottom)
        }
        if right > 0 {
            if rightLineView.superview == nil {
                addSubview(rightLineView)
            }
            rightLineView.frame = CGRect(x: bounds.width - right, y: rightOffset, width: right, height: bounds.height-rightOffset*2)
        }
    }
}
