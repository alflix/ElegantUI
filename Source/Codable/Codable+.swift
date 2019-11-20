//
//  Codable+.swift
//  GGUI
//
//  Created by John on 2019/7/4.
//  Copyright © 2019 Ganguo. All rights reserved.
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

public extension Decodable {
    /// Decodable 的封装初始化方法
    ///
    /// - Parameters:
    ///   - from: json
    ///   - dateFormat: 日期格式，可在 GGUI.Config.Codable.dateDecodingStrategy 中设置
    /// - Throws: 解析错误
    init(from: Any, dateFormat: String? = nil) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let dateFormat = GGUI.Config.Codable.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        } else {
            decoder.dateDecodingStrategy = GGUI.Config.Codable.dateDecodingStrategy
        }
        do {
            self = try decoder.decode(Self.self, from: data)
        } catch let error {
            DPrint(error.localizedDescription)
            throw error
        }
    }
}

public extension Encodable {
    /// Model->Dictionary（keyEncodingStrategy = .convertToSnakeCase ）
    ///
    /// - Returns: Dictionary
    /// - Throws: 转换错误
    func asDictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        if let dateFormat = GGUI.Config.Codable.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        } else {
            encoder.dateEncodingStrategy = GGUI.Config.Codable.dateEncodingStrategy
        }
        let data = try encoder.encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    /// Model->JSONString（keyEncodingStrategy = .convertToSnakeCase ）
    ///
    /// - Returns: String
    /// - Throws: 转换错误
    func asJSONString(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) throws -> String? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        if let dateFormat = GGUI.Config.Codable.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        } else {
            encoder.dateEncodingStrategy = GGUI.Config.Codable.dateEncodingStrategy
        }
        let data = try encoder.encode(self)
        guard let str = String(data: data, encoding: .utf8) else {
            throw NSError()
        }
        return str
    }
}
