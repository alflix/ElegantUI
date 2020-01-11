//
//  String+Range.swift
//  ElegantUI
//
//  Created by John on 2019/8/1.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation

public extension String {
    /// 寻找当前在传入文字的 range，只返回第一个匹配的
    ///
    /// - Parameter string: 传入文字
    /// - Returns: 第一个匹配的的 NSRange
    func firstRangeOf(string: String) -> NSRange? {
        guard let range = string.range(of: self) else { return nil }
        let startPos = string.distance(from: string.startIndex, to: range.lowerBound)
        return NSRange(location: startPos, length: self.count)
    }

    /// 寻找当前在传入文字的 range，返回所有结果
    ///
    /// - Parameter string: 传入文字
    /// - Returns: 所有匹配的的 NSRange
    func rangesOf(string: String) -> [NSRange] {
        var matches: [NSTextCheckingResult] = []
        do {
            let pattern = try NSRegularExpression(pattern: "\\Q\(self)\\E")
            let patternMatches = pattern.matches(in: string, range: NSRange(string.startIndex..., in: string))
            matches.append(contentsOf: patternMatches)
        } catch let error {
            DPrint("invalid regex: \(error.localizedDescription)")
        }
        return matches.map {$0.range}
    }
}

/// https://stackoverflow.com/questions/26152448/swift-generate-an-array-of-swift-characters
/// let characters = ("a"..."z").characters  // "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
/// let string = ("a"..."z").string          // "abcdefghijklmnopqrstuvwxyz"
public extension ClosedRange where Bound == Unicode.Scalar {
    static let asciiPrintable: ClosedRange = " "..."~"
    var range: ClosedRange<UInt32> { return lowerBound.value...upperBound.value }
    var scalars: [Unicode.Scalar] { return range.compactMap(Unicode.Scalar.init) }
    var characters: [Character] { return scalars.map(Character.init) }
    var string: String { return String(scalars) }
}

public extension String {
    init<S: Sequence>(_ sequence: S) where S.Element == Unicode.Scalar {
        self.init(UnicodeScalarView(sequence))
    }
}
