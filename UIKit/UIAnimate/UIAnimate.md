## 1.视图动画
UIView提供了丰富的动画功能，最常见是animateWithDuration:animations: completion:了，我们先看下面这个简单的例子：

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    self.circleView = [[CircleView alloc] initWithFrame:
                       CGRectMake(0, 0, 20, 20)];
    self.circleView.center = CGPointMake(100, 40);
    [[self view] addSubview:self.circleView];
    
    self.squareView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    _squareView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_squareView];
    
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropAnimate:)];
    [[self view] addGestureRecognizer:g];
}

- (void)dropAnimate:(UIGestureRecognizer *)recognizer {
    [UIView animateWithDuration:3 animations:^{
         recognizer.enabled = NO;
         self.circleView.center = CGPointMake(100, 300);
        
        CGRect newFrame = CGRectMake(self.squareView.frame.origin.x + 150,
                                     self.squareView.frame.origin.y,
                                     self.squareView.frame.size.width,
                                     self.squareView.frame.size.height);
        self.squareView.frame = newFrame;
        self.squareView.alpha = 0.5;       
     }
     completion:^(BOOL finished){
         [UIView animateWithDuration:1 animations:^{
              self.circleView.center = CGPointMake(250, 300);
          }
          completion:^(BOOL finished){
              recognizer.enabled = YES;
          }
          ];
     }];
}
```

这是一种基于视图的最简单的动画了，常用于大小、位置、不透明度的变换，运行结果如下：

![](http://upload-images.jianshu.io/upload_images/6526-74fb2155feb2a398.gif)

上面的例子中，我们只要在animations中写入我们需要进行动画效果的view的结束状态，然后在animateWithDuration中给出动画时间，改方法就会自动完成动画效果。

此外，我们还使用了recognizer.enabled = NO来禁止动画过程中的手势触摸，防止动画过程中你再次触摸后又会重新开始动画效果。


为了让动画看起来更酷，你需要使用Core Animation.Core Animation中最基础也是最重要的部分就是CALayer。

## 2.CALayer

在iOS中，你能看得见摸得着的东西基本上都是UIView，比如一个按钮、一个文本标签、一个文本输入框、一个图标等等，这些都是UIView。UIView之所以能显示在屏幕上，完全是因为它内部的一个图层，即CALayer。

换句话说，UIView本身不具备显示的功能，拥有显示功能的是它内部的图层。,CALayer和UIView很多方面都很像，它也有位置、大小、变形和内容，和UIView不同在于它不能处理事件(如触摸事件)，它完全属于绘制那方面的内容。所以UIView使用CALayer来管理绘制内容，这样两者就可以协调得很好。

使用之前首先记得引用：#import <QuartzCore/QuartzCore.h>.

CALayer 能够对 UIView 做许多设定，如：阴影、边框、圆角和透明效果等，且这些设定都是很有用的 

>1.borderWidth 和 boarderColor : 边框颜色和宽度；
>2contents：显示的图片内容：CDImage
>3.cornerRadius : UIView 的圆角；
>4masksToBounds :设为true切去超过边界的子视图,和UIView的clipsToBounds类似；
>4shadowColor: 设置shadow的颜色
>5.shadowPath : 设置shadow的位置
>6.shadowOffset :设置阴影的偏移量，如果为正数，则代表为往右边偏移
>7.shadowOpacity :设置阴影的透明度(0~1之间，0表示完全透明)
>8.shadowRadius : shadow的渐变距离，从外围开始，往里渐变shadowRadius距离
>9.bounds : UIView 的大小；
>10.opacity : UIView 的透明效果；

#### a.设置view的layer属性

我们在storyBoard中拖入一个120*120的UIView并连接至IBOutler：

![](http://upload-images.jianshu.io/upload_images/6526-439a91c49ad6b51d.png)

设置UIView 的边框颜色和宽度和圆角，注意，设置UIView的圆角,若为UIView是正方形，cornerRadius是边长的一半的话，则显示为圆形。

```objective-c
    self.CALayoutView.layer.borderWidth=5;
    self.CALayoutView.layer.borderColor=[UIColor purpleColor].CGColor;
    self.CALayoutView.layer.cornerRadius=60;
