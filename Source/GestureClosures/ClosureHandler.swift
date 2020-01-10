//
//  ClosureHandler.swift
//  ElegantUI
//
//  Created by John on 2019/3/15.
//  Copyright © 2019 ElegantUI. All rights reserved.
//

import Foundation

internal let ClosureHandlerSelector = #selector(ClosureHandler<AnyObject>.handle)

internal class ClosureHandler<T: AnyObject>: NSObject {

    internal var handler: ((T) -> Void)?
    internal weak var control: T?

    internal init(handler: @escaping (T) -> Void, control: T? = nil) {
        self.handler = handler
        self.control = control
    }

    @objc func handle() {
        if let control = self.control {
            handler?(control)
        }
    }
}
