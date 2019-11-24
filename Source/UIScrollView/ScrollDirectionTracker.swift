//
//  ScrollDirectionTracker.swift
//  GGUI
//
//  Created by John on 2019/7/19.
//  Copyright © 2019 GGUI. All rights reserved.
//

import UIKit

/// 滑动方向
///
/// - none: 初始值
/// - down: 往下
/// - up: 往上
public enum ScrollingDirection: String {
    case none
    case down
    case up
}

public typealias ScrollingDirectionBlock = (_ scrollingDirection: ScrollingDirection, _ contentOffsetY: CGFloat) -> Void

/// 监听 UIScrollView 的滑动方向
public class ScrollDirectionTracker: NSObject {
    static public let shared = ScrollDirectionTracker()

    weak var scrollView: UIScrollView?
    var lastContentOffsetY: CGFloat = 0
    var scrollingDirectionBlock: ScrollingDirectionBlock?

    deinit {
        scrollingDirectionBlock = nil
    }

    /// 通过添加手势的方式监听滑动方向
    ///
    /// - Parameter handler: 回调
    public func addObserve(_ scrollView: UIScrollView, handler: @escaping (ScrollingDirectionBlock)) {
        self.scrollView = scrollView
        scrollingDirectionBlock = handler
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panGesture.delegate = self
        panGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(panGesture)
    }

    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        guard let scrollView = scrollView, gesture.view == scrollView else { return }
        let contentOffsetY = scrollView.contentOffset.y
        if gesture.state == .began {
            lastContentOffsetY = contentOffsetY
            return
        }
        let deltaY = contentOffsetY - lastContentOffsetY

        if deltaY > 0 {
            scrollingDirectionBlock?(.down, contentOffsetY)
        } else if deltaY < 0 {
            scrollingDirectionBlock?(.up, contentOffsetY)
        }
        lastContentOffsetY = contentOffsetY
    }
}

extension ScrollDirectionTracker: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
