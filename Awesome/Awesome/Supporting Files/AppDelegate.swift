//
//  AppDelegate.swift
//  Awesome
//
//  Created by John on 2019/3/7.
//  Copyright © 2019 jieyuanz. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let keyWindow = window else { return false }
        keyWindow.backgroundColor = .white
        keyWindow.rootViewController = NavigationController(rootViewController: HomeViewController.instantiate())
        keyWindow.makeKeyAndVisible()
        return true
    }
}