```

如下：

![](http://upload-images.jianshu.io/upload_images/6526-67c850715363ede0.png)

在view的图层上添加一个image并设置阴影效果：

```objective-c
    self.CALayoutView.layer.contents=(id)[UIImage imageNamed:@"photo"].CGImage;
    self.CALayoutView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.CALayoutView.layer.shadowOffset=CGSizeMake(15, 5);
    self.CALayoutView.layer.shadowOpacity=0.6;
    self.CALayoutView.layer.shadowRadius = 1;
```

![](http://upload-images.jianshu.io/upload_images/6526-dfdb63bff790815e.png)

裁剪视图：

```objective-c
self.CALayoutView.layer.masksToBounds = YES;
```

不过这样阴影效果也裁去了：

![](http://upload-images.jianshu.io/upload_images/6526-ff4632e0dd3c34b6.png)

#### b.子类化CALayer

你可以通过子类化CALayer并覆盖以下方法：

```objective-c
[CALayer display]
[CALayer drawInContext:]
```

覆盖图层的display方法可直接设置图层的contents属性。

覆盖图层的drawInContext：方法可以将需要的内容绘制到提供的图形上下文中。

选择何种方法依赖于在绘图过程中你需要多少的控制。display方法是更新图层内容的主要入口点，所以覆盖这个方法让你处于完全的过程控制中。覆盖display方法也意味你需要负责contents属性创建CGImageRef对象。如果你只是想绘制内容（或让你的图层管理绘图操作），你可以覆盖drawInContext：方法并让图层为你创建内容储备。
如下:

MyLayer.m

```objective-c
@implementation MyLayer

-(void)display{
    self.bounds=CGRectMake(50, 50, 50, 50);
    self.position=CGPointMake(50, 50);
    self.contents=(id)[UIImage imageNamed:@"photo"].CGImage;
    self.cornerRadius=5;
    self.masksToBounds=YES;
    self.borderWidth=3;
    self.borderColor=[UIColor brownColor].CGColor;
}
```

然后在view的layer图层添加subLayer

```objective-c
    CALayer *myLayer = [MyLayer layer];
    [myLayer setNeedsDisplay];
    [self.view.layer addSublayer:myLayer];
```

效果：

![](http://upload-images.jianshu.io/upload_images/6526-f87947af59a2bfe1.png)

#### c.使用代理提供图层的内容

或者使用代理对象（即UIView或ViewController作为代理对象）实现以下方法

```objective-c
[delegate displayLayer:]
[delegate drawLayer:inContext:]
```

如果你的代理实现了displayLayer：方法，实现方法负责创建位图并赋值给contents属性。一般实现该方法是因为位图有多种状态并且都有各自的状态，按钮就是这样子的。

如果你没有预渲染的图片或者辅助对象来创建位图。代理对象可以使用drawLayer：inContext：方法，Core Animation创建一个位图，创建一个用于绘制位图的上下文，并调用代理方法填充该位图。你的代理方法所要做的是将内容画在图形上下文上。一般可以使用Core Graphics来绘制，不过使用UIGraphicsPushContext方法的话，也可以通过UIKit做到。

代理对象必须实现displayLayer：或者drawLayer：inContext方法之一。如果代理对象把这两个方法都实现了，图层只调用displayLayer：方法。

不过有一个需要注意的问题，在自定义view中（子类化CALayer也是）上述方法不会自己调用，只能自己通过setNeedDisplay方法标记CALayer需要重绘，这样就可以自动绘制所有子视图了。UIView默认在你需要它的时候绘制，而CALayer则在你明确要求它时才会绘制。

```objective-c
[self.layer setNeedsDisplay];
```

我们来举一个例子，在drawLayer：inContext中通过UIKit进行绘制。（使用Core Graphics的方法可以见上一篇文章）

DelegateView.m

```objective-c
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self.layer setNeedsDisplay];
  }
  return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  UIGraphicsPushContext(ctx);
  [[UIColor lightGrayColor] set];
  UIRectFill(layer.bounds);

  UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  UIColor *color = [UIColor blackColor];

  NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
  [style setAlignment:NSTextAlignmentCenter];
  
  NSDictionary *attribs = @{NSFontAttributeName: font,
                            NSForegroundColorAttributeName: color,
                            NSParagraphStyleAttributeName: style};

  NSAttributedString *
  text = [[NSAttributedString alloc] initWithString:@"孙悟空"
                                         attributes:attribs];

  [text drawInRect:CGRectInset([layer bounds], 10, 10)];
  UIGraphicsPopContext();
}
```

CALayoutViewController.m
```objective-c
    UIView *delegateView = [[DelegateView alloc] initWithFrame:CGRectMake(120, 400, 120, 50)];
    delegateView.center = self.view.center;
    [self.view addSubview:delegateView];
