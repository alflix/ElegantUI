//  typealias, 自由函数
//  GGUI
//
//  Created by John on 2018/9/10.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
    return value.assumingMemoryBound(to: T.self).pointee
}

public func globalThreadAsync(execute work: @escaping () -> Void) {
    if !Thread.isMainThread {
        work()
    } else {
        DispatchQueue.global().async(execute: work)
    }
}

/// 封装 swizzed 方法
public let swizzling: (AnyClass, Selector, Selector) -> Void = { forClass, originalSelector, swizzledSelector in
    guard
        let originalMethod = class_getInstanceMethod(forClass, originalSelector),
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

/// Block
public typealias VoidBlock = () -> Void
public typealias StringBlock = (_ text: String) -> Void
public typealias StringTapBlock = (_ text: String, _ range: NSRange) -> Void
public typealias BoolBlock = (_ boolen: Bool) -> Void
public typealias IndexBlock = (_ index: Int) -> Void
public typealias IndexPathBlock = (_ indexpath: IndexPath) -> Void
public typealias ResponseBlock = (_ success: Bool, _ errorMessage: String?) -> Void
public typealias AttributedStringBlock = (_ attributedString: NSMutableAttributedString) -> Void

/// Delegate
public typealias CollectionViewDelegate = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
public typealias TableViewDelegate = UITableViewDataSource & UITableViewDelegate

public func DPrint<N>(_ message: N, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("😋 \(fileName):\(line) \(function) | \(message)")
    #endif
}

final public class ClosureDecorator<T>: NSObject {
    fileprivate let closure: Any

    fileprivate override init() {
        fatalError("Use init(action:) instead.")
    }

    public init(_ closure: @escaping (() -> Void)) {
        self.closure = closure
    }

    public init(_ closure: @escaping ((T) -> Void)) {
        self.closure = closure
    }

    public func invoke(_ param: T) {
        if let closure = closure as? (() -> Void) {
            closure()
        } else if let closure = closure as? ((T) -> Void) {
            closure(param)
        }
    }

    deinit {
        DPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
}
