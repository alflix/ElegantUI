//
//  Decodable+Convenient.swift
//  ElegantUI
//
//  Created by John on 2019/7/4.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation

public extension Decodable {
    /// Decodable 的封装初始化方法
    ///
    /// - Parameters:
    ///   - from: json
    ///   - dateFormat: 日期格式，可在 ElegantUI.Config.Codable.dateDecodingStrategy 中设置
    /// - Throws: 解析错误
    init(from: Any, dateFormat: String? = nil) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let dateFormat = Config.Codable.dateFormat {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        } else {
            decoder.dateDecodingStrategy = Config.Codable.dateDecodingStrategy
        }
        do {
            self = try decoder.decode(Self.self, from: data)
        } catch let error {
            DPrint(error.localizedDescription)
            throw error
        }
    }
}
