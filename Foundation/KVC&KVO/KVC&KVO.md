![0](0.jpg)

<!-- TOC -->

- [概述](#概述)
- [键值编码 KVC](#键值编码-kvc)
    - [KVC 简单赋值 & 取值](#kvc-简单赋值--取值)
    - [访问私有成员变量](#访问私有成员变量)
    - [KVC 实现原理](#kvc-实现原理)
- [KVC 和容器类](#kvc-和容器类)
    - [KVC 和字典](#kvc-和字典)
    - [集合的高阶消息传递](#集合的高阶消息传递)
    - [集合的容器操作符](#集合的容器操作符)
- [键值观察 KVO](#键值观察-kvo)
    - [例子：](#例子)
    - [手动设定实例变量的 KVO 实现监听](#手动设定实例变量的-kvo-实现监听)
    - [KVO 实现原理](#kvo-实现原理)

<!-- /TOC -->

<a id="markdown-概述" name="概述"></a>
## 概述

一个更好用来观察属性变化的方法是使用 键值监听（Key Value Observing，简称 KVO ），Apple 在自己的软件中大量使用 KVO。使用 KVO 跟踪单个属性或集合（如数组）的变化非常高效，键值观察建立在 键值编码（Key Value Coding，简称 KVC ）基础上，也就是任何你想使用 KVO 监听的属性必须符合键值编码。KVO 只需要在观察者方法中添加代码，不需要修改被观察文件内代码，这一点和委托、通知不同。下面我们讲讲 KVC 和 KVO。

<a id="markdown-键值编码-kvc" name="键值编码-kvc"></a>
## 键值编码 KVC

KVC（全称 key-value-coding）即键值编码。
ObjC 中几乎所有的对象都支持 KVC 操作，它是一种不通过存取方法（Setter、Getter），而通过属性名称字符串（key）间接访问类属性(实例变量)的机制。

<a id="markdown-kvc-简单赋值--取值" name="kvc-简单赋值--取值"></a>
### KVC 简单赋值 & 取值

主要有以下两个方法：
赋值：

```objective-c
- (void)setValue:(nullable id)value forKey:(NSString *)key;
- (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;
```

取值：

```objective-c
- (id)valueForKey:(NSString *)key;
- (nullable id)valueForKeyPath:(NSString *)keyPath;
```

key 即属性名，value 即属性所对应的值。另外其中 forKey: 和 forKeyPath 的区别是：

- forKeyPath 包含了所有 forKey 的功能
- forKeyPath 可以使用点语法,一层一层访问内部的属性

值得注意的是这个不仅可以访问作为对象属性，而且也能访问一些标量（例如 int 和 CGFloat）和 struct （例如 CGRect）Foundation 框架会为我们自动封装它们。如下：

```objective-c
[object setValue:@(20) forKey:@"height"];
CGFloat height = [[object valueForKey:@"height"] floatValue];
```

> 不过，把非对象属性设为 nil 是一种特殊情况。当标量和 struct 的值被传入 nil 的时候尤其需要注意。通常会抛出一个 exception, 要正确的处理 nil, 我们要重载 setNilValueForKey:

<a id="markdown-访问私有成员变量" name="访问私有成员变量"></a>
### 访问私有成员变量

除了标量，我们甚至可以访问私有属性

```objective-c
@interface BookData : NSObject {  
    NSString * bookName;  
}  
```

```objective-c
BookData * book1 = [[BookData alloc] init];  
[book1 setValue:@"english" forKey:@"bookName"];  
```

<a id="markdown-kvc-实现原理" name="kvc-实现原理"></a>
### KVC 实现原理

例如上面的例子：

```objective-c
[book1 setValue:@"english" forKey:@"bookName"]; 
```

- 首先去模型中查找有没有 setBookName，若有，直接调用赋值 [self setBookName:@"english"]。
- 若无，去模型中查找有没有 bookName 属性，若有，直接访问属性赋值 bookName = value。
- 若无，再去模型中查找有没有 _bookName 成员变量，若有，直接访问属性赋值 _bookName = value。
- 找不到，就会直接报找不到的错误（valueForUndefinedKey:）。

<a id="markdown-kvc-和容器类" name="kvc-和容器类"></a>
## KVC 和容器类

有一种更灵活的方式来管理容器类属性，举个例子 :
Contact.h：

```objective-c
@interface Contact : NSObject
- (NSUInteger)countOfNumbers;
- (id)objectInNumbersAtIndex:(NSUInteger)index;
```

Contact.m：

```objective-c
- (NSUInteger)countOfNumbers {
    return 2;
}
- (id)objectInNumbersAtIndex:(NSUInteger)index {
    return @(index * 2);
}
```

ViewController.m：

```objective-c
- (void)updateTextFields:{
    NSArray *items = [_contact valueForKey:@"numbers"];
    NSLog(@"numbers---%@",items);
}
```

打印结果如下：

```objective-c
numbers---(
0,
2)
```

就算没有 numbers 这个属性，KVC 系统也能创建一个行为和数组一样的代理对象。原因是 contact 实现了 countOfNumbers 和 objectInNumbersAtIndex: 方法，这些方法是特殊命名过的，当 valueForKey: 寻找对应项时，会搜索如下方法：

- getNumbers, numbers 或 isNumbers: 系统会按顺序搜索这些方法，第一个找到的方法用来返回所请求的值 .
- countOfNumbers，-objectInNumbersAtIndex: 或-numbersAtIndexes: 上例用到的组合会让 KVC 返回一个代理数组
- countOfNumbers，-enumeratorOfNumbers，-memberOfNumbers: 这个组合会让 KVC 返回一个代理集合
- 命名为 _numbers，_isNumbers，或 isNumbers 的实例变量--KVC 会直接访问 ivar，一般最好避免这种行为。通过覆盖+accessInstanceVariablesDirectly 并返回 NO 可以阻止这种行为

对于可变容器属性，有两种选择，可以用下面的方法：

```objective-c
-insertObject:in<Key>AtIndex:
-removeObjectFrom<Key>AtIndex:
```

或者也可以通过调用 mutableArrayValueForKey: 或 mutableSetValueForKey: 返回一个特殊的代理对象。

<a id="markdown-kvc-和字典" name="kvc-和字典"></a>
### KVC 和字典

我们可以用 valueForKeyPath 来访问字典的任意一层，如下：

```objective-c
NSDictionary *dic = @{@"1":@" 一 ",@"2":@" 二 "};
NSString *string = [_contact valueForKeyPath:@"dic.1"];
```

<a id="markdown-集合的高阶消息传递" name="集合的高阶消息传递"></a>
### 集合的高阶消息传递

我们举一个例子来说明 :

```objective-c
NSArray *array = @[@"foo",@"bar",@"hello"];
NSArray *capitals = [array valueForKey:@"capitalizedString"];
NSLog(@"---%@",capitals);
```

打印结果：

```objective-c
---(
Foo,
Bar,
Hello)
```

方法 capitalizedString 被传递给 array 中的每一项，并返回一个包含结果的新 NSArray，这种被称为高阶消息传递，甚至可以用 valueForKeyPath 传递多个消息

```objective-c
NSArray *array = @[@"foo",@"bar",@"hello"];
NSArray *capitals = [array valueForKeyPath:@"capitalizedString.length"];
NSLog(@"---%@",capitals);
```

打印结果：

```objective-c
---(
3, 
3,
5)
```

<a id="markdown-集合的容器操作符" name="集合的容器操作符"></a>

### 集合的容器操作符

看下面的例子：

```objective-c
NSArray *array = @[@"foo",@"bar",@"hello"];    
NSInteger totalLength = [[array valueForKeyPath:@"@sum.length"]intValue];
NSLog(@"totalLength--%ld",(long)totalLength);
```

@sum 是一个操作符，可以对指定的属性 (length) 求和。除了 @sum，还有 @avg， @count ， @max ， @min 等其它很多操作符，这些操作符在处理 Core Data 时特别有用。

<a id="markdown-键值观察-kvo" name="键值观察-kvo"></a>
## 键值观察 KVO

KVO（Key-Value-Obersver）即键值监听，利用一个key来找到某个属性并监听其属性值得改变，当该属性发生变化时，会自动的通知观察者，这比通知中心需要 post 通知来说，简单了许多。其实这也是一种典型的观察者模式。

在 Cocoa 的 MVC 架构里，控制器负责让视图和模型同步。这一共有两步：当 model 对象改变的时候，视图应该随之改变以反映模型的变化；当用户和控制器交互的时候，模型也应该做出相应的改变。

KVO 的最大用处是能帮助我们让视图和模型保持同步。控制器可以观察视图依赖的属性变化。利用 KVO，在我们关注的属性发生变化时都会得到一次回调。

<a id="markdown-例子" name="例子"></a>
### 例子：

KVO 用 `addObserver:forKeyPath:options:context:` 开始观察，用 `removeObserver:forKeyPath:context:`  停止观察，回调总是  `observeValueForKeyPath:ofObject:change:context:`。看一个例子：

在 viewController 中添加一个 slider 控件

```objective-c
@property (readwrite, strong) NSNumber *now;
- (IBAction)countSlider:(UISlider *)sender {}
```

我们希望 Model 类 Contact 类可以监听 viewController 中 slider 控件的滑块值变化，所以我们需要在 Contact.m 中添加相应的监听代码 :

Contact.h

```objective-c
@property (nonatomic, readwrite, strong) id object;
@property (nonatomic, readwrite, copy) NSString *property;
```

Contact.m

```objective-c
- (BOOL)isReady {
    return (self.object && [self.property length] > 0);
}

- (void)update {
    NSLog(@"KVO--%@",self.isReady ?
    [[self.object valueForKeyPath:self.property] description]: @"");
}
- (void)removeObservation {
    if (self.isReady) {
      [self.object removeObserver:self forKeyPath:self.property];
    }
}
- (void)addObservation {
    if (self.isReady) {
      [self.object addObserver:self forKeyPath:self.property options:0 context:(void*)self];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ((__bridge id)context == self) {
      // 监听到后的处理逻辑
      [self update];
    }else {
      [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)setObject:(id)anObject {
    [self removeObservation];
    _object = anObject;
    [self addObservation];
    [self update];
}
- (void)setProperty:(NSString *)aProperty {
    [self removeObservation];
    _property = aProperty;
    [self addObservation];
    [self update];
}
- (void)dealloc {
    if (_object && [_property length] > 0) {
      [_object removeObserver:self forKeyPath:_property context:(void *)self];
    }
}
```

viewController.m

```objective-c
- (IBAction)countSlider:(UISlider *)sender {
    self.now = @(sender.value);
    [_contact setProperty:@"now"];
    [_contact setObject:self];
}
```

滑动滑块，打印出以下代码 :

```objective-c
KVO--0.5042373
KVO--0.5127119
KVO--0.5466102
KVO--0.5720339
... 省略
```

在 viewController 中，我们创建了一个属性 now, 并让 Contact 类观察此属性，滑块每次滑动，Contact 都会得到通知。只要用存取方法来修改实例变量，所有的观察机制都会自动生效，不需要付出任何成本。

<a id="markdown-手动设定实例变量的-kvo-实现监听" name="手动设定实例变量的-kvo-实现监听"></a>
### 手动设定实例变量的 KVO 实现监听

如果将一个对象设定成属性, 这个属性是自动触发 KVO 的,如果这个对象是一个实例变量,那么,这个 KVO 是需要我们自己来手动触发的。

自动触发是指类似这种场景：在注册 KVO 之前设置一个初始值，注册之后，设置一个不一样的值，就可以触发了。
而手动触发呢？
KVO 依赖于 NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey:  ，在一个被观察属性发生改变之前， willChangeValueForKey: 一定会被调用，这就 会记录旧的值。而当改变发生后，observeValueForKey:ofObject:change:context: 会被调用，继而 didChangeValueForKey: 也会被调用。如果可以手动实现这些调用，就可以实现“手动触发”了。

实现方法如下：

```objective-c
@interface BookData : NSObject {  
    NSString * bookName;  
}  
```

```objective-c
// 手动设定KVO
- (void)setAge:(NSString *)age{
    [self willChangeValueForKey:@"bookName"];
    _bookName = bookName;
    [self didChangeValueForKey:@"bookName"];
}
- (NSString *)bookName{
    return _bookName;
}
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    // 如果监测到键值为 bookName ,则指定为非自动监听对象
    if ([key isEqualToString:@"bookName"]){
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}
```

通常来讲，我们都不需要手动触发 KVO，只有在希望能控制回调的调用时机时才会这么做。大部分情况下，改变通知会自动调用。如果有一个 now 的属性，决定不要像下面这么写，这样的话，KVO代码会被调用两次。

```objective-c
- (void)setNow:(NSDate *)aDate {
   [self willChangeValueForKey:@"now"]; // 没有必要
   _now = aDate;
   [self didChangeValueForKey:@"now"];// 没有必要
}
```

还有另外一个场景需要手动触发 KVO，即自定义的 NSOperation。

> tips:关于 observeValueForKeyPath:ofObject:change:context: , 和 didChangeValueForKey: 到底谁先调用的问题，答案是 didChangeValueForKey:

<a id="markdown-kvo-实现原理" name="kvo-实现原理"></a>
### KVO 实现原理

KVO 的实现也依赖于 Objective-C 强大的 Runtime。当你观察一个对象时，一个新的类会动态被创建。这个类继承自该对象的原本的类，并重写了被观察属性的 setter 方法。自然，重写的 setter 方法会负责在调用原 setter方法之前和之后，通知所有观察对象值的更改。最后把这个对象的 isa 指针 ( isa 指针告诉 Runtime 系统这个对象的类是什么 ) 指向这个新创建的子类，对象就神奇的变成了新创建的子类的实例。

*[参考](http://tech.glowing.com/cn/implement-kvo/)*
