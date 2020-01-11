//
//  String+Attributed.swift
//  ElegantUI
//
//  Created by John on 2019/3/27.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation

// MARK: - String 的工具类
public extension String {
    /// 从 URL String中截取出参数
    ///
    /// 🌰：http://example.com?param1=value1&param2=value2 -> Optional([“param1”: value1, “param2”: value2])
    var urlParameters: [String: Any]? {
        // 截取是否有参数
        guard let urlComponents = NSURLComponents(string: self), let queryItems = urlComponents.queryItems else { return nil }
        // 参数字典
        var parameters = [String: AnyObject]()
        // 遍历参数
        queryItems.forEach({ (item) in
            // 判断参数是否是数组
            if let existValue = parameters[item.name], let value = item.value {
                // 已存在的值，生成数组
                if var existValue = existValue as? [AnyObject] {
                    existValue.append(value as AnyObject)
                } else {
                    parameters[item.name] = [existValue, value] as AnyObject
                }
            } else {
                parameters[item.name] = item.value as AnyObject
            }
        })
        return parameters
    }

    // 获取拼音首字母(大写)
    var firstPinyinCapitalized: String {
        // 字符串转换为首字母大写
        let pinyin = transformToPinyin.capitalized
        var headPinyinStr = ""

        // 获取所有大写字母
        for character in pinyin {
            if character <= "Z" && character >= "A" {
                headPinyinStr.append(character)
            }
        }
        return headPinyinStr
    }

    // 是否包含中文
    var isIncludeChinese: Bool {
        for character in self.unicodeScalars {
            // 中文字符范围：0x4e00 ~ 0x9fff
            if 0x4e00 < character.value  && character.value < 0x9fff {
                return true
            }
        }
        return false
    }

    private var transformToPinyin: String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String

        return pinyin
    }
}
