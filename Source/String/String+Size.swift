//
//  String+Size.swift
//  GGUI
//
//  Created by John on 2019/3/27.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

// MARK: - 方便计算某个字体下的 String 在 UILabel 上的宽度或高度（使用 UILabel 会比较准确）
public extension String {
    /// 文字高度  
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大宽度
    /// - Returns: 高度
    func heightForLabel(line: Int = 0, font: UIFont, width: CGFloat) -> CGFloat {
        return autoreleasepool { () -> CGFloat in
            let label: UILabel = UILabel()
            label.numberOfLines = line
            label.font = font
            label.text = self
            return label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        }
    }

    /// 文字宽度
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大高度  
    /// - Returns: 宽度
    func widthForLabel(font: UIFont, height: CGFloat, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        return autoreleasepool { () -> CGFloat in
            let label: UILabel = UILabel()
            label.numberOfLines = 1
            label.font = font
            label.text = self
            return label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
        }
    }

    /// 文字宽度
    ///
    /// - Parameters:
    ///   - fontSize: 字体 size
    ///   - width: 最大高度  
    /// - Returns: 宽度
    func widthForLabel(fontSize: CGFloat, height: CGFloat, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGFloat {
        return autoreleasepool { () -> CGFloat in
            let label: UILabel = UILabel()
            label.numberOfLines = 1
            label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            label.text = self
            return label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
        }
    }

    func boundingWidth(with font: UIFont) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight)
        let preferredRect = (self as NSString).boundingRect(with: size,
                                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(preferredRect.width)
    }
}
