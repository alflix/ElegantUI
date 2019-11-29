//
//  Double+Transform.swift
//  GGUI
//
//  Created by John on 2018/10/29.
//  Copyright © 2018 GGUI. All rights reserved.
//

import Foundation

public extension Double {
    /// 显示百分比
    var numberStringAsPercentage: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.percentSymbol = ""
        return formatter.string(from: NSNumber(value: self))!
    }

    /// 显示分隔符
    var numberStringAsDecimal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))!
    }

    /// 截取位数
    func truncate(places: Int) -> Double {
        let first = floor(pow(10.0, Double(places)) * self)
        let second = pow(10.0, Double(places))
        return Double(first/second)
    }

    /// 精度保留
    ///
    /// - Parameters:
    ///   - count: 保留小数后的多少位
    ///   - isKeepZero: 是否保留无效0
    /// - Returns: String
    func keepDecimal(count: Int = 2, isKeepZero: Bool = false) -> String {
        let doubleString = String(format: "%.\(count)f", self)
        if isKeepZero {
            return doubleString
        }
        if !doubleString.contains(".") {
            return doubleString
        }
        // 去除无效0（注意不要直接用NSNumber来转换，因为这样有可能出现科学计数）
        var outNumber = doubleString
        var index = 1
        while index < doubleString.count {
            if outNumber.hasSuffix("0") {
                outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
                index += 1
            } else {
                break
            }
        }
        if outNumber.hasSuffix(".") {
            outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
        }
        return outNumber
    }

    /// 有效精度保留
    ///
    /// - Parameters:
    ///   - count: 保留多少位有效小数
    ///   - isKeepZero: 是否保留无效0
    /// - Returns: String
    func keepValidDecimal(count: Int = 2, isKeepZero: Bool = false) -> String {
        if !String(self).contains(".") || self > 1 {
            return keepDecimal(count: count, isKeepZero: isKeepZero)
        }
        let tmpString = self.keepDecimal(count: 20)
        let subText = String(tmpString.split(separator: ".").last ?? "")
        guard let index = subText.firstIndex(where: { $0 != "0" }) else {
            return keepDecimal(count: count, isKeepZero: isKeepZero)
        }
        let distance = String(self).distance(from: String(self).startIndex, to: index)
        return keepDecimal(count: distance + count, isKeepZero: isKeepZero)
    }
}