```

注意上面，我们不需要把UIView设置为CALayer的delegate，因为UIView对象已经是它内部根层的delegate，再次设置为其他层的delegate就会出问题。如果你是在控制器中实现CALayer的delegate方法，你就需要指定：

```objective-c
layer.delegate=self
```
效果：

![](http://upload-images.jianshu.io/upload_images/6526-bcbb687a407523c0.png)

当UIView需要在屏幕显示时，它内部会准备好一个CGContextRef(图形上下文)，然后调用delegate的drawLayer:inContext:方法，并且传入已经准备好的CGContextRef对象。

而UIView在drawLayer:inContext:方法中又会调用自己的drawRect:方法。平时在drawRect:中通过UIGraphicsGetCurrentContext()获取的就是以上传入的CGContextRef对象，在drawRect:中完成的所有绘图都会填入层的CGContextRef中，然后被拷贝至屏幕。

## 3.开始动画

先看一张类的继承结构图：

![](http://upload-images.jianshu.io/upload_images/6526-b4325c9f0785f2c3.png)

CAAnimation是所有动画类的父类，但是它不能直接使用，应该使用它的子类。能用的动画类只有4个子类：CABasicAnimation、CAKeyframeAnimation、CATransition、CAAnimationGroup。CAMediaTiming是一个协议(protocol)。

CAPropertyAnimation是CAAnimation的子类，但是不能直接使用，要想创建动画对象，应该使用它的两个子类：CABasicAnimation和CAKeyframeAnimation。

它有个NSString类型的keyPath属性，你可以指定CALayer的某个属性名为keyPath，并且对CALayer的这个属性的值进行修改，达到相应的动画效果。比如，指定@"position"为keyPath，就会修改CALayer的position属性的值，以达到平移的动画效果

###1).隐式动画

上一篇文章我们讲了如何在图层中绘图，现在需要开始使用图层来创建动画了。如下所示，我们对MyLayer添加以两秒到达终点的移动效果。

```objective-c
- (void)viewDidLoad {
...省略
[self.view addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drop:)]];
}

- (void)drop:(UIGestureRecognizer *)recognizer {
    [CATransaction setAnimationDuration:1.0];
    NSArray *layers = self.view.layer.sublayers;
    NSLog(@"--%@",layers);
    //由打印出来的数组得知第5个是MyLayer
    CALayer *layer = [layers objectAtIndex:4];
    CGPoint toPoint = CGPointMake(160, 210);
    [layer setContents:(id)[UIImage imageNamed:@"id"].CGImage];
    [layer setPosition:toPoint];
    [layer setBounds:CGRectMake(0, 0, 90, 90)];
}
```

每一个UIView内部都默认关联着一个CALayer，我们可用称这个Layer为Root Layer（根层），所有的非Root Layer，也就是手动创建的CALayer对象（比如上面例子中的MyLayer），都存在着隐式动画。

什么是隐式动画？
当对非Root Layer的部分属性进行修改时，默认会自动产生一些动画效果,这些属性称为Animatable Properties(可动画属性)

几乎所有的层的属性都是隐性可动画的，你可以查找文档中那些属性是可动画属性：

![](http://upload-images.jianshu.io/upload_images/6526-54cda233d807646a.png)

例如上面那个例子的运行效果如下：

![](http://upload-images.jianshu.io/upload_images/6526-f532ab89b21f854f.gif)


### 2).显式动画

隐式动画大部分情况下可以达到你的要求，不过有时候你需要更多的控制，这就需要用到CAAnimation了。隐式动画就是通过CAAnimation来实现的，因此所有可以在隐式动画完成的事情在显式动画中都可以做到。

下面是最基本的动画CABasicAnimation的例子：

```objective-c
    CABasicAnimation *anim = [CABasicAnimation  animationWithKeyPath:@"opacity"];
    anim.fromValue = @1.0;
    anim.toValue = @0.0;
    anim.autoreverses = YES;
    anim.repeatCount = INFINITY;
    anim.duration = 2.0;
    [layer addAnimation:anim forKey:@"anim"];
