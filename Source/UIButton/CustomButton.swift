//
//  CustomButton.swift
//  GGUI
//
//  Created by John on 2019/3/12.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

/// 方便设置置灰和文字行数的 UIButton
@IBDesignable
open class CustomButton: UIButton {
    /// 置灰时的 alpha
    @IBInspectable open var disableAlpha: CGFloat = Config.CustomButton.disableAlpha {
        didSet { layoutSubviews() }
    }
    /// 文字的行数
    @IBInspectable open var numberOfLines: Int = 1 {
        didSet { layoutSubviews() }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    override open var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            layoutSubviews()
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        alpha = isEnabled ? 1.0 : disableAlpha
        titleLabel?.numberOfLines = numberOfLines
    }
}
