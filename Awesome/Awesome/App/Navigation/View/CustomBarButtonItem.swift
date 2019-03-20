//
//  CustomBarButtonItem.swift
//  Awesome
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 NleFlix. All rights reserved.
//

import UIKit

/// 封装通过 customView 的方式创建 UIBarButtonItem
final class CustomBarButtonItem: UIBarButtonItem {
    lazy var button = UIButton()

    init(image: UIImage?, title: String?) {
        super.init()
        setButton(image: image, title: title)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setButton(image: UIImage?, title: String? = nil) {
        if let image = image {
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        button.setTitle(title, for: .normal)
        button.tintColor = tintColor
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: -3, bottom: 3, right: 10)
        button.imageView?.contentMode = .scaleAspectFill
        button.sizeToFit()
        customView = button
    }
}
