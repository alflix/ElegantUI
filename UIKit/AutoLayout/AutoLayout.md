### 1.AutoLayout是什么？

在Auto Layout之前，不论是在IB里拖放，还是在代码中写，每个UIView都会有自己的frame属性，来定义其在当前视图中的位置和尺寸。

```objective-c
UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
[self.view addSubview:view];
```

使用AutoLayout的话，就变为了使用约束条件来定义view的位置和尺寸。我们用"这个view距离底部10像素，距离顶部10像素，距离左边10像素，距离y右边像素"或"label A右边缘和button B左边缘有20点的空白空间。"这样来描述view。

这样最大好处是可以解决了不同分辨率和屏幕尺寸下view的适配问题，另外也简化了旋转时view的位置的定义，原来在底部之上10像素居中的view，不论在旋转屏幕或是更换设备，始终还在底部之上10像素居中的位置，不会发生变化。

使用AutoLayout另一个重要的好处就是本地化。比如各自语言中中的文本宽度不同适配起来是一件很麻烦的事。AutoLayout能根据label需要显示的内容自动改变label的大小。 

### 2.AutoLayout和Autoresizing Mask的区别

如果你以前一直是代码写UI的话，你肯定写过UIViewAutoresizingFlexibleWidth之类的枚举；如果你以前用IB比较多的话，一定注意到过每个view的size inspector中都有一个红色线条的Autoresizing的指示器和相应的动画缩放的示意图，这就是Autoresizing Mask。autosizing mask决定了当一个视图的父视图大小改变时，其自身需要做出什么改变。

autosizing mask下，你需要为每个view指定各自的宽高，并添加和父视图的约束条件:


