//
//  UINavigationController+.swift
//  Awesome
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 NleFlix. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        UINavigationController.swizzle()
        super.viewDidLoad()
    }

    static func swizzle() {
        DispatchQueue.once() {
            let needSwizzleSelectors = [
                NSSelectorFromString("_updateInteractiveTransition:"),
                #selector(pushViewController(_:animated:)),
                #selector(popToViewController),
                #selector(popToRootViewController)
            ]
            for selector in needSwizzleSelectors {
                let swizzleSelectorString = ("swizzle_" + selector.description).replacingOccurrences(of: "__", with: "_")
                swizzling(
                    UINavigationController.self,
                    selector,
                    Selector(swizzleSelectorString))
            }
        }
    }

    @objc func swizzle_updateInteractiveTransition(_ percentComplete: CGFloat) {
        guard let topVC = topViewController, let coordinator = topVC.transitionCoordinator else {
            swizzle_updateInteractiveTransition(percentComplete)
            return
        }
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(from: fromVC, to: toVC, progress: percentComplete)
        swizzle_updateInteractiveTransition(percentComplete)
    }

    @objc func swizzle_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        return popTransaction() {
            swizzle_popToViewController(viewController, animated: animated)
        }
    }

    @objc func swizzle_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        return popTransaction() {
            swizzle_popToRootViewControllerAnimated(animated)
        }
    }

    // swizzling system method: pushViewController
    @objc func swizzle_pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushTransaction {
            swizzle_pushViewController(viewController, animated: animated)
        }
    }

    struct AnimationProperties {
        static let duration = 0.13
        static var displayCount = 0
        static var progress: CGFloat {
            let all: CGFloat = CGFloat(60.0 * duration)
            let current = min(all, CGFloat(displayCount))
            return current / all
        }
    }

    func pushTransaction(block: () -> Void) {
        var displayLink: CADisplayLink? = CADisplayLink(target: self, selector: #selector(animationDisplay))
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            AnimationProperties.displayCount = 0
        }
        CATransaction.setAnimationDuration(AnimationProperties.duration)
        CATransaction.begin()
        block()
        CATransaction.commit()
    }

    func popTransaction(block: () -> [UIViewController]?) -> [UIViewController]? {
        var displayLink: CADisplayLink? = CADisplayLink(target: self, selector: #selector(animationDisplay))
        // UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            AnimationProperties.displayCount = 0
        }
        CATransaction.setAnimationDuration(AnimationProperties.duration)
        CATransaction.begin()
        let viewControllers = block()
        CATransaction.commit()
        return viewControllers
    }

    @objc func animationDisplay() {
        guard let topVC = topViewController, let coordinator = topVC.transitionCoordinator else { return }
        AnimationProperties.displayCount += 1
        let progress = AnimationProperties.progress
        DPrint("第\(AnimationProperties.displayCount)次pop的进度：\(progress)")
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(from: fromVC, to: toVC, progress: progress)
    }
}

// MARK: - UI Update
extension UINavigationController {
    func updateNavigationBar(from fromVC: UIViewController?, to toVC: UIViewController?, progress: CGFloat) {
        guard let fromVC = fromVC, let toVC = toVC else { return }

        // change tintColor
        let fromColor = fromVC.navigationAppearance.tintColor
        let toColor = toVC.navigationAppearance.tintColor
        let newColor = UIColor.averageColor(from: fromColor, to: toColor, percent: progress)
        navigationBar.tintColor = newColor

        // change alpha
        let fromAlpha = fromVC.navigationAppearance.backgroundAlpha
        let toAlpha = toVC.navigationAppearance.backgroundAlpha
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * progress
        navigationBar.setBackground(alpha: newAlpha)
    }
}

// MARK: - UINavigationBarDelegate
extension UINavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let topVC = topViewController, let coordinator = topVC.transitionCoordinator, coordinator.initiallyInteractive {
            if #available(iOS 10.0, *) {
                coordinator.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                })
            } else {
                coordinator.notifyWhenInteractionEnds({ (context) in
                    self.dealInteractionChanges(context)
                })
            }
            return true
        }

        let itemCount = navigationBar.items?.count ?? 0
        let count = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - count]
        popToViewController(popToVC, animated: true)
        return true
    }

    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        let animations: (UITransitionContextViewControllerKey) -> Void = {
            guard let viewController = context.viewController(forKey: $0) else { return }
            let curAlpha = viewController.navigationAppearance.backgroundAlpha
            let curTintColor = viewController.navigationAppearance.tintColor
            self.navigationBar.setBackground(alpha: curAlpha)
            self.navigationBar.tintColor = curTintColor
        }
        // 完成返回手势的取消事件
        if context.isCancelled {
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        } else {
            // 完成返回手势的完成事件
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
}
