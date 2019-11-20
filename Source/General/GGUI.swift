//
//  GGUI.Config.swift
//  GGUI
//
//  Created by John on 2019/1/21.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import Foundation

/// 重要，GGUI 的全局设置，需要调整时，请在 AppDelegate 中配置
public struct Config {
    /// 自定义 LineView 配置
    public enum LineView {
        /// 颜色
        public static var color: UIColor = .lightGray
        /// 线宽
        public static var lineWidth: CGFloat = 1.0
    }

    /// 快速创建 AttributedString 的默认设置项
    public enum AttributedString {
        /// 颜色
        public static var defaultColor: UIColor = .black
        /// 字体
        public static var defaultFont: UIFont = .systemFont(ofSize: 14)
    }

    /// 自定义 Button 配置
    public enum CustomButton {
        /// 不可点击状态的 alpha 值
        public static var disableAlpha: CGFloat = 0.4
    }

    /// 自定义 TextField 配置
    public enum CustomTextField {
        /// placeholder 文字颜色
        public static var placeholderColor: UIColor = .lightGray
    }

    /// 对 Label 设置上下左右边距的 UILabel 的默认值
    public enum InsetLabelConfig {
        public static var defaultInset: CGFloat = 16
    }

    /// Codable 配置
    public enum Codable {
        /// 日期的格式
        public static var dateFormat: String?
        /// 日期 Decode 策略，如果 dateFormat 不为空，会以 dateFormat 创建的 formatted(DateFormatter) 为准，即该设置会被忽略
        public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .millisecondsSince1970
        /// 日期 Encode 策略，如果 dateFormat 不为空，会以 dateFormat 创建的 formatted(DateFormatter) 为准，即该设置会被忽略
        public static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .millisecondsSince1970
    }
}

// 用于 Pod 内部的本地化
extension String {
    var bundleLocalize: String {
        return NSLocalizedString(self, tableName: "Localize", bundle: Bundle(for: LocalizeHelper.self), value: "", comment: "")
    }
}

class LocalizeHelper: NSObject {}
