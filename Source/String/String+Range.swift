//
//  String+Range.swift
//  GGUI
//
//  Created by John on 2019/8/1.
//  Copyright © 2019 GGUI. All rights reserved.
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
