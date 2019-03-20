# Tabbar

本文主要基于 UITabBarController/UITabBar 讲述一些常用的接口用法，在此基础上会实现一些常见的自定义 UI 。本文的代码示例 [地址](https://github.com/alflix/awesome-ios/tree/master/Awesome/Awesome/App/Tabbar)

## 概述

### UITabBarController

UITabBarController，和 [UINavigationController](https://github.com/alflix/awesome-ios/blob/master/UIKit/UINavigation/UINavigation.md#%E6%A6%82%E8%BF%B0) 一样是容器类（Container），利用集合的方式对 ViewController 进行管理。大部分情况下，UITabBarController 通常作为 app 的 rootViewController：

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
    // 拓展方法：移除顶部的分割线
    tabBar.removeShadowLine()
    // 拓展方法：设置未选中状态的控件颜色
    tabBar.unselectedTintColor = .gray
}
```

其中 unselectedTintColor 是拓展的属性，因为 unselectedItemTintColor 只支持 iOS10 以上。( associatedObject 方法见[此处](https://github.com/alflix/awesome-ios/blob/master/UIKit/UINavigation/Navigation.md#%E6%96%B9%E6%A1%882))

removeShadowLine 实现如下，和 [navigationBar 移除分割线](https://github.com/alflix/awesome-ios/blob/master/UIKit/UINavigation/Navigation.md#%E5%88%86%E5%89%B2%E7%BA%BF)很类似。

```swift
extension UITabBar {
    fileprivate struct AssociatedKey {
        static var unselectedTintColor: UInt8 = 0
    }

    /// 未选中状态的控件颜色
    open var unselectedTintColor: UIColor? {
        get {
            if #available(iOS 10.0, *) {
                return unselectedItemTintColor
            }
            return associatedObject(base: self, key: &AssociatedKey.unselectedTintColor) { return tintColor }
        }
        set {
            if #available(iOS 10.0, *) {
                unselectedItemTintColor = unselectedTintColor
            }
            associateObject(base: self, key: &AssociatedKey.unselectedTintColor, value: newValue)
        }
    }

    /// 移除顶部的分割线
    open func removeShadowLine() {
        backgroundImage = UIImage()
        shadowImage = UIImage()
    }
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

### UITabBarItem

UITabBar 包含 UITabBarItem ，同样通过 ViewController 的拓展添加了 tabBarItem。

```swift
open class UINavigationController : UIViewController {
    open var tabBarItem: UITabBarItem!
}
```

UITabBarItem 是一个抽象类，继承至 UIBarItem-NSObject，可以设置 title，image，selectedImage 等元素。而设置这些元素一般在设置子控制器的过程中。我们下面通过一个方法封装来处理这个过程：

```swift
public extension UITabBarController {
    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - controller: 子控制器
    ///   - imageName: 图标, 选中/未选中图标根据 tintColor/unselectedTintColor 而定
    ///   - title: 文字
    public func add(child controller: UIViewController, imageName: String, title: String? = nil) {
        add(child: controller, imageName: imageName, selectImageName: nil,
            title: title, navigationClass: UINavigationController.self)
    }

    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - controller: 子控制器
    ///   - imageName: 图标
    ///   - selectImageName: 选中的图标
    ///     - 不为空时，imageName 对应未选中的图标，selectImageName 对应选中的图标
    ///     - 为空时，选中/未选中图标根据 imageName 以及 tintColor/unselectedTintColor 而定
    ///   - title: 文字
    ///   - name: 可传入继承自 UINavigationController 的 class
    ///   - handler: 暴露出 UITabBarItem，可以设置额外的属性
    public func add<T: UINavigationController>(child controller: UIViewController,
                                               imageName: String,
                                               selectImageName: String? = nil,
                                               title: String? = nil,
                                               navigationClass name: T.Type,
                                               tabBarItemUpdate: ((UITabBarItem) -> Void)? = nil) {
        guard let image = UIImage(named: imageName) else {
            fatalError("cant find image by imageName!")
        }
        let tabBarItem = UITabBarItem(title: title)
        if let selectImageName = selectImageName {
            guard let selectedImage = UIImage(named: selectImageName) else {
                fatalError("cant find image by selectImageName!")
            }
            // 显示原图
            tabBarItem.image = image.withRenderingMode(.alwaysOriginal)
            tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        } else {
            if #available(iOS 10.0, *) {
                tabBarItem.image = image
            } else {
                let unselectedTintColor: UIColor! = tabBar.unselectedTintColor ?? tabBar.tintColor
                // 未选中状态下的图片
                let unselectImage = image.tint(unselectedTintColor, blendMode: .destinationIn)
                tabBarItem.image = unselectImage
                // 选中状态下的图片
                let selectImage = image.withRenderingMode(.alwaysTemplate)
                tabBarItem.selectedImage = selectImage

                // 未选中状态下的文字属性, 这个属性会使得 self.tabBar.tintColor 对文字的设置不再生效，所以需要重新设置选中状态下的文字属性
                let textAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: unselectedTintColor]
                tabBarItem.setTitleTextAttributes(textAttrs, for: .normal)
                // 选中状态下的文字属性
                let selectedTextAttrs: [NSAttributedString.Key: Any] = [.foregroundColor: tabBar.tintColor]
                tabBarItem.setTitleTextAttributes(selectedTextAttrs, for: .selected)
            }
        }
        controller.tabBarItem = tabBarItem
        tabBarItemUpdate?(tabBarItem)
        let navigationController = T(rootViewController: controller)
        addChild(navigationController)
    }
}
```

基本思想是我们需要定义一个基本的设置方法，其中只需要传入子控制器、tabbar显示的图片、文字，这个方法帮我们处理好选中/未选中图片、文字的颜色问题（iOS 10 以下需要手动设置所有属性）。

同时，定义一个支持更多属性的方法