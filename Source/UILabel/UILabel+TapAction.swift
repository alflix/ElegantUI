//
//  UILabel+TapAction.swift
//  GGUI
//
//  Created by John on 2019/2/18.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 设置富文本并对其中包含的文字添加点击事件(⚠️ 使用这个方法时 Label 必须是根据其内容自适应宽度和高度的，不能限制宽高，否则点击事件的位置计算会出错)
    ///
    /// - Parameters:
    ///   - attrText: 富文本
    ///   - highlights: 需要响应点击事件的文字数组
    ///   - tapAction: 点击事件包含的文字和 range
    func addClickAction(by attrText: NSAttributedString, toOccurrencesOf highlights: [String], tapAction: StringTapBlock?) {
        attributedText = attrText
        isUserInteractionEnabled = true
        guard highlights.count > 0 else { return }
        var matches: [NSTextCheckingResult] = []

        highlights.forEach { (pattern) in
            do {
                let pattern = try NSRegularExpression(pattern: "\\Q\(pattern)\\E")
                let patternMatches = pattern.matches(in: attrText.string,
                                                     range: NSRange(attrText.string.startIndex..., in: attrText.string))
                matches.append(contentsOf: patternMatches)
            } catch let error {
                DPrint("invalid regex: \(error.localizedDescription)")
            }
        }

        onTap { [weak self] (tap) in
            guard let self = self else { return }
            for match in matches {
                if self.didTap(in: match.range, tap: tap) {
                    let text = attrText.attributedSubstring(from: match.range)
                    tapAction?(text.string, match.range)
                    break
                }
            }
        }
    }

    private func didTap(in targetRange: NSRange, tap: UITapGestureRecognizer) -> Bool {
        let textContainer = NSTextContainer(size: bounds.size)
        // UILabel 没有左右间距，所以这个值是 0
        textContainer.lineFragmentPadding = 0.0
        if let attributes = attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
             textContainer.lineBreakMode = attributes.lineBreakMode
        } else {
            textContainer.lineBreakMode = lineBreakMode
        }
        textContainer.maximumNumberOfLines = numberOfLines
            
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage(attributedString: attributedText!)
        textStorage.addLayoutManager(layoutManager)
        guard textStorage.length > 0 else { return false }

        // 点击位置
        let location = tap.location(in: self)
        // 点击位置所在的字符
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        // 点击位置所在的字符的所在一行的 Rect
        let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: index, effectiveRange: nil)
        var characterIndex: Int = 0

        if lineRect.contains(location) {
            characterIndex = layoutManager.characterIndexForGlyph(at: index)
        }

        return NSLocationInRange(characterIndex, targetRange)
    }
}
