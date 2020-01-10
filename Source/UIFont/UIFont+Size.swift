//
//  UIFont+Size.swift
//  ElegantUI
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import UIKit

public extension UIFont {
    var fontWeight: UIFont.Weight {
        let fontAttributeKey = UIFontDescriptor.AttributeName.init(rawValue: "NSCTFontUIUsageAttribute")
        if let fontWeight = self.fontDescriptor.fontAttributes[fontAttributeKey] as? String {
            switch fontWeight {
            case "CTFontBoldUsage":
                return .bold
            case "CTFontBlackUsage":
                return .black
            case "CTFontHeavyUsage":
                return .heavy
            case "CTFontUltraLightUsage":
                return .ultraLight
            case "CTFontThinUsage":
                return .thin
            case "CTFontLightUsage":
                return .light
            case "CTFontMediumUsage":
                return .medium
            case "CTFontDemiUsage":
                return .semibold
            case "CTFontRegularUsage":
                return .regular
            default:
                return .regular
            }
        }
        return .regular
    }
}
