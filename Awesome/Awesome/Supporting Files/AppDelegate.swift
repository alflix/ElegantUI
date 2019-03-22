//
//  AppDelegate.swift
//  Awesome
//
//  Created by John on 2019/3/7.
//  Copyright © 2019 alflix. All rights reserved.
//

import UIKit
import FLEX
import ActionKit

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
        let tap = UITapGestureRecognizer { (tap) in
            guard tap.state == .recognized else { return }
            FLEXManager.shared().showExplorer()
        }
        tap.numberOfTouchesRequired = 2
        window?.addGestureRecognizer(tap)
    }
}
