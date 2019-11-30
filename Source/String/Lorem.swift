//
//  Lorem.swift
//  GGUI
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 GGUI. All rights reserved.
//

import Foundation

/// 生成随机文本
public class Lorem {
    public enum Config {
        /// 输入的单词源
        public static var wordList: [String] = []
        /// 是否中文
        public static var isChinese: Bool = false
    }

    class var wordSpace: String {
        return Config.isChinese ? "" : " "
    }

    public class func word() -> String {
        return Config.wordList.random()!
    }

    public class func words(nbWords: Int = 3) -> [String] {
        return Config.wordList.random(nbWords)
    }

    public class func words(nbWords: Int = 3) -> String {
        return words(nbWords: nbWords).joined(separator: wordSpace)
    }

    public class func sentence(nbWords: Int = 6, variable: Bool = true) -> String {
        if nbWords <= 0 {
            return ""
        }
        let result: String = words(nbWords: variable ? nbWords.randomize(variation: 40) : nbWords)
        return result.firstCapitalized + (Config.isChinese ? "。" : ".")
    }

    public class func sentences(nbSentences: Int = 3) -> [String] {
        return (0..<nbSentences).map { _ in sentence() }
    }

    public class func paragraph(nbSentences: Int = 3, variable: Bool = true) -> String {
        if nbSentences <= 0 {
            return ""
        }
        return sentences(nbSentences: variable ? nbSentences.randomize(variation: 40) : nbSentences).joined(separator: wordSpace)
    }

    public class func paragraphs(nbParagraphs: Int = 3) -> [String] {
        return (0..<nbParagraphs).map { _ in paragraph() }
    }

    public class func paragraphs(nbParagraphs: Int = 3) -> String {
        return paragraphs(nbParagraphs: nbParagraphs).joined(separator: "\n\n")
    }

    public class func text(maxNbChars: Int = 200) -> String {
        var result: [String] = []
        if maxNbChars < 5 {
            return ""
        } else if maxNbChars < 25 {
            while result.count == 0 {
                var size = 0
                while size < maxNbChars {
                    let w = (size != 0 ? wordSpace : "") + word()
                    result.append(w)
                    size += w.count
                }
                _ = result.popLast()
            }
        } else if maxNbChars < 100 {
            while result.count == 0 {
                var size = 0
                while size < maxNbChars {
                    let sen = (size != 0 ? wordSpace : "") + sentence()
                    result.append(sen)
                    size += sen.count
                }
                _ = result.popLast()
            }
        } else {
            while result.count == 0 {
                var size = 0

                while size < maxNbChars {
                    let para = (size != 0 ? "\n" : "") + paragraph()
                    result.append(para)
                    size += para.count
                }
                _ = result.popLast()
            }
        }
        return result.joined(separator: "")
    }
}

extension String {
    // 第一个字符设置为大写
    var firstCapitalized: String {
        var string = self
        string.replaceSubrange(string.startIndex...string.startIndex, with: String(string[string.startIndex]).capitalized)
        return string
    }
}

public extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if j != i {
                self.swapAt(i, j)
            }
        }
    }

    func shuffled() -> [Element] {
        var list = self
        list.shuffle()
        return list
    }

    func random() -> Element? {
        return (count > 0) ? self.shuffled()[0] : nil
    }

    func random(_ count: Int = 1) -> [Element] {
        let result = shuffled()
        return (count > result.count) ? result : Array(result[0..<count])
    }
}
