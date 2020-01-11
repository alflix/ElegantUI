//
//  TapLabel.swift
//  ElegantUI
//
//  Created by John on 2019/2/18.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import UIKit

public typealias StringTapBlock = (_ text: String, _ range: NSRange) -> Void

/// 使用子类来实现点击检测，消除之前的写法中频繁创建 textContainer， layoutManager，textStorage 可能带来的性能问题，
/// 以及 UILabel 上不受控制的一些属性影响使得可能点击事件检测失败
open class TapLabel: UILabel {
    private var isConfiguring: Bool = false

    open var textInsets: UIEdgeInsets = .zero {
        didSet {
            if !isConfiguring { setNeedsDisplay() }
        }
    }

    private lazy var textContainer: NSTextContainer = {
        let textContainer = NSTextContainer()
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.size = self.bounds.size
        return textContainer
    }()

    private lazy var layoutManager: NSLayoutManager = {
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(self.textContainer)
        return layoutManager
    }()

    private lazy var textStorage: NSTextStorage = {
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(self.layoutManager)
        return textStorage
    }()

    // MARK: - Open Methods
    open override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        textContainer.size = CGSize(width: insetRect.width, height: rect.height)

        let origin = insetRect.origin
        let range = layoutManager.glyphRange(for: textContainer)
        layoutManager.drawBackground(forGlyphRange: range, at: origin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: origin)
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += (textInsets.top + textInsets.bottom)
        size.height += (textInsets.left + textInsets.right)
        return size
    }

    open override var attributedText: NSAttributedString? {
        didSet { setTextStorage(attributedText, shouldParse: true) }
    }

    /// 设置富文本并对其中包含的文字添加点击事件(⚠️ 使用这个方法时 Label 必须是根据其内容自适应宽度和高度的，不能限制宽高，否则点击事件的位置计算会出错)
    ///
    /// - Parameters:
    ///   - attrText: 富文本
    ///   - highlights: 需要响应点击事件的文字数组
    ///   - tapAction: 点击事件包含的文字和 range
    public func addClickAction(by attributedText: NSAttributedString,
                               toOccurrencesOf highlights: [String],
                               tapAction: StringTapBlock?,
                               failAction: VoidBlock? = nil) {
        self.attributedText = attributedText
        isUserInteractionEnabled = true
        guard highlights.count > 0 else { return }
        var matches: [NSTextCheckingResult] = []

        highlights.forEach { (pattern) in
            do {
                let pattern = try NSRegularExpression(pattern: "\\Q\(pattern)\\E")
                let patternMatches = pattern.matches(in: attributedText.string,
                                                     range: NSRange(attributedText.string.startIndex..., in: attributedText.string))
                matches.append(contentsOf: patternMatches)
            } catch let error {
                DPrint("invalid regex: \(error.localizedDescription)")
            }
        }

        onTap { [weak self] (tap) in
            guard let self = self else { return }
            var isTap = false
            for match in matches {
                if self.didTap(in: match.range, tap: tap) {
                    let text = attributedText.attributedSubstring(from: match.range)
                    tapAction?(text.string, match.range)
                    isTap = true
                    break
                }
            }
            if !isTap {
                failAction?()
            }
        }
    }
}

extension TapLabel {
    private func setTextStorage(_ newText: NSAttributedString?, shouldParse: Bool) {
        guard let newText = newText, newText.length > 0 else {
            textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }

        let style = paragraphStyle(for: newText)
        let range = NSRange(location: 0, length: newText.length)

        let mutableText = NSMutableAttributedString(attributedString: newText)
        mutableText.addAttribute(.paragraphStyle, value: style, range: range)
        let modifiedText = NSAttributedString(attributedString: mutableText)
        textStorage.setAttributedString(modifiedText)
        if !isConfiguring { setNeedsDisplay() }
    }

    private func paragraphStyle(for text: NSAttributedString) -> NSParagraphStyle {
        guard text.length > 0 else { return NSParagraphStyle() }
        var range = NSRange(location: 0, length: text.length)
        let existingStyle = text.attribute(.paragraphStyle, at: 0, effectiveRange: &range) as? NSMutableParagraphStyle
        let style = existingStyle ?? NSMutableParagraphStyle()

        style.lineBreakMode = lineBreakMode
        style.alignment = textAlignment

        return style
    }
}

extension TapLabel {
    private func didTap(in targetRange: NSRange, tap: UITapGestureRecognizer) -> Bool {
        guard let characterIndex = characterIndex(at: tap.location(in: self)) else {
            return false
        }
        return NSLocationInRange(characterIndex, targetRange)
    }

    private func characterIndex(at location: CGPoint) -> Int? {
        guard textStorage.length > 0 else { return nil }
        var location = location

        location.x -= textInsets.left
        location.y -= textInsets.top

        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: index, effectiveRange: nil)
        var characterIndex: Int?

        if lineRect.contains(location) {
            characterIndex = layoutManager.characterIndexForGlyph(at: index)
        }
        return characterIndex
    }
}
