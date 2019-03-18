# Tabbar

本文前半部分主要讲述 UITabBarController/UITabBar 一些常用的接口用法，然后会实现一些常见的自定义 UI 。本文的代码示例 [地址](https://github.com/YodaLuke/awesome-ios/tree/master/Awesome/Awesome/App/Tabbar)

## 概述

### UITabBarController

UITabBarController，和 UINavigationController 一样是一个容器类，[参见](https://github.com/YodaLuke/awesome-ios/blob/master/UIKit/Navigation/Navigation.md#%E6%A6%82%E8%BF%B0)，对 ViewController 进行管理（利用集合的方式）。大部分情况下，UITabBarController 通常作为 app 的 rootViewController：

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

作为容器类，UITabBarController 通常都是配合 UINavigationController 一起使用：

第一种：

```swift
UINavigationController
	UITabBarController
		UIViewController
```

```swift
keyWindow.rootViewController = UINavigationController(rootViewController: TabBarController())
```

第二种：

```swift
UITabBarController
	UINavigationController
		UIViewController
```

第一种情况比较少见，而且这种情况下，UINavigationBar 的title 将由 UITabBarController 管理，对 UIViewController 设置 self.title 将不起作用。

基于容器类的思路，UITabBarController 通过 ViewController 的拓展添加了 tabBarController  和 navigationItem，把 UITabBarItem 交由 ViewController 管理。

```swift
extension UIViewController {
  	open var tabBarItem: UITabBarItem!
    open var tabBarController: UITabBarController? { get }
}
```

### 关于 self.title

设置一个 ViewController 的标题时，我们通常这样：

```swift
title = "title"
```

或：

```swift
navigationItem.title = "title"
```

然而，这两种方式有什么区别？为什么有时候不设置 tabBarItem.title，tabBarItem 也会显示一个 title 呢？

关于在一个 ViewController 中设置相关标题简单总结如下：

- self.navigationItem.title: 设置 ViewController 顶部导航栏的标题

- self.tabBarItem.title: 设置 ViewController 底部标签栏的标题

- self.title: 同时修改上述两处的标题

### UITabBar

UITabBar，是 UITabBarController 顶部的导航栏，主要负责 UI 的展示，并对 navigationItem 进行管理。

```swift
open class UINavigationController : UIViewController {
    open var navigationBar: UINavigationBar { get }
}
```
