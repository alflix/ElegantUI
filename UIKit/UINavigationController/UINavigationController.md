### 概述

UINavigationController，是一个容器类（命名上，UIKit 中容器类一般以 Controller 后缀结束），对 ViewController 进行管理（利用栈的方式）。

```swift
open class UINavigationController : UIViewController {
    open var viewControllers: [UIViewController]
}
```

UINavigationBar，是 UINavigationController 顶部的导航栏，主要负责 UI 的展示，并对 navigationItem 进行管理。

```swift
open class UINavigationController : UIViewController {
    open var navigationBar: UINavigationBar { get }
}
```

UINavigationItem 是 UINavigationBar 上显示的具体元素的一个抽象类，通过 ViewController 的拓展添加了一个 navigationItem，把 UINavigationItem 交由 ViewController 管理。

```swift
extension UIViewController {    
    open var navigationItem: UINavigationItem { get }
}
```

### UINavigationBar

为了统一定制 UINavigationBar 的 UI，通常的做法子类化 UINavigationController，并设置其中的 UINavigationBar：

```swift
class NavigationController: UINavigationController {}	
```

常见的 UINavigationBar 设置项包括：

![1](1.png)

```swift
func setupNavigationBar() {
    // default: 灰色背景 白色文字 black: 纯黑色背景 白色文字，会被👇的设置项覆盖
    navigationBar.barStyle = .black
    
    // 标题的样式
    navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
    // 标题的垂直位置偏移量
    navigationBar.setTitleVerticalPositionAdjustment(8, for: .default)
    
    // UIBarButtonItem 上的控件颜色，默认为按钮的蓝色
    navigationBar.tintColor = .black
    
    // 是否半透明效果
    navigationBar.isTranslucent = true
    // 背景颜色(会使 isTranslucent = true 失效)
    navigationBar.barTintColor = .white
    // 设置背景图片(会使 barTintColor，isTranslucent = true 失效)
    navigationBar.setBackgroundImage(UIImage(named: "trello"), for: .default)
}
```

关于分割线，通过 shadowImage 或 clipsToBounds 可以去掉。

```swift
func hideBottomLine() {
    // 设置底部分割线，如果传入 UIImage() 可以去掉分割线。
    navigationBar.shadowImage = UIImage(color: .red, size: CGSize(width: navigationBar.width, height: 0.5))
    navigationBar.shadowImage = UIImage()
    
    // 去掉分割线的另外一种方式（会影响到 statusBar，不建议使用这个属性）
    navigationBar.clipsToBounds = true
}
```

### UINavigationItem

UINavigationItem 其实并不是 UIView，它是一个 NSObject。

navigationItem 默认有一个 backBarButtonItem，如下图。![2](2.png)

可以点击回到上一个控制器。可以通过设置 hidesBackButton 隐藏：

```swift
open var backBarButtonItem: UIBarButtonItem? 
open var hidesBackButton: Bool
```

设置标题，左右 Item：

```swift
func setupNavigationItem() {    
    // 设置标题，等效 self.title
    navigationItem.title = "😄"
    title = "title-\(navigationController?.children.count ?? 0)"
    
    // 设置左右 Item
    let backItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(backAction))
    let shareItem = UIBarButtonItem(image: UIImage(named: "share"), style: .done, target: self, action: #selector(shareAction))
    navigationItem.leftBarButtonItem = backItem
    navigationItem.rightBarButtonItem = shareItem
}
```

注意如果设置了 leftBarButtonItem，会使得原本的 backBarButtonItem 失效，并且同时使边缘的返回手势失效。

解决方案如下：

```swift
class NavigationController: UINavigationController {    
    var enablePop = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        interactivePopGestureRecognizer?.delegate = self
    }
}
```

UIGestureRecognizerDelegate：

```swift
extension NavigationController: UIGestureRecognizerDelegate {    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return enablePop
    }
}
```

不过上面的解决方案是有点问题的，你可以试着在 rootViewController 一直尝试边缘手势返回操作，然后再继续正常操作，你会发现页面出现假死现象。原因是 bavigationController.viewControllers 的 count值为 1，滑动时没有上层控制器，系统不知如何处理，所以会出现假死。

解决方案：

```swift
class NavigationController: UINavigationController {        
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}
```

```swift
extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = navigationController.children.count > 1
        if navigationController.children.count == 1 {
            interactivePopGestureRecognizer?.isEnabled = false
        } else {
            interactivePopGestureRecognizer?.isEnabled = enablePop
        }
    }
}
```





