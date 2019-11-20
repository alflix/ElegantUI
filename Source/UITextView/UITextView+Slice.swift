//
//  UITextView+Slice.swift
//  GGUI
//
//  Created by John on 2019/7/8.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UITextView {
    /// 裁剪文字（通常在 textViewDidChange 中调用）
    ///
    /// - Parameter limit: 限制字符
    /// - Returns: 裁剪后的文字数量
    @discardableResult
    func slice(to limit: Int, specialCountInFullWidth: Bool = false) -> Int {
        if specialCountInFullWidth {
            if textCount() > limit {
                guard let currentText = text else { return 0 }
                text = String(currentText.dropLast())
                return slice(to: limit, specialCountInFullWidth: specialCountInFullWidth)
            }
            return textCount()
        }
        if text.count > limit {
            text = String(text.dropLast())
            return slice(to: limit)
        }
        return text.count
    }

    /// 文字数量
    /// - Returns: 数量
    func textCount() -> Int {
        var length = 0
        for char in text {
            // 判断是否是半角字符，是的话+1 ，不是+2（中文，emoji 等）
            length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) >= 3 ? 2 : 1
        }
        return length
    }
}
