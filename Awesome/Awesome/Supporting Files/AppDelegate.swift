//
//  AppDelegate.swift
//  Awesome
//
//  Created by John on 2019/3/7.
//  Copyright © 2019 NleFlix. All rights reserved.
//

import UIKit
import FLEX

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let keyWindow = window else { return false }
        keyWindow.backgroundColor = .white
        keyWindow.rootViewController = NavigationController(rootViewController: RootViewController.instantiate())
        keyWindow.makeKeyAndVisible()
        addFlexTapGesture()
        return true
    }

    private func addFlexTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapFlex))
        tap.numberOfTouchesRequired = 2
        window?.addGestureRecognizer(tap)
    }

    @objc private func didTapFlex(tap: UITapGestureRecognizer) {
        if tap.state == .recognized {
            FLEXManager.shared().showExplorer()
        }
    }
}
