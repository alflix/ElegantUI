//
//  UITextField+Slice.swift
//  GGUI
//
//  Created by John on 2019/7/8.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UITextField {
    /// 裁剪文字（通常在 textFieldDidChange 中调用）
    ///
    /// - Parameter limit: 限制字符
    /// - specialCountInFullWidth: 是否视全角字符为 2 个字符，默认否
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
        guard let currentText = text else { return 0 }
        if currentText.count > limit {
            text = String(currentText.dropLast())
            return slice(to: limit)
        }
        return text?.count ?? 0
    }

    /// 文字数量
    /// - Returns: 数量
    func textCount() -> Int {
        guard let currentText = text else { return 0 }
        var length = 0
        for char in currentText {
            // 判断是否是半角字符，是的话+1 ，不是+2（英文/拉丁文等为半角，中文/韩文/日文等为全角）
            length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) >= 3 ? 2 : 1
        }
        return length
    }
}
