//
//  InsetLabel.swift
//  GGUI
//
//  Created by John on 2018/12/6.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

/// 可对 Label 设置上下左右边距的 UILabel，默认为 16
public class InsetLabel: UILabel {
    @IBInspectable var topInset: CGFloat = GGUI.Config.InsetLabelConfig.defaultInset
    @IBInspectable var bottomInset: CGFloat = GGUI.Config.InsetLabelConfig.defaultInset
    @IBInspectable var leftInset: CGFloat = GGUI.Config.InsetLabelConfig.defaultInset
    @IBInspectable var rightInset: CGFloat = GGUI.Config.InsetLabelConfig.defaultInset

    override public func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = (text?.count ?? 0 > 0) ? UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset) : .zero
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        if text?.count ?? 0 > 0 {
            return CGSize(width: size.width + leftInset + rightInset,
                          height: size.height + topInset + bottomInset)
        }
        return .zero
    }
}
