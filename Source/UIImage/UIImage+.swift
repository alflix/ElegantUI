//
//  UIImage+.swift
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

    typealias KB = Int

    /// 对图片染色
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - blendMode: 渲染默认
    /// - Returns: 新的图片
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
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

    /// 传入 logo 图片，logo 位置 logo 大小 就可以得到一张生成好的图片 
    ///
    /// - Parameters:
    ///   - logo: 图片
    ///   - logoOrigin: 位置
    ///   - logoSize: 大小
    /// - Returns: 生成好的图片 
    func composeImageWithLogo(logo: UIImage,
                              logoOrigin: CGPoint) -> UIImage {
        //以bgImage的图大小为底图
        let imageRef = self.cgImage
        let width: CGFloat = CGFloat((imageRef?.width)!)
        let height: CGFloat = CGFloat((imageRef?.height)!)
        //以1.png的图大小为画布创建上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        //先把1.png 画到上下文中
        let logoWidth = logo.size.width * scale
        let logoHeight = logo.size.height * scale
        logo.draw(in: CGRect(x: logoOrigin.x * scale - logoWidth/2,
                             y: logoOrigin.y * scale - logoHeight/2,
                             width: logoWidth,
                             height: logoHeight))
        //再把小图放在上下文中
        let resultImg: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        //从当前上下文中获得最终图片
        UIGraphicsEndImageContext()
        return resultImg!
    }
}