```

效果如下：它会每隔两秒重复绘制一次图层，将不透明度从1改为0。

![](http://upload-images.jianshu.io/upload_images/6526-4f2323bab4decd58.gif)

你可以通过以下方法移除这个动画来停止它：

```objective-c
[layer removeAnimationForKey:@"anim"];
```

动画有它的(key)关键帧、(fromValue)起始值、(toValue)目标值、(timingFunction)时间函数、(duration)持续时间等。它的工作原理是创建图层的多个副本，然后把它们显示出来。我们再看另外一个动画：

```objective-c
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.byValue = @120;
    animation.duration = 2;
    animation.beginTime = CACurrentMediaTime()+1.5;
    [layer addAnimation:animation forKey:@"positionX"];
```

注意动画的键路径，也就是 position.x，实际上包含一个存储在 position 属性中的 CGPoint 结构体成员。这是 Core Animation 一个非常方便的特性。另外我们可以用byValue替代fromValue和toValue,只需要指定它的变化值，不需要指定它的起始值和目标值。

关于beginTime下一小节会讲到。

效果如下：

![](http://upload-images.jianshu.io/upload_images/6526-6a14b81fe95be8cd.gif)

有一个问题，那就是动画结束后图层会很快地回到原点，我们把这种现象叫作jump back（闪回），要解决这个问题你需要了解model layer(模型层)和presentation layer(表示层)的概念和区别。

模型层是由开始动画前的CALayer对象的属性定义的。当开始动画后，CAAnimation创建了CALayer对象的副本并进行修改，使其变成表现层，你可以大致理解为就是它们在屏幕上显示什么内容。

前面的示例中，当执行动画时，状态从模型层变为表现层，表现层被绘制到屏幕上，绘制完成后，所有的更改都会丢失并由模型层决定当前状态，因为模型层没有改变，所以会恢复到一开始的状态。

解决方法1：你可以通过设置动画的 fillMode 属性为  kCAFillModeForwards或kCAFillModeBoth使得动画 以留在最终状态，并设置removedOnCompletion 为 NO 以防止它被自动移除：

```objective-c
animation.fillMode = kCAFillModeForwards;
animation.removedOnCompletion = NO;
```

但这不是好的解决方法，因为这样模型层永远不会更新，如果之后对它进行隐性动画，那它不会正常工作。

解决方法2:直接在 model layer 上更新属性

我们先移除上面的隐式动画（待会会讲到为什么），然后

```objective-c
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = @50;
    animation.toValue = @170;
    //animation.byValue = @120;
    
    animation.duration = 2;
    animation.beginTime = CACurrentMediaTime()+1.2;
    [layer addAnimation:animation forKey:@"positionX"];
    
    layer.position = CGPointMake(170, 50);
```

注意这种情况下，我们必须指定fromValue和toValue，不能使用byValue，我们最后指定了模型层的layer.position = CGPointMake(170, 50)，看看效果怎样


![](http://upload-images.jianshu.io/upload_images/6526-c4da060b1491e219.gif)

啊哦，你发现了没，现在是开始前有一个闪回（摔桌！）

不过我们可以加入下面这句，使得它在动画开始之前不做任何动作

```objective-c
animation.fillMode = kCAFillModeBackwards;
```

![](http://upload-images.jianshu.io/upload_images/6526-f89feaa859da04af.gif)

关于kCAFillModeBackward和kCAFillModeForward的概念可以看下面这张图：

![](http://upload-images.jianshu.io/upload_images/6526-7369f4bc638ad907.png)

再说一下之前被我们移除的隐性动画，其实我们真正需要移除的是下面这个

```objective-c
[layer setPosition:toPoint];
```

因为它和我们的显性动画有冲突。所以最好的解决办法是在执行显示动画时关闭隐式动画

```objective-c
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    ...省略
    [CATransaction commit];
