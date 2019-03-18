---
title: 消息机制-Delegate,NSNotification和Block
date: 2015-09-15
desc: iOS 开发
---

iOS 开发中，一个比较基础的知识点是不同的对象之间，如何相互通信，相互传值，通常广泛使用的有几种方式：Delegate,Notificatio,Block。

合理地使用这三种消息机制，有助于写出可复用以及优雅的代码。

<!--more-->

### Delegate

Delegate 其实是分为代理和协议这两种说法。

#### 代理

代理其实就是反转控制流，例如，它可以把当前类的行为反转给实现代理的类：

例如，JJTestModel 声明了一个名为 JJTestModelDelegate 的 代理（protocol）
JJTestModel.h
```
@class JJTestModel;

@protocol JJTestModelDelegate <NSObject>
@optional
- (void)model:(JJTestModel *)theModel didCreateByString:(NSString *)string;
@end

@interface JJTestModel : NSObject
@property (nonatomic, weak) id<JJTestModelDelegate> delegate;
- (void)start;
@end
```

通常代理都会以类名称+Delegate为命名方式，代理方法通常会把声明代理的类也传递过去。

另外，其中 @optional 表明下面的代理方法不是必须实现的。

JJTestModel.m

```
@implementation JJTestModel
- (void)start{
    if ([self.delegate respondsToSelector:@selector(JJTestModel:didCreateByString:)]) {
        [self.delegate JJTestModel:self didCreateByString:@"JJTestModel create"];
    }
}
@end
```

实现文件中，我们可以看到先利用 respondsToSelector 这个方法判断实现代理的类是否实现相应的代理方法，如果实现了，才进行方法调用。

JJMessageViewController 接受 JJTestModelDelegate 的委托，如下写法：
```
@interface JJMessageViewController ()<JJTestModelDelegate>
@end

@implementation JJMessageViewController{
    JJTestModel *_model;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _model = [[JJTestModel alloc]init];
    _model.delegate = self;
    [_model start];
}

- (void)JJTestModel:(JJTestModel *)model didCreateByString:(NSString *)string{
    NSLog(@"===== %@",string);
}
```

打印结果如下：

```
iosLearningDemo[48388:20936933] ===== JJTestModel create
```

还可以利用返回值反向传递：
```
@protocol JJTestModelDelegate <NSObject>
- (NSInteger)numberOfTimeModelShouldWait:(JJTestModel *)model;
@end
```

注意这个时候，我们没有写 @optional，表示默认为 @required，声明实现该 delegate 的类必须实现此方法，否则会有编译器警告。

JJTestModel.m
```
- (void)start{
    if ([self.delegate respondsToSelector:@selector(numberOfTimeModelShouldWait:)]) {
        NSInteger time = [self.delegate numberOfTimeModelShouldWait:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"=== %@",@(time));
        });
    }
}
```

JJMessageViewController.m
```
- (NSInteger)numberOfTimeModelShouldWait:(JJTestModel *)model{
    return 1;
}
```

打印结果如下：

```
iosLearningDemo[48649:20966574] === 1
```

如果只要在相对接近的两个模块间传递消息(只是一方对另外一方有引用)，delgate 可以灵活很直接的消息传递机制。

#### 协议

在理解这个概念之前，我们先看下 NSObject 的协议有哪些，下面列举了两个：

```
@protocol NSCopying

- (id)copyWithZone:(nullable NSZone *)zone;

@end

@protocol NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder; // NS_DESIGNATED_INITIALIZER

@end
```

比方说，如果又一个类需要支持拷贝功能，那这个类就要实现 NSCopying 这个协议。

```
@implementation JJTestModel{
    _Bool value;
}

- (id)copyWithZone:(NSZone *)zone{
    JJTestModel *model = [[JJTestModel allocWithZone:zone] init];
    model->value = YES;
    return model;
}
```

为什么 NSObject 会这么设计呢？这是因为 NSObject 无法为你继承 NSObject 的类实现 copy 的功能，NSObject 无法知道子类的任何对象（例如 JJTestModel 中的 value），任何方法，所以 NSObject 无法实现 copy 的功能，所以它把这个功能转移给声明实现该协议的人。

此外，这种模式还可以实现匿名类的功能：

像 NSMutableDictionary 里面有一个方法如下：
```
- (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;
```

这个方法中 aKey 不是具体的一个类，而是一个遵守了 NSCopying 协议的类，这个类甚至可以是一个控制器。因为，setObject：forKey 中，key 需要进行一次 copy 操作，只要遵守了 NSCopying 协议的类都可以进行这个操作。
通常这种设计模式用于类的继承，举例：

创建如下的类：

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fgirrldjc1j307y03jgle.jpg)

JJPet.h
```
@protocol JJPetDelegate <NSObject>
- (NSString *)howThink;
@end

@interface JJPet : NSObject
- (void)think;
@end
```

JJPet.m
```
@interface JJPet ()
@property (nonatomic, weak) id<JJPetDelegate> delegate;
@end

@implementation JJPet

- (void)think{
    if ([self.delegate respondsToSelector:@selector(howThink)]) {
    	//我是 pet（宠物） 类，我并不知道真正的 pet（宠物） 在想什么。
        NSString *string = [self.delegate howThink];
        NSLog(@"我在想：%@",string);
    }
}

@end
```

