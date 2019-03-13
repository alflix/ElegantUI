//
//  UIView+Addition.swift
//  Awesome
//
//  Created by John on 2019/3/11.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit

extension UIView {
    
    func logSubView(_ level: Int) {
        if subviews.isEmpty { return }
        for subView in subviews {
            var blank = ""
            for _ in 1..<level {
                blank += " "
            }
            if let className = object_getClass(subView) {
                print( blank + "\(level): " + "\(className)" + "\(subView.frame)")
            }
            subView.logSubView(level + 1)
        }
    }
}
