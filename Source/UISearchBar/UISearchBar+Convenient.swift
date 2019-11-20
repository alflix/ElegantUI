//
//  UISearchBar+Convenient.swift
//  GGUI
//
//  Created by John on 2019/5/17.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

/// UISearchBar 的快速设置
public extension UISearchBar {
    /// 输入框, iOS 13.0 直接调用 searchTextField，
    /// iOS 13.0 以下递归其 UISearchBarTextField，且该属性在 UISearchBar 被 addSubView 之后才会存在
    var searchField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        }
        return recursiveFindSubview(of: "UISearchBarTextField") as? UITextField
    }

    /// 🔍
    var icon: UIImageView? {
        return searchField?.leftView as? UIImageView
    }

    /// 🔍 和 占位文字 Label 和之间的间距的总宽度
    var placeholderWidth: CGFloat {
        let space = searchTextPositionAdjustment.horizontal
        if let font = searchField?.font, let icon = icon {
            let placeholderLabelWidth = placeholder?.widthForLabel(font: font, height: 32) ?? 0
            return placeholderLabelWidth + icon.bounds.width + space
        }
        return space
    }

    /// 🔍 颜色
    var iconColor: UIColor? {
        get {
            return icon?.tintColor
        }
        set {
            icon?.image = icon?.image?.withRenderingMode(.alwaysTemplate)
            icon?.tintColor = newValue
        }
    }

    /// UISearchBar在ios11上的placeHolder和icon默认居左, 可以通过这个方法使之居中
    ///
    /// - Parameter serchBarWidth: 通过计算得出的 serchBar width
    func setPositionAtCenter(serchBarWidth: CGFloat) {
        if #available(iOS 11.0, *) {
            let originalIconX: CGFloat = 14.0
            let offset = (serchBarWidth - placeholderWidth)/2 - originalIconX
            setPositionAdjustment(UIOffset(horizontal: offset, vertical: 0), for: .search)
        }
    }

    /// 使placeHolder和icon的位置恢复
    func setPositionAtLeft() {
        setPositionAdjustment(.zero, for: .search)
    }
}
