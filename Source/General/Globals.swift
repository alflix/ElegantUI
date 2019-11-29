//  typealias, 自由函数
//  GGUI
//
//  Created by John on 2018/9/10.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

/// Block typealias
public typealias VoidBlock = () -> Void
public typealias StringBlock = (_ text: String) -> Void
public typealias StringTapBlock = (_ text: String, _ range: NSRange) -> Void
public typealias BoolBlock = (_ boolen: Bool) -> Void
public typealias IndexBlock = (_ index: Int) -> Void
public typealias IndexPathBlock = (_ indexpath: IndexPath) -> Void
public typealias ResponseBlock = (_ success: Bool, _ errorMessage: String?) -> Void
public typealias AttributedStringBlock = (_ attributedString: NSMutableAttributedString) -> Void

/// Delegate typealias
public typealias CollectionViewDelegate = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
public typealias TableViewDelegate = UITableViewDataSource & UITableViewDelegate

public func DPrint<N>(_ message: N, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("😋 \(fileName):\(line) \(function) | \(message)")
    #endif
}