```

所以其实我们可以针对这种情况写一个分类：

```objective-c
@implementation CALayer (CALayer_RNAnimation)

- (void)setValue:(id)value
      forKeyPath:(NSString *)keyPath
        duration:(CFTimeInterval)duration
           delay:(CFTimeInterval)delay {
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  [self setValue:value forKeyPath:keyPath];
  CABasicAnimation *anim;
  anim = [CABasicAnimation animationWithKeyPath:keyPath];
  anim.duration = duration;
  anim.beginTime = CACurrentMediaTime() + delay;
  anim.fillMode = kCAFillModeBoth;
  anim.fromValue = [[self presentationLayer] valueForKey:keyPath];
  anim.toValue = value;
  [self addAnimation:anim forKey:keyPath];
  [CATransaction commit];
}
```

###3）.关于定时

Core Animation中的时间是相对的，一秒时间不一定就是一秒钟，与坐标一样，时间是可以缩放的。Core Animation遵守CAMediaTiming协议，可以设置其speed属性来缩放它的时间跨度。

你可能会需要在某个图层的动画结束后开始自己的动画，因此你需要对它们之间的时间进行转换，就像转换不同视图中的点一样。

```objective-c
   CAAnimation *otherAnim = [layer animationForKey:@"anim"];
   CFTimeInterval finish = otherAnim.beginTime + otherAnim.duration;
   myAnim.beginTime = [self convertTime:finish fromLayer:layer];
```

如果想引用当前时间，可以使用CACurrentMediaTime()，例如：

```objective-c
    anim.beginTime = CACurrentMediaTime()+3.0;
    anim.fillMode = kCAFillModeBackwards;
```

该动画会在前3秒保存不动，3秒后开始动画。

你想要为你的动画定义超过两个步骤，我们可以使用更通用的 CAKeyframeAnimation，而不是去链接多个 CABasicAnimation 实例。

### 4).CAKeyframeAnimation

跟CABasicAnimation的区别是：CABasicAnimation只能从一个数值(fromValue)变到另一个数值(toValue)，而CAKeyframeAnimation会使用一个NSArray保存这些数值

包含以下属性：

values：就是上述的NSArray对象。里面的元素称为”关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧

path：可以设置一个CGPathRef\CGMutablePathRef,让层跟着路径移动。path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略

keyTimes：可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的

CABasicAnimation可看做是最多只有2个关键帧的CAKeyframeAnimation

#### a).多步动画

下面的例子我们值改变values的值，即定义关键帧。关键帧（keyframe）使我们能够定义动画中任意的一个点，然后让 Core Animation 填充所谓的中间帧。先看运行效果：


![](http://upload-images.jianshu.io/upload_images/6526-adb3c04f10c613f0.gif)

代码如下：

```objective-c
- (IBAction)enter:(id)sender {
    if (![self.textField.text isEqualToString:@"123456"]) {
        [self lockAnimationForView:self.textField];
    }
}

