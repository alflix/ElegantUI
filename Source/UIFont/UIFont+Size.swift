//
//  UIFont+Size.swift
//  GGUI
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UIFont {
    var fontWeight: UIFont.Weight {
        let fontAttributeKey = UIFontDescriptor.AttributeName.init(rawValue: "NSCTFontUIUsageAttribute")
        if let fontWeight = self.fontDescriptor.fontAttributes[fontAttributeKey] as? String {
            switch fontWeight {
            case "CTFontBoldUsage":
                return UIFont.Weight.bold
            case "CTFontBlackUsage":
                return UIFont.Weight.black
            case "CTFontHeavyUsage":
                return UIFont.Weight.heavy
            case "CTFontUltraLightUsage":
                return UIFont.Weight.ultraLight
            case "CTFontThinUsage":
                return UIFont.Weight.thin
            case "CTFontLightUsage":
                return UIFont.Weight.light
            case "CTFontMediumUsage":
                return UIFont.Weight.medium
            case "CTFontDemiUsage":
                return UIFont.Weight.semibold
            case "CTFontRegularUsage":
                return UIFont.Weight.regular
            default:
                return UIFont.Weight.regular
            }
        }
        return UIFont.Weight.regular
    }
}
