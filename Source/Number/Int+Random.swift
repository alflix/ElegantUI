//
//  Int+Random.swift
//  ElegantUI
//
//  Created by John on 2018/10/29.
//  Copyright © 2018 ElegantUI. All rights reserved.
//

import Foundation

public extension Int {
    static func random(min: Int = 0, max: Int = Int.max) -> Int {
        precondition(min <= max, "attempt to call random() with min > max")
        let diff = UInt(bitPattern: max &- min)
        let result = UInt.random(min: 0, max: diff)
        return min + Int(bitPattern: result)
    }

    func randomize(variation: Int) -> Int {
        let multiplier = Double(Int.random(min: 100 - variation, max: 100 + variation)) / 100
        let randomized = Double(self) * multiplier
        return Int(randomized) + 1
    }
}

private extension UInt {
    static func random(min: UInt, max: UInt) -> UInt {
        precondition(min <= max, "attempt to call random() with min > max")

        if min == UInt.min && max == UInt.max {
            var result: UInt = 0
            arc4random_buf(&result, MemoryLayout.size(ofValue: result))
            return result
        } else {
            let range = max - min + 1
            let limit = UInt.max - UInt.max % range
            var result: UInt = 0
            repeat {
                arc4random_buf(&result, MemoryLayout.size(ofValue: result))
            } while result >= limit
            result = result % range
            return min + result
        }
    }
}
