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
    open var disableAlpha: CGFloat = GGUI.Config.CustomButton.disableAlpha
    /// 文字的行数
    @IBInspectable open dynamic var numberOfLines: Int = 1 {
        didSet {
            self.titleLabel?.numberOfLines = numberOfLines
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    override open dynamic var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : disableAlpha
        }
    }
}
