# Tabbar

本文主要基于 UITabBarController/UITabBar 讲述一些常用的接口用法，在此基础上会实现一些常见的自定义 UI 。本文的代码示例 [地址](https://github.com/YodaLuke/awesome-ios/tree/master/Awesome/Awesome/App/Tabbar)

## 概述

### UITabBarController

UITabBarController，和 [UINavigationController](https://github.com/YodaLuke/awesome-ios/blob/master/UIKit/UINavigation/UINavigation.md#%E6%A6%82%E8%BF%B0) 一样是容器类（Container），利用集合的方式对 ViewController 进行管理。大部分情况下，UITabBarController 通常作为 app 的 rootViewController：

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

作为容器类，UITabBarController 通常都是配合 UINavigationController 一起使用，因此存在两种比较常见的层级处理方式:

第一种：

```swift
├── UINavigationController
└──── UITabBarController
└────── UIViewController
└──────── SubviewControllers
```

所以上面的改为：

```swift
keyWindow.rootViewController = UINavigationController(rootViewController: TabBarController())
```

第二种：

```swift
├── UITabBarController
└──── UINavigationController
└────── UIViewController
└──────── SubviewControllers
```

需要注意的是，第一种情况，UINavigationBar 的 title 将由 UITabBarController 管理，对 UIViewController 设置 self.title 将不起作用。

而第二种情况在 viewController push 子视图的时候需要设置  hidesBottomBarWhenPushed = true , 第一种则不需要。

个人倾向于使用第二种方式。

基于容器类的思想，UITabBarController 通过 ViewController 的拓展添加了 tabBarController，使其暴露出 tabBarController 属性 交由 ViewController 管理。

```swift
extension UIViewController {
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

UITabBar，是 UITabBarController 顶部的导航栏，主要负责 UI 的展示。UITabBar 有以下常见的设置：

```swift
func setupUI() {
    // 背景颜色, 会覆盖掉 barStyle 属性
    tabBar.barTintColor = .white
    // 控件选中状态下的着色
    tabBar.tintColor = .black
    // 是否毛玻璃效果
    tabBar.isTranslucent = true
}
```

其他一些不常见的设置：

```swift
func setupAdditionUI() {
    // 样式，在没有设置 barTintColor 的时候起作用，比较少用
    tabBar.barStyle = .black
    // 背景图片，注意图片是平铺的，需要处理好图片再进行设置或设置 clipsToBounds = true（会覆盖掉 barStyle,isTranslucent 属性）
    tabBar.backgroundImage = UIImage(named: "trello")
    // item 选中之后会额外显示的图片，很奇怪的接口，一般不用
    tabBar.selectionIndicatorImage = UIImage(named: "icon_back")
    // item 的布局方式，一般默认即可
    tabBar.itemPositioning = .centered
    // item 的宽度（itemPositioning = .centered 时有效）
    tabBar.itemWidth = 44
    // item 的间距（itemPositioning = .centered 时有效）
    tabBar.itemSpacing = 88
}
```

移除顶部的分割线可以使用：

```swift
func removeShadowLine() {
    tabBar.backgroundImage = UIImage()
    tabBar.shadowImage = UIImage()
}
```

### UITabBarItem

UITabBar 包含 UITabBarItem ，同样通过 ViewController 的拓展添加了 tabBarItem。

```swift
open class UINavigationController : UIViewController {
    open var tabBarItem: UITabBarItem!
}
```

UITabBarItem 是一个抽象类，继承至 UIBarItem-NSObject，