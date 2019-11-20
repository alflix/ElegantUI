//
//  String+Attributed.swift
//  GGUI
//
//  Created by John on 2019/3/27.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

// MARK: - String 的一些工具类
public extension String {
    /// 从 URL String中截取出参数
    /// 
    /// 🌰：http://example.com?param1=value1&param2=value2 -> Optional([“param1”: value1, “param2”: value2])
    var urlParameters: [String: AnyObject]? {
        // 截取是否有参数
        guard let urlComponents = NSURLComponents(string: self), let queryItems = urlComponents.queryItems else { return nil }
        // 参数字典
        var parameters = [String: AnyObject]()
        // 遍历参数
        queryItems.forEach({ (item) in
            // 判断参数是否是数组
            if let existValue = parameters[item.name], let value = item.value {
                // 已存在的值，生成数组
                if var existValue = existValue as? [AnyObject] {
                    existValue.append(value as AnyObject)
                } else {
                    parameters[item.name] = [existValue, value] as AnyObject
                }
            } else {
                parameters[item.name] = item.value as AnyObject
            }
        })
        return parameters
    }

    /// json string 转换为 [String: Any]
    func json() -> [String: Any]? {
        let strData = self.data(using: .utf8) ?? Data()
        let dict = try? JSONSerialization.jsonObject(with: strData, options: []) as? [String: Any]
        return dict
    }
}
