//
//  String+Size.swift
//  ElegantUI
//
//  Created by John on 2019/3/27.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import UIKit

// MARK: - 方便计算某个字体下的 String 在 UILabel 上的宽度或高度（使用 UILabel 通常会比较准确，但有小的性能损耗）
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
        return widthForLabel(font: .systemFont(ofSize: fontSize, weight: .regular), height: height, width: width)
    }
}

// MARK: - 计算某个字体下的 String 的宽度或高度
public extension String {
    /// 文字宽度 (boundingRect)
    /// - Parameter font: 字体
    func width(with font: UIFont) -> CGFloat {
        let attributedString = self.attributedString(font: font)
        return attributedString.width(considering: font.lineHeight)
    }

    /// 文字高度 (boundingRect)
    /// - Parameter font: 字体
    func height(with font: UIFont, considering width: CGFloat) -> CGFloat {
        let attributedString = self.attributedString(font: font)
        return attributedString.height(considering: width)
    }
}

public extension NSAttributedString {
    /// AttributedString 宽度
    /// - Parameter height: 高度限制
    func width(considering height: CGFloat) -> CGFloat {
        let constraintBox = CGSize(width: .greatestFiniteMagnitude, height: height)
        let rect = self.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.width
    }

    /// AttributedString 高度
    /// - Parameter width: 宽度限制
    func height(considering width: CGFloat) -> CGFloat {
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.height
    }
}
