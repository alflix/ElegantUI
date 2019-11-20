//
//  UIBarButtonItem+Extension.swift
//  Matters
//
//  Created by John on 2018/11/22.
//  Copyright © 2018 Ganguo. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    convenience init(image: UIImage, target: AnyObject, action: Selector) {
        self.init(image: image, selectImage: nil, target: target, action: action)
    }

    convenience init(image: UIImage,
                     selectImage: UIImage? = nil,
                     contentEdgeInsets: UIEdgeInsets = .zero,
                     target: AnyObject,
                     action: Selector) {
        self.init()
        let barButton = UIButton()
        barButton.setImage(image, for: .normal)
        if let selectImage = selectImage {
            barButton.setImage(selectImage, for: .selected)
        }
        barButton.addTarget(target, action: action, for: .touchUpInside)
        barButton.contentEdgeInsets = contentEdgeInsets
        barButton.sizeToFit()
        customView = barButton
    }

    convenience init(title: String,
                     color: UIColor,
                     font: UIFont,
                     contentEdgeInsets: UIEdgeInsets = .zero,
                     target: AnyObject, action: Selector) {
        self.init()
        let barButton = UIButton()
        barButton.titleLabel?.font = font
        barButton.setTitleColor(color, for: .normal)
        barButton.setTitle(title, for: .normal)
        barButton.addTarget(target, action: action, for: .touchUpInside)
        barButton.contentEdgeInsets = contentEdgeInsets
        barButton.sizeToFit()
        self.customView = barButton
    }
}