-(void)lockAnimationForView:(UIView*)view
{
    CALayer *layer = [view layer];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @5, @10, @-10, @10, @5, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0),@(2 / 6.0), @(3 / 6.0), @(5 / 6.0),@(2 / 6.0), @1 ];
    animation.duration = 0.4;
    
    animation.additive = YES;
    
    [layer addAnimation:animation forKey:@"shake"];
}
```

values 数组定义了UITextField应该到哪些位置。设置 keyTimes 属性让我们能够指定关键帧动画发生的时间。它们被指定为关键帧动画总持续时间的一个分数。


设置 additive 属性为 YES 使 Core Animation 在更新表现层之前将动画的值添加到模型层中去。这使我们能够对所有形式的需要更新的元素重用相同的动画，且无需提前知道它们的位置。因为这个属性从 CAPropertyAnimation 继承，所以你也可以在使用 CABasicAnimation 时使用它。

#### b).沿路径的动画
CAKeyframeAnimation 提供了更加便利的 path 属性使得view可以沿着复杂路径的动画运动。

举个例子，我们如何让一个 view 做圆周运动：

![](http://upload-images.jianshu.io/upload_images/6526-8b21207d76ef4d96.gif)

代码如下：

```objective-c
-(void)pathAnimation:(UITapGestureRecognizer*)tap{
    tap.enabled = NO;
    CALayer *layer = [self.pathView layer];
    CGRect boundingRect = CGRectMake(-150, -150, 300, 300);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = CFAutorelease(CGPathCreateWithEllipseInRect(boundingRect, NULL));
    animation.duration = 4;
    animation.additive = YES;
    animation.repeatCount = HUGE_VALF;
    animation.calculationMode = kCAAnimationPaced;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    [layer addAnimation:animation forKey:@"path"];
}
```

我们使用 CGPathCreateWithEllipseInRect()创建一个圆形的 CGPath 作为我们的关键帧动画的 path。

使用 calculationMode 是控制关键帧动画时间的另一种方法。我们通过将其设置为 kCAAnimationPaced，让 Core Animation 向被驱动的对象施加一个恒定速度，不管路径的各个线段有多长。将其设置为 kCAAnimationPaced 将无视所有我们已经设置的 keyTimes。设置 rotationMode 属性为 kCAAnimationRotateAuto 确保view沿着路径旋转。

### 5).时间函数

你会发现我们上面有些动画有一些看起来不是很不自然。那是因为我们在现实世界中看到的大部分运动需要时间来加速或减速。为了给我们的动画一个存在惯性的感觉，我们可以通过引入一个 *时间函数 (timing function)* （有时也被称为 easing 函数）来实现这个目标。该函数通过修改持续时间的分数来控制动画的速度。

```objective-c
animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
```

还包含：kCAMediaTimingFunctionEaseIn, kCAMediaTimingFunctionEaseOut, kCAMediaTimingFunctionEaseInEaseOut，你们可以自己试试效果如何。

你还可以参见类似这种小型库 [RBBAnimation](https://github.com/robb/RBBAnimation)，它包含一个允许使用 [更多复杂 easing 函数](https://github.com/robb/RBBAnimation#rbbtweenanimation) 的自定义子类 CAKeyframeAnimation，包括反弹和包含负分量的 cubic Bézier 函数。


### 6).动画组

对于某些复杂的效果，可能需要同时为多个属性进行动画。CAAnimationGroup可以保存一组动画对象，将CAAnimationGroup对象加入层后，组中所有动画对象可以同时并发运行。

默认情况下，一组动画对象是同时运行的，也可以单独通过设置动画对象的beginTime属性来更改动画的开始时间，示例如下：

```objective-c
-(void)groupAnimation:(UITapGestureRecognizer*)tap{
    // 平移动画
    CABasicAnimation *animation1 = [CABasicAnimation animation];
    animation1.keyPath = @"transform.translation.y";
    animation1.toValue = @(100);
    // 缩放动画
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"transform.scale";
    animation2.toValue = @(0.0);
    // 旋转动画
    CABasicAnimation *animation3 = [CABasicAnimation animation];
    animation3.keyPath = @"transform.rotation";
    animation3.toValue = @(M_PI_2);

    // 组动画
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];

    groupAnima.animations = @[animation1, animation2, animation3];

    //设置组动画的时间
    groupAnima.duration = 2;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    [self.groupViewFirst.layer addAnimation:groupAnima forKey:@"group"];
}
```

运行效果：

![](http://upload-images.jianshu.io/upload_images/6526-579fbe6b90363415.gif)

你可以在[这里](https://github.com/jieyuanz/ios_demo)下载完整的代码。如果你觉得对你有帮助，希望你不吝啬你的star：）