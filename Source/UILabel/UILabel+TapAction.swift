//
//  UILabel+TapAction.swift
//  GGUI
//
//  Created by John on 2019/2/18.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 设置富文本并对其中包含的文字添加点击事件(⚠️，使用这个方法时 Label 必须是根据其内容自适应宽度和高度的，不能限制宽高，否则点击事件的位置计算会出错)
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
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage(attributedString: attributedText!)
        textStorage.addLayoutManager(layoutManager)

        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: ( bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: ( bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInLabel = tap.location(in: self)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)

        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
