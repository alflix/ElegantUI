//
//  InsetLabel.swift
//  GGUI
//
//  Created by John on 2018/12/6.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

/// 可对 Label 设置上下左右边距的 UILabel，默认为 16。若 textInsets 不为 nil，优先设置 textInsets
open class InsetLabel: UILabel {
    @IBInspectable open var topInset: CGFloat = Config.InsetLabel.defaultInset {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var bottomInset: CGFloat = Config.InsetLabel.defaultInset {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var leftInset: CGFloat = Config.InsetLabel.defaultInset {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable open var rightInset: CGFloat = Config.InsetLabel.defaultInset {
        didSet { setNeedsDisplay() }
    }
    open var textInsets: UIEdgeInsets? {
        didSet { setNeedsDisplay() }
    }

    override public func drawText(in rect: CGRect) {
        var insets = textInsets
        if insets == nil {
            insets = (text?.count ?? 0 > 0) ? UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset) : .zero
        }
        super.drawText(in: rect.inset(by: insets!))
    }

    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        guard text?.count ?? 0 > 0 else { return size }
        if let insets = textInsets {
            return CGSize(width: size.width + insets.left + insets.right,
                          height: size.height + insets.top + insets.bottom)
        }
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
