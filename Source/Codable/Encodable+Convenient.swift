//
//  Encodable+Convenient.swift
//  ElegantUI
//
//  Created by John on 2019/7/4.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation

public extension Encodable {
    /// Model->Dictionary（keyEncodingStrategy = .convertToSnakeCase ）
    ///
    /// - Returns: Dictionary
    /// - Throws: 转换错误
    func asDictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) throws -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        if let dateFormat = Config.Codable.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        } else {
            encoder.dateEncodingStrategy = Config.Codable.dateEncodingStrategy
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
        if let dateFormat = Config.Codable.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        } else {
            encoder.dateEncodingStrategy = Config.Codable.dateEncodingStrategy
        }
        let data = try encoder.encode(self)
        guard let str = String(data: data, encoding: .utf8) else {
            throw NSError()
        }
        return str
    }
}
