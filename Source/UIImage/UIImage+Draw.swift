//
//  UIImage+Draw.swift
//  GGUI
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

public extension UIImage {
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
