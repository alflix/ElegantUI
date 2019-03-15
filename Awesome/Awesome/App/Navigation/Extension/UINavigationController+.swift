//
//  UINavigationController+.swift
//  Awesome
//
//  Created by John on 2019/3/14.
//  Copyright © 2019 jieyuanz. All rights reserved.
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
        guard let topViewController = topViewController, let coordinator = topViewController.transitionCoordinator else {
            swizzle_updateInteractiveTransition(percentComplete)
            return
        }

        let fromViewController = coordinator.viewController(forKey: .from)
        let toViewController = coordinator.viewController(forKey: .to)

        // Alpha
        let fromAlpha = fromViewController?.navigationAppearance.backgroundAlpha ?? 0
        let toAlpha = toViewController?.navigationAppearance.backgroundAlpha ?? 0
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete
        navigationBar.setBackground(alpha: newAlpha)

        // Tint Color
        let fromColor = fromViewController?.navigationAppearance.tintColor ?? .blue
        let toColor = toViewController?.navigationAppearance.tintColor ?? .blue
        let newColor = UIColor.averageColor(from: fromColor, to: toColor, percent: percentComplete)
        navigationBar.tintColor = newColor
        swizzle_updateInteractiveTransition(percentComplete)
    }

    @objc func swizzle_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        navigationBar.setBackground(alpha: viewController.navigationAppearance.backgroundAlpha)
        navigationBar.tintColor = viewController.navigationAppearance.tintColor
        return swizzle_popToViewController(viewController, animated: animated)
    }

    @objc func swizzle_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        navigationBar.setBackground(alpha: viewControllers.first?.navigationAppearance.backgroundAlpha ?? 0)
        navigationBar.tintColor = viewControllers.first?.navigationAppearance.tintColor
        return swizzle_popToRootViewControllerAnimated(animated)
    }
}

extension UINavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        navigationBar.setBackground(alpha: topViewController?.navigationAppearance.backgroundAlpha ?? 0)
        navigationBar.tintColor = topViewController?.navigationAppearance.tintColor
        return true
    }

    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if let topVC = topViewController, let coor = topVC.transitionCoordinator, coor.initiallyInteractive {
            if #available(iOS 10.0, *) {
                coor.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                })
            } else {
                coor.notifyWhenInteractionEnds({ (context) in
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
