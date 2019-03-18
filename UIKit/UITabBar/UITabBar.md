# Tabbar

本文前半部分主要讲述 UITabBarController/UITabBar 一些常用的接口用法，然后会实现一些常见的自定义 UI 。本文的代码示例 [地址](https://github.com/YodaLuke/awesome-ios/tree/master/Awesome/Awesome/App/Tabbar)

## 概述

UITabBarController，和 UINavigationController 一样是一个容器类，对 ViewController 进行管理（利用栈的方式）。大部分情况下，UITabBarController 通常作为 app 的 rootViewController：



```swift
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let keyWindow = window else { return false }
        keyWindow.backgroundColor = .white
        keyWindow.rootViewController = TabBarController()
        keyWindow.makeKeyAndVisible()
    }
}
```

UITabBar，是 UITabBarController 顶部的导航栏，主要负责 UI 的展示，并对 navigationItem 进行管理。

```swift
open class UINavigationController : UIViewController {
    open var navigationBar: UINavigationBar { get }
}
```