![AutoLayout1.png](http://upload-images.jianshu.io/upload_images/6526-d2b349268c25c2ef.png)


![AutoLayout2.png](http://upload-images.jianshu.io/upload_images/6526-6139c19e1c3b7a03.png)


但AutoLayout则看起来简单明了多了，视图的大小和位置再也不重要了，只有约束要紧。当然，当你拖一个新建的button或label到画布上时，它会有一定的大小，并且你会将它拖到某一位置，但这是只一个用来告诉Interface Builder如何放置约束的设计工具。


![AutoLayout3.png](http://upload-images.jianshu.io/upload_images/6526-513206f41681eca2.png)

### 3.开始AutoLayout

我会从一个我们常见的用户注册页面的例子讲起



![AutoLayout4.PNG](http://upload-images.jianshu.io/upload_images/6526-916bc2d0c63ddb55.PNG)

我们希望它在横屏模式下也可以较好地展示出来。

我们在storyBoard中拖拽控件，注意当你拖拽的时候，蓝色虚线将会出现。我们应该用这些虚线来做向导。通过preview（点击show the Assistant Editor,并且切换到preview即可开启）可以看出没有AutoLayout的时候控件摆放非常糟糕。


![AutoLayout4.png](http://upload-images.jianshu.io/upload_images/6526-dada8567b37ee645.png)

![AutoLayout5.png](http://upload-images.jianshu.io/upload_images/6526-1c78281fec5e8385.png)


首先对于左上方的imageView，我们希望它不管屏幕大小如何，都保持同样的大小，所以我们需要做的是将鼠标放在改view上，按住control键，并垂直拖拽。效果如下：


![AutoLayout5.png](http://upload-images.jianshu.io/upload_images/6526-8c23d5720ff29e07.png)

我们点击Height，这样就规定了它的高度固定不变。同样的道理，我们点击Weight，这次你需要水平拖拽。

现在我们观察preview，你会发现imageview跑到左上角去了。并且imageView会出现橙色的线。为什么呢？因为你的AutoLayout是不完整的，你只规定了高度和宽度，你没有规定它距离它的父view边缘的距离是多少。将鼠标放在改view上，按住control键，并拖拽至最外面的view上，放开：会看到下面的选项：

![AutoLayout6.png](http://upload-images.jianshu.io/upload_images/6526-f2f2b7ea5cdc7b03.png)

Top Space to Superview：是指该两个view之间保存固定高度
Center Horizontal In Container：是指该两个view之间垂直居中
Equal Widths:保持相同宽度
Equal Heights:保持相同高度
Aspect Ratio:保存固定比例关系

很明显我们需要点击第一个选项和第二个选项。第二个选项和imageView自身的width相当于规定了imageView到父view的左右边缘长度不变。第一个选项和imageView自身的Height相当于规定了imageView到父view的上下高度不变。因此，该imageView的约束条件就完整了。

对于下面的UITextField,我们希望它距离上面的imageView高度固定，并且左右边缘的距离固定。

我们将UITextField拖拽至imageView，放手如下：

![AutoLayout7.png](http://upload-images.jianshu.io/upload_images/6526-154b503ee6bdd6fb.png)

Vertical Spacing:是指两个view之间的垂直距离固定
Left:是指两个view左边对齐
Center X:是指两个view左边对齐
Right:是指两个viewX轴中心对齐

我们需要点击第一个选项来固定自身和上方imageView之间的距离，然后我们需要固定自身和父view边缘的距离，所以我们拖拽至父view左右边缘，如下图：

![AutoLayout8.png](http://upload-images.jianshu.io/upload_images/6526-f438d9315d9684bf.png)

![AutoLayout9.png](http://upload-images.jianshu.io/upload_images/6526-4163d15f2817fc89.png)

Leading Space to Superview：view至父view左边缘长度(前置距离)固定
Trailing Space to Superview：view至父view右边缘长度(尾随距离)固定

我们对第二个UITextField以及下面的UIButton进行同样的操作。

当你对下面的UIButton进行同样的操作后你会发现仍然出现了表示警告的橙色线，为什么呢？如果你不知道为什么，你可以看到Document Outline那里有一个黄色箭头，点击它，你会来到下图所示：


![AutoLayout11.png](http://upload-images.jianshu.io/upload_images/6526-6dfd89571da9ba43.png)

它说：你期望的view高度是30，但现在它确实52，你需要修复它

你可能怀疑为什么button没有Width约束，自动布局是为何知道button有多宽(30)的？

事情是这样的：button自己是知道自己有多宽。它根据自己的title加上一些padding就行了。如果你为button的title设置更大的字号，它会自动调整它的宽度。

这正是我们熟悉的intrinsic content size。并不是所有的控制器都有这个，但大部分是（UILabel是一个例子）。如果一个视图可以计算自己理想的大小，那么你就不需要为它特别指定Width或Height约束了。但在我们的例子中，我希望这个button更高啊，那怎么办？

点击那个黄色的三角形你会看到：

![AutoLayout12.png](http://upload-images.jianshu.io/upload_images/6526-75e320794ed29708.png)

Update Frame?不，我们不想它的高度变小。Update Constrains?如果你点击这个选项的话，你会发现什么变化都没有，因为在它需要你没有在Height上设置一个约束条件，也就谈不上更新。那我们点击第三个选项试试。

可以发现警告消失了，那我们点击这个选项之后，XCode为我们做了什么？


![AutoLayout13.png](http://upload-images.jianshu.io/upload_images/6526-b58e87881686422a.png)

看这里我们可以发现，UIButton自身增加了一个高度不变的约束条件，所以警告消失了。

我们运行看看效果如何

竖屏：

![AutoLayout15.PNG](http://upload-images.jianshu.io/upload_images/6526-0c7065c75ec2a325.PNG)


横屏：

![AutoLayout14.PNG](http://upload-images.jianshu.io/upload_images/6526-a52abf03ab6c05f1.PNG)

嗯，竖屏看起来还不错，横屏看起来不是太好，UIButton看不见了。这很好理解因为我们固定了控件和父view顶部的距离，但横屏下高度变小所以UIButton被挤到下面去了。那怎么办？如果我们固定了控件和父view底部的距离，很有可能会造成image在横屏模式下被挤到上面去，所以有没有更好的解决办法呢。

其实上面讲到的这些约束条件也是对象，它们是NSLayoutConstraint对象，所以我们可以在程序运行是动态改变其中的约束条件，如下图，我们将imageView和父view的垂直距离约束条件拖动到代码中：

![AutoLayout16.png](http://upload-images.jianshu.io/upload_images/6526-ec25369ff4755b06.png)

在ViewController.m中写下以下代码：
```objective-c
-(void)viewWillLayoutSubviews{
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        self.imageViewToViewSpace.constant = 30;
    }
    else{
        self.imageViewToViewSpace.constant = 82;
    }
}
```

效果看上去还不错：

![AutoLayout17.PNG](http://upload-images.jianshu.io/upload_images/6526-ad5f43cc34eb0e68.PNG)


###4.稍微复杂点的AutoLayout:

我们再将上面那个例子变得稍微复杂一点，把下面的Button变为3个button，每个等宽。

我们首先为button1增加上左右3个距离宽度约束条件：

![](http://upload-images.jianshu.io/upload_images/6526-7bf296d82dc4d151.png)


为button2增加与button1等y轴，与button3距离约束，将button1与button2的距离和button2和button3的距离都设置为8：


![](http://upload-images.jianshu.io/upload_images/6526-d4f30798143e9701.png)


为button3增加与button2等y轴，与父view的Trailing space：


![屏幕快照 2015-03-11 下午5.19.06.png](http://upload-images.jianshu.io/upload_images/6526-7119ef33285da8de.png)

看起来好多警告？恩下面是重点，我们把button1，button2，button3，设置为*同样高度*和*同样宽度*，警告就消失了。

现在运行效果如下：

![](http://upload-images.jianshu.io/upload_images/6526-1850b562845df49e.png)


![](http://upload-images.jianshu.io/upload_images/6526-a789c89200d86694.png)

### 4.SizeClass

我们上面使用了NSLayoutConstraint的IBOutlet对象，所以我们可以在程序运行是动态改变其中的约束条件，不过有另外一种更优雅的方式来实现上面的效果：使用SizeClass。

随着iPhone6/iPhone6 Plus的发布，现在苹果生态圈中的设备尺寸也已经变得种类繁多了。想必苹果也意识到这一点。都知道苹果是以化繁为简的设计哲学深入人心的，这次再一次证明了。SizeClass是对设备尺寸的一个抽象概念，现在任何设备的 长、宽 被简洁地分为三种情况：普通 (Regular) 、紧密 (Compact)和任意(Any) ，这样，根据长和宽不同的搭配就能产生 3*3=9 种不同尺寸。下图展示个每种情况对应的设备。


![1411722627166330.png](http://upload-images.jianshu.io/upload_images/6526-2f988d9161efdee4.png)


我们可以在不同的屏幕尺寸下使用不同的SizeClass，在正常情况下：


![](http://upload-images.jianshu.io/upload_images/6526-d603504c1214f28e.png)

点击 wAny,hAny可以更改需要布局的尺寸，显然横屏的时候，高度处于压缩的状态，（height: compact），我们需要先对正常的布局之外，还要添加一种（wAny, hCompact）


![](http://upload-images.jianshu.io/upload_images/6526-5c4c6bb10eac45c6.png)

然后我们在这个状态下重新设置我们的布局方式，把上面的imageView的topSpace 修改为10：


![](http://upload-images.jianshu.io/upload_images/6526-7f89cfd392efcbc2.png)

你需要知道的是在这个状态下的布局方式不会影响其它size下的布局方式，预览效果如下：


![](http://upload-images.jianshu.io/upload_images/6526-49e7b2773e7fe2be.png)

你有没有注意到imageView的图片不同了呢，你是不是以为我使用了不同的image？其实是同一张图片，只不过我们可以在Images.xcassets上对不同size下使用不同的图片：


![](http://upload-images.jianshu.io/upload_images/6526-c51adc54b0a8d331.png)

### 5.AutoLayout与UITableView
你见识到了AutoLayout的强大之处了吧，下面的例子让我们把AutoLayout应用到UITableView中，尝试来构建更复杂的应用。例如下面图片，当UITableView中内容不同时，使用AutoLayout来动态调整UITableCell的高度。

![IMG_0920.PNG](http://upload-images.jianshu.io/upload_images/6526-6c56d0f4fd02f843.PNG)

我们新建一个UITableViewController的子类，在我们的storyBoard中添加一个TableViewController,并将它的自定义类设置为DynamicCellHeightViewController。

![AutoLayout1.png](http://upload-images.jianshu.io/upload_images/6526-2d380399248f613e.png)

在我们的cell上添加如下imageView和Label两个控件：

![AutoLayout4.png](http://upload-images.jianshu.io/upload_images/6526-403af7a6d8414260.png)

新建自定义的cell类CustomTableViewCell并将storyBoard中的cell关联至该类。


![AutoLayout7.png](http://upload-images.jianshu.io/upload_images/6526-61895df4b0aff0dc.png)


并将UILabel的属性Lines设为了0以表示显示多行。将cell的Identifier设置为"cell"。

让我们给这些view一点约束。在上一篇文章你已经知道了通过按住ctrl在两个view之间拖拽增加约束的方式，此外，我们还有其他两种方式:用Editor\Pin和Align菜单:

![AutoLayout2.png](http://upload-images.jianshu.io/upload_images/6526-92fa783c67bbbdf6.png)

还有在Interface Builder窗口的底部有一行这样的按钮：

![AutoLayout3.png](http://upload-images.jianshu.io/upload_images/6526-33eb151b605d4593.png)

从左到右分别是：对齐(Align)，固定(Pin)，解决自动布局问题(Resolve Auto Layout Issues)和重定义尺寸(Resizing Behavior)。前三个按钮鱼Editor菜单中的对应项有一致的功能。Resizing Behavior按钮允许你在重新设置view的尺寸的时候，改变已经添加的约束。

顶部的Spacing to nearest neighbor可以添加上下左右四个约束条件，点击者4个T字架，它们就会变成实体的红色：

![AutoLayout5.png](http://upload-images.jianshu.io/upload_images/6526-d1fbf7feb10d21a1.png)

如上图所示，我们为imageView增加4个约束条件。同理我们为label增加4个约束条件。

![AutoLayout6.png](http://upload-images.jianshu.io/upload_images/6526-4a09f47825888a3a.png)

好了，我们已经完成了AutoLayout的布局，下面我们需要实现UITableView的协议。

先声明了一个NSArray变量来存放数据。

```objective-c
@interface DynamicCellHeightViewController ()
@property (nonatomic, strong) NSArray *tableData;
@end

@implementation DynamicCellHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableData = @[@"1\n2\n3\n4\n5\n6", @"123456789012345678901234567890", @"1\n2", @"1\n2\n3", @"1"];
}
```

现在实现UITableViewDataSource的protocol:

```objective-c
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = self.tableData[indexPath.row];
    return cell;
}
```

从self.tableData中的数据我们可以看到，每一个Cell显示的数据高度是不一样的，那么我们需要动态计算Cell的高度。由于是自动布局，所以我们需要用到一个systemLayoutSizeFittingSize:来计算UITableViewCell所占空间高度。

这里有一个需要注意的问题，UITableView是一次性计算完所有Cell的高度，如果有1W个Cell，那么heightForRowAtIndexPath就会触发1W次，然后才显示内容。不过在iOS7以后，提供了一个新方法可以避免这1W次调用，它就是estimatedHeightForRowAtIndexPath。要求返回一个Cell的估计值，实现了这个方法，那只有显示的Cell才会触发计算高度的protocol. 由于systemLayoutSizeFittingSize需要cell的一个实例才能计算，所以这儿用一个成员变量存一个Cell的实列，这样就不需要每次计算Cell高度的时候去动态生成一个Cell实例，这样即方便也高效也少用内存，可谓一举三得。

我们声明一个存计算Cell高度的实例变量：

```objective-c
@property (nonatomic, strong) UITableViewCell *prototypeCell;
```

然后在viewDidLoad中初始化它：

```objective-c
self.prototypeCell  = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
```

计算Cell高度的实现：

```objective-c
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell *)self.prototypeCell;
    cell.label.text = [self.tableData objectAtIndex:indexPath.row];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"h=%f", size.height + 1);
    return 1  + size.height;//加1是因为分隔线的高度
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}
```

运行效果如下：

![AutoLayout8.PNG](http://upload-images.jianshu.io/upload_images/6526-eb9ad0456a5afc9d.PNG)

恩，好像哪里不对，计算cell高度时应该考虑头像的高度。

如下图，我们为头像和cell之间添加一个约束条件，并在右面板中将Constant设置为>=10,这样cell的最小高度也是头像高度位置加上10了。

![AutoLayout9.png](http://upload-images.jianshu.io/upload_images/6526-2c95bc59282689dc.png)

运行效果如下：

![AutoLayout10.PNG](http://upload-images.jianshu.io/upload_images/6526-eded151998c98e10.PNG)

如果不用systemLayoutSizeFittingSize，我们也可以手动计算cell的高度，只要计算cell中label的文字高度即可，下面是该方法：

```objective-c
#import "NSString+addition.h"

@implementation NSString (addition)
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self sizeWithFont:font
                                       constrainedToSize:size                                           lineBreakMode:NSLineBreakByWordWrapping];
    }
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}
@end
```

像label这种控件会根据label中text的内容自动调整其高度，那如果是UITextView呢，我们需要下面的方法来返回其大小。

```
CGSize textViewSize = [cell.label sizeThatFits:CGSizeMake(cell.t.frame.size.width, FLT_MAX)];
```

### 6.Self Sizing
在iOS8中引入了一个强大的新特性，Self Sizing.只要在viewDidLoad中加入以下这两行代码，然后加入上面的自动布局，我们就可以把计算高度的代码删掉了。


```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;    
}
```

我自己在项目中也尝试用过Self Sizing这个特性，不过当tableView加载特别多内容时会有明显的卡顿效果并且tableView有时还会上下跳动！所以我对它的使用保留谨慎态度。不过，在构建简单的tableView时，这是一个非常好用的特性。

### 7AutoLayout与ScrollView

ScrollView在AutoLayout上的表现稍微有点特殊，我们来讲讲。首先我们拖动一个
ScrollView到视图中，并设置它的约束条件：x , y , width , height.

![](http://upload-images.jianshu.io/upload_images/6526-7cfba09dde3a28f4.png)

UIScrollView特殊在于：需要设置其ContentView!，所以你需要另外拖一个UIView上作为它的内容视图。

并且设置ContentView对应于UIScrollView的Leading Space、Trailing Space、Top Space、Bottom Space以及其width、height.我设置Leading Space、Trailing Space、Top Space、Bottom Space都为 0。

![](http://upload-images.jianshu.io/upload_images/6526-3b5e6667c14ed6b2.png)

在这个例子里，我们需要内容视图在ScrollView中滑起来，而且只能垂直滑动而不能水平滑动，所以我们需要把ContentView的宽设置成和ScrollView一样，但是高一定要大于ScrollView的高：


![](http://upload-images.jianshu.io/upload_images/6526-1e71d8463c700618.png)


你可以在[这里](https://github.com/jieyuanz/ios_demo)下载完整的代码。如果你觉得对你有帮助，希望你不吝啬你的star：）