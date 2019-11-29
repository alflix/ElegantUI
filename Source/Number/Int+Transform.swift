//
//  Int+Transform.swift
//  GGUI
//
//  Created by John on 2018/10/29.
//  Copyright © 2018 GGUI. All rights reserved.
//

import Foundation

public extension Int {
    /// 将分钟数转换为X小时X分钟
    var hourMinString: String {
        let hoursText = (self / 60).formatString
        let minutesText = (self % 60).formatString
        return "\(hoursText):\(minutesText)"
    }

    /// 将秒数转换为X分钟X秒
    var minSecondString: String {
        let minutesText = (self / 60).formatString
        let secondsText = (self % 60).formatString
        return "\(minutesText):\(secondsText)"
    }

    /// 小于 10 的数字，前面添加 0
    var formatString: String {
        return self < 10 ? "0\(self)" : "\(self)"
    }

    /// 常用的通知数目显示，即 > 99 时使用 "99+"
    var unreadCountString: String {
        return self < 99 ? "\(self)" : "99+"
    }

    /// 后面带 k 的数字格式
    var formatNumber: String {
        let num = Double(abs(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)b"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)m"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)k"

        case 0...:
            return "\(self)"

        default:
            return "\(sign)\(self)"
        }
    }

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

    /// 金额显示格式（带逗号分隔）
    var formatNumberForMATAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let amountString = formatter.string(from: NSNumber(value: self))
        if let result = amountString {
            return result
        }
        return ""
    }
}
