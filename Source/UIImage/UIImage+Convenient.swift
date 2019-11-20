//
//  UIImage+Convenient.swift
//  GGUI
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UIImage {
    var width: CGFloat {
        get {
            return size.width
        }
    }

    var height: CGFloat {
        get {
            return size.height
        }
    }

    /// 通过图片创建 NSTextAttachment
    ///
    /// - Parameters:
    ///   - xOffset: x 偏移量
    ///   - yOffset: y 偏移量
    ///   - width: 图片宽度，不设置的话为 image 自身宽度
    /// - Returns: NSTextAttachment
    func attachmentString(xOffset: CGFloat = 0, yOffset: CGFloat = 0, width: CGFloat = 0) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = self
        if width > 0 {
            imageAttachment.bounds = CGRect(x: xOffset, y: yOffset, width: width, height: width)
        } else {
            imageAttachment.bounds = CGRect(x: xOffset, y: yOffset,
                                            width: imageAttachment.image!.size.width,
                                            height: imageAttachment.image!.size.height)
        }
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }
}
