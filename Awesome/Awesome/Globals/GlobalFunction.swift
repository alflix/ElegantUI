//
//  GlobalFunction.swift
//  Awesome
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit
import Reusable

func DPrint<N>(_ message: N, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("😋 \(fileName):\(line) \(function) | \(message)")
    #endif
}

func associatedObject<ValueType: Any>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
        if let associated = objc_getAssociatedObject(base, key) as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObject<ValueType: Any>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

/// 封装 swizzed 方法
let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

typealias CollectionViewDelegate = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
typealias TableViewDelegate = UITableViewDataSource & UITableViewDelegate
typealias StoryboardController = UIViewController & StoryboardBased
