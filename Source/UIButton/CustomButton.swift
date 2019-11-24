//
//  CustomButton.swift
//  GGUI
//
//  Created by John on 2019/3/12.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

/// 方便设置置灰和文字行数的 UIButton
@IBDesignable
open class CustomButton: UIButton {
    /// 置灰时的 alpha
    open var disableAlpha: CGFloat = Config.CustomButton.disableAlpha
    /// 文字的行数
    @IBInspectable open var numberOfLines: Int = 1 {
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

    override open var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : disableAlpha
        }
    }

    override open var intrinsicContentSize: CGSize {
        let size = self.titleLabel!.intrinsicContentSize
        return CGSize(width: size.width + contentEdgeInsets.left + contentEdgeInsets.right,
                      height: size.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
    }
}
