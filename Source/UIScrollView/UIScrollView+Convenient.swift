//
//  UIScrollView+Convenient.swift
//  GGUI
//
//  Created by John on 2019/7/19.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UIScrollView {
    var autualContentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }

    func reloadDataAnyway() {
        if let self = self as? UITableView {
            self.reloadData()
        }
        if let self = self as? UICollectionView {
            self.reloadData()
        }
    }

    /// 滑动到底部
    ///
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - excludeHeight: 用于排除计算的高度，例如键盘弹起时的键盘高度
    func scrollToBottom(animated: Bool = true, excludeHeight: CGFloat = 0) {
        let originOffsetY = contentSize.height - bounds.size.height - (contentInset.top + contentInset.bottom) + excludeHeight
        let offsetY = max(-autualContentInset.top, originOffsetY)
        let bottomOffset = CGPoint(x: 0, y: offsetY)
        setContentOffset(bottomOffset, animated: animated)
    }

    /// 滑动到顶部
    ///
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - excludeHeight: 用于排除计算的高度，
    func scrollToTop(animated: Bool = true, excludeHeight: CGFloat = 0) {
        let adjustOffsetY = CGPoint(x: 0, y: 0 + excludeHeight)
        setContentOffset(adjustOffsetY, animated: animated)
    }
}
