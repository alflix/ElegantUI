//
//  String+Attributed.swift
//  ElegantUI
//
//  Created by John on 2019/3/27.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation
import UIKit

public typealias AttributedStringBlock = (_ attributedString: NSMutableAttributedString) -> Void

// MARK: - 方便创建 NSAttributedString
public extension String {
    /// 创建 NSAttributedString（简洁版）
    ///
    /// - Parameters:
    ///   - font: 字体 默认 .systemFont(ofSize: 14)
    ///   - color: 文字颜色，默认 .black
    /// - Returns: NSAttributedString
    func attributedString(font: UIFont = Config.AttributedString.defaultFont,
                          color: UIColor = Config.AttributedString.defaultColor) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: font]
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        return attributedString
    }

    /// 创建 NSAttributedString（复杂版）
    ///
    /// - Parameters:
    ///   - font: 字体 默认 .systemFont(ofSize: 14)
    ///   - color: 文字颜色，默认 .black
    ///   - lineSpacing: 行距，默认 字体大小*0.25
    ///   - alignment: 对齐方式，默认左对齐
    ///   - minimumLineHeight: 最小行高，默认不设置
    ///   - baselineOffset: 基准线 offset，默认不设置
    ///   - addition: 一个包含 NSMutableAttributedString 的 Block，可以设置额外的 Attributed 属性
    /// - Returns: NSAttributedString
    func attributedString(font: UIFont = Config.AttributedString.defaultFont,
                          color: UIColor = Config.AttributedString.defaultColor,
                          lineSpacing: CGFloat? = nil,
                          alignment: NSTextAlignment = .left,
                          minimumLineHeight: CGFloat = 0,
                          baselineOffset: CGFloat = 0,
                          addition: AttributedStringBlock? = nil) -> NSAttributedString {
        return attributedString(highlight: nil, font: font,
                                highlightFont: font,
                                color: color,
                                highlightColor: color,
                                lineSpacing: lineSpacing,
                                alignment: alignment,
                                minimumLineHeight: minimumLineHeight,
                                baselineOffset: baselineOffset,
                                addition: addition)
    }

    /// 创建 NSAttributedString（复杂版，同时支持高亮某些文字）
    ///
    /// - Parameters:
    ///   - highlight: 需要高亮的文字数组，默认为空数组
    ///   - font: 字体 默认 .systemFont(ofSize: 14)，可在 ElegantUI.Config.AttributedString 统一设置
    ///   - highlightFont: 高亮字体 默认 .pingfangFont(ofSize: 14)，可在 ElegantUI.Config.AttributedString 统一设置
    ///   - color: 文字颜色，默认 .black，可在 ElegantUI.Config.AttributedString 统一设置
    ///   - highlightColor: 高亮文字颜色， 默认 .black，可在 ElegantUI.Config.AttributedString 统一设置
    ///   - lineSpacing: 行距，默认 字体大小*0.25
    ///   - alignment: 对齐方式，默认左对齐
    ///   - minimumLineHeight: 最小行高，默认不设置
    ///   - baselineOffset: 基准线 offset，默认不设置
    ///   - centerBaseLineTwoFont: 使两个不同字体水平方向对齐
    ///   - addition: 一个包含 NSMutableAttributedString 的 Block，可以设置额外的 Attributed 属性
    /// - Returns: NSAttributedString
    func attributedString(highlight: [String]? = [],
                          font: UIFont = Config.AttributedString.defaultFont,
                          highlightFont: UIFont? = nil,
                          color: UIColor = Config.AttributedString.defaultColor,
                          highlightColor: UIColor = Config.AttributedString.defaultColor,
                          lineSpacing: CGFloat? = nil,
                          alignment: NSTextAlignment = .left,
                          minimumLineHeight: CGFloat = 0,
                          baselineOffset: CGFloat? = nil,
                          centerBaseLineTwoFont: Bool = false,
                          addition: AttributedStringBlock? = nil) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = lineSpacing ?? font.pointSize * 0.25
        paragraphStyle.alignment = alignment
        if minimumLineHeight > 0 {
            paragraphStyle.minimumLineHeight = minimumLineHeight
        }
        var attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .foregroundColor: color, .font: font]
        if let baselineOffset = baselineOffset {
            attributes[NSAttributedString.Key.baselineOffset] = baselineOffset
        }
        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)
        let highlightFont = highlightFont ?? font
        if let highlight = highlight, highlight.count > 0 {
            highlight.forEach { (string) in
                let adjustOffset = centerBaseLineTwoFont ? (font.lineHeight - highlightFont.lineHeight)/2 + (font.descender - highlightFont.descender) : 0
                attributedString.mutableApplying(attributes: [.paragraphStyle: paragraphStyle,
                                                              .foregroundColor: highlightColor,
                                                              .font: highlightFont,
                                                              .baselineOffset: adjustOffset],
                                                 toOccurrencesOf: string)
            }
        }
        addition?(attributedString)
        return attributedString.copy() as! NSAttributedString
    }

    /// 创建 NSAttributedString（复杂版，同时支持高亮某些文字）
    ///
    /// - Parameters:
    ///   - highlightRange: 需要高亮的 NSRange 数组，默认为空数组
    ///   - font: 字体 默认 .systemFont(ofSize: 14)，可在 ElegantUI.Config.AttributedString 统一设置
    ///   - highlightFont: 高亮字体 默认 .pingfangFont(ofSize: 14)，可在 ElegantUI.Config.AttributedString 统一设置
    ///   - color: 文字颜色，默认 .black，可在 ElegantUI.Config.AttributedString 统一设置
    ///   - highlightColor: 高亮文字颜色， 默认 .black，可在 ElegantUI.Config.AttributedString 统一设置
    ///   - lineSpacing: 行距，默认 字体大小*0.25
    ///   - alignment: 对齐方式，默认左对齐
    ///   - minimumLineHeight: 最小行高，默认不设置
    ///   - baselineOffset: 基准线 offset，默认不设置
    ///   - centerBaseLineTwoFont: 使两个不同字体水平方向对齐
    ///   - addition: 一个包含 NSMutableAttributedString 的 Block，可以设置额外的 Attributed 属性
    /// - Returns: NSAttributedString
    func attributedString(highlightRange: [NSRange]? = [],
                          font: UIFont = Config.AttributedString.defaultFont,
                          highlightFont: UIFont? = nil,
                          color: UIColor = Config.AttributedString.defaultColor,
                          highlightColor: UIColor = Config.AttributedString.defaultColor,
                          lineSpacing: CGFloat? = nil,
                          alignment: NSTextAlignment = .left,
                          minimumLineHeight: CGFloat = 0,
                          baselineOffset: CGFloat? = nil,
                          centerBaseLineTwoFont: Bool = false,
                          addition: AttributedStringBlock? = nil) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = lineSpacing ?? font.pointSize * 0.25
        paragraphStyle.alignment = alignment
        if minimumLineHeight > 0 {
            paragraphStyle.minimumLineHeight = minimumLineHeight
        }
        var attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .foregroundColor: color, .font: font]
        if let baselineOffset = baselineOffset {
            attributes[NSAttributedString.Key.baselineOffset] = baselineOffset
        }
        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)
        let highlightFont = highlightFont ?? font
        if let highlightRange = highlightRange, highlightRange.count > 0 {
            highlightRange.forEach { (range) in
                let adjustOffset = centerBaseLineTwoFont ? (font.lineHeight - highlightFont.lineHeight)/2 + (font.descender - highlightFont.descender) : 0
                attributedString.addAttributes([.paragraphStyle: paragraphStyle,
                                                .foregroundColor: highlightColor,
                                                .font: highlightFont,
                                                .baselineOffset: adjustOffset], range: range)
            }
        }
        addition?(attributedString)
        return attributedString.copy() as! NSAttributedString
    }
}

public extension NSMutableAttributedString {
    func mutableApplying(attributes: [NSAttributedString.Key: Any]) {
        let range = (string as NSString).range(of: string)
        addAttributes(attributes, range: range)
    }

    func mutableApplying<T: StringProtocol>(attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: T) {
        let pattern = "\\Q\(target)\\E"
        mutableApplying(attributes: attributes, toRangesMatching: pattern)
    }

    func mutableApplying(attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String) {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return }
        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        for match in matches {
            addAttributes(attributes, range: match.range)
        }
    }
}
