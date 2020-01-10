//
//  UIBarButtonItem+Convenient.swift
//  ElegantUI
//
//  Created by John on 2018/11/22.
//  Copyright © 2018 ElegantUI. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    convenience init(image: UIImage,
                     selectImage: UIImage? = nil,
                     contentEdgeInsets: UIEdgeInsets = .zero,
                     actionBlock: VoidBlock? = nil) {
        self.init()
        let barButton = UIButton()
        barButton.setImage(image, for: .normal)
        if let selectImage = selectImage {
            barButton.setImage(selectImage, for: .selected)
        }
        barButton.onTap { (_) in
            actionBlock?()
        }
        barButton.contentEdgeInsets = contentEdgeInsets
        barButton.sizeToFit()
        customView = barButton
    }

    convenience init(title: String,
                     color: UIColor,
                     backgroundColor: UIColor? = nil,
                     font: UIFont,
                     contentEdgeInsets: UIEdgeInsets = .zero,
                     actionBlock: VoidBlock? = nil) {
        self.init()
        let barButton = UIButton()
        barButton.titleLabel?.font = font
        barButton.setTitleColor(color, for: .normal)
        barButton.setTitle(title, for: .normal)
        barButton.onTap { (_) in
            actionBlock?()
        }
        barButton.backgroundColor =  backgroundColor
        barButton.contentEdgeInsets = contentEdgeInsets
        barButton.sizeToFit()
        self.customView = barButton
    }

    convenience init(title: String,
                     image: UIImage,
                     direction: TitleImageDirection = .left,
                     space: CGFloat,
                     color: UIColor,
                     backgroundColor: UIColor? = nil,
                     font: UIFont,
                     contentEdgeInsets: UIEdgeInsets = .zero,
                     actionBlock: VoidBlock? = nil) {
        self.init()
        let barButton = LayoutButton()
        barButton.titleLabel?.font = font
        barButton.setTitleColor(color, for: .normal)
        barButton.setTitle(title, for: .normal)
        barButton.setImage(image, for: .normal)
        barButton.imageDirection = direction
        barButton.imageTitleSpace = space
        barButton.backgroundColor =  backgroundColor
        barButton.onTap { (_) in
            actionBlock?()
        }
        barButton.contentEdgeInsets = contentEdgeInsets
        barButton.sizeToFit()
        self.customView = barButton
    }
}