下面是实现了协议的类：
JJCat.m
```
@implementation JJCat
- (NSString *)howThink{
    return @"你们这些愚蠢的人类";
}
@end
```

JJDog.m
```
@implementation JJDog
- (NSString *)howThink{
    return @"主人，我要亲亲";
}
@end
```

这个例子应该一目了然了吧，所以不做过多解释了。

### Notification

NSNotificationCenter 是一个单例。要在代码中的两个不相关的模块中传递消息时，通知机制是非常好的工具。通知机制广播消息，当消息内容丰富而且无需指望接收者一定要关注的话这一招特别有用。

比如我们可以接收一个 UIKeyboardWillShowNotification 来监听键盘的出现 :

```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
```

在相应的地方注销通知：

```
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self
	name:UIKeyboardWillShowNotification
	object:nil];
}
```

发送通知使用以下方法：

```
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject;
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;
```

通知可以用来发送任意消息，甚至可以包含一个 userInfo 字典。通知的独特之处在于，发送者和接收者不需要相互知道对方，所以通知可以被用来在不同的相隔很远的模块之间传递消息。这就意味着这种消息传递是单向的，我们不能回复一个通知。

### block

Block 首次出现在 OSX10.6 和 iOS4 平台上。Block 通常可以完全替代 delegate 其作为代理消息传递机制的角色。它类似于 C 上的函数指针，可以将代码块像对象一样传递，同时可以访问上下文，使代码更紧凑。不用像 delegate 一样生成很多局部变量。

#### 语法

block 很好，但是它的语法很难记。。

1：创建 block 的语法为：returnType (^ blockName)(parameterTypes)

其中 blockName 是 block 的名称（竟然在中间，简直反人类），returnType 是返回类型，parameterTypes 是参数。可以说，这三个参数和一个函数一摸一样。

例如
```
@property (nonatomic, copy) int(^BlockName)(int a);
```

调用方式：
```
self.BlockName = ^(int a){
	return 1;
};
```

2：作为方法参数又是另外一种写法(BlockName 到最右边了)：
(returnType (^ )(parameterTypes)) blockName :

```
- (void)testBlock:(int(^)(int a))BlockName{
    
}
```

调用：
```
-(void)test {
	[self testBlock:self.BlockName];
	[self testBlock:^(int a){
        return 1;
   }];
}
```

3：typedef 特性可以让我们从泥潭中挽救出来：

Block 可以看作一种特殊语法的 “objects” 。通常我们 typedef 一个 block 来存储它：

```
//typedef 这个 block 为 BlockName 类型：
typedef int(^BlockName)(int a);
```

然后就可以这样子传递参数了，简直不能更畅快：
```
- (void)testBlock2:(BlockName)blockName{
    NSLog(@"----- %@",blockName);
}
```

#### 注意事项

1：block 在实现时会对 block 外的变量进行只读拷贝，在 block 块内使用该只读拷贝。此时， block 是默认将其复杂到其数据结构中来实现访问的。

如果我们想要让 block 修改或同步使用 block 外的变量，就需要用 __block 来修饰 outside 变量。此时，block 是复制其引用地址来实现访问和修改的。

```
__block NSString *string = @"string";
[self testBlock2:^int(int a) {
   string = @"";        
   return 1;
}];
```

2：使用 weak–strong dance 技术来避免循环引用

具体可见 [《内存管理-ARC下的内存泄漏》](http://jieyuanz.com/2015/%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86-ARC%E4%B8%8B%E7%9A%84%E5%86%85%E5%AD%98%E6%B3%84%E6%BC%8F/)一文。

#### block 内存管理分析

一共有3种类型的block：

_NSConcreteGlobalBlock 全局的静态block，不会访问任何外部变量。
_NSConcreteStackBlock 保存在栈中的block，当函数返回时会被销毁。
_NSConcreteMallocBlock 保存在堆中的block，当引用计数为0时会被销毁。

NSConcreteGlobalBlock, 这种不捕捉外界变量的 block 是不需要内存管理的,这种 block 不存在于 Heap 或是Stack 而是作为代码片段存在,类似于单例。例如这样：

```
void (^block)() = ^{
    NSLog(@"this is a block");
};
```

NSConcreteStackBlock：
需要涉及到外界变量的 block 在创建的时候是在 stack 上面分配空间的, 也就是一旦所在函数返回,则会被摧毁。这就导致内存管理的问题,如果我们希望保存这个block或者是返回它,如果没有做进一步的 copy 处理,则必然会出现问题。

NSConcreteMallocBlock：
因此为了解决 block 作为 Stack object 的这个问题, 我们最终需要把它拷贝到堆上面来。而此时 NSConcreteMallocBlock 扮演的就是这个角色。拷贝到堆后,block的生命周期就与一般的OC对象一样了,我们通过引用计数来对其进行内存管理。

ARC 帮助我们完成了 copy 的工作, 在ARC下, 将不会有 NSConcreteStackBlock 类型的 block。

即使你声明的修饰符是strong,实际上效果是与声明为copy一样的。即，你不需要手动 copy 。手动 copy 只是浪费资源的一种行为。因此，在 ARC 下,我们可以将 block 看做一个正常的OC对象,与其他对象的内存管理没什么不同。



