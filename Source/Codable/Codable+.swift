//
//  Codable+Safe.swift
//  ElegantUI
//
//  Created by John on 2019/7/4.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/49695780/codable-enum-with-default-case-in-swift-4
public protocol IntCaseIterableDefaultsLast: Codable & CaseIterable & RawRepresentable
where Self.RawValue == Int, Self.AllCases: BidirectionalCollection { }

public protocol StringCaseIterableDefaultsLast: Codable & CaseIterable & RawRepresentable
where Self.RawValue == String, Self.AllCases: BidirectionalCollection { }

public extension IntCaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

public extension StringCaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}
