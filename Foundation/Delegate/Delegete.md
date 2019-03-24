### Delegate

Delegate 其实是分为代理和协议这两种说法。

#### 代理

代理其实就是反转控制流，例如，它可以把当前类的行为反转给实现代理的类：

例如，JJTestModel 声明了一个名为 JJTestModelDelegate 的 代理（protocol）
JJTestModel.h
```objective-c
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

```objective-c
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
```objective-c
@interface JJMessageViewController ()<JJTestModelDelegate>
@end

@implementation JJMessageViewController{
    JJTestModel *_model;
}

- (void)viewDidLoad{Update 
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
```objective-c
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

```objective-c
iosLearningDemo[48649:20966574] === 1
```

如果只要在相对接近的两个模块间传递消息(只是一方对另外一方有引用)，delgate 可以灵活很直接的消息传递机制。

#### 协议

在理解这个概念之前，我们先看下 NSObject 的协议有哪些，下面列举了两个：

```objective-c
@protocol NSCopying

- (id)copyWithZone:(nullable NSZone *)zone;

@end

@protocol NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder; // NS_DESIGNATED_INITIALIZER

@end
```

比方说，如果又一个类需要支持拷贝功能，那这个类就要实现 NSCopying 这个协议。

```objective-c
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
```objective-c
- (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;
```

这个方法中 aKey 不是具体的一个类，而是一个遵守了 NSCopying 协议的类，这个类甚至可以是一个控制器。因为，setObject：forKey 中，key 需要进行一次 copy 操作，只要遵守了 NSCopying 协议的类都可以进行这个操作。
通常这种设计模式用于类的继承，举例：

创建如下的类：

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fgirrldjc1j307y03jgle.jpg)

JJPet.h
```objective-c
@protocol JJPetDelegate <NSObject>
- (NSString *)howThink;
@end

@interface JJPet : NSObject
- (void)think;
@end
```

JJPet.m
```objective-c
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
```objective-c
@implementation JJCat
- (NSString *)howThink{
    return @"你们这些愚蠢的人类";
}
@end
```

JJDog.m
```objective-c
@implementation JJDog
- (NSString *)howThink{
    return @"主人，我要亲亲";
}
@end
```

这个例子应该一目了然了吧，所以不做过多解释了。



