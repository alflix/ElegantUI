---
title: 内存管理-什么是ARC
date: 2015-06-02
desc: iOS 开发
---

### 理解引用计数机制

iOS 中的内存管理，是通过一种“引用计数”的机制来管理的。

在引用计数的机制下，每个对象都有一个计数器，可递增递减，用以表示当前有多少事物想让该对象继续保留下去。

NSObject 协议声明了三个方法用于操作计数器：

- retain: 递增计数器
- release: 递减计数器
- autorelease : "autorelease pool" 清理时，再递减计数器。

<!--more-->

#### retain 和  release

```
NSNumber *number = @1;//number 引用计数递增 1
[array addObject:number];//number 引用计数递增 1
```

对象 A 通过以 alloc，copy，mutableCopy，new 开头的方法被创建出来时，会自动执行 retain ，引用计数递增。当对象 B 引用了对象 A 时，被引用者对象 A 递增。当对象 A 的引用计数为 0 时，对象会被系统回收。

```
NSMutableArray *object = [NSMutableArray array];// 计数为 0
[object retain];// 计数为 1,注意这里需要调用 retain ，因为 object 的初始化方法为 array。而不是以 alloc，copy，mutableCopy，new 开头的方法。

NSNumber *number = [[NSNumber alloc]initWithInt:1];// number 计数为 1
[object addObject:number];// number 计数为 2，object 计数为 1
[number release];// number 计数为 1，object 计数为 1
[object release];// object 计数为 0
```

如上，如果我们不需要对象了，就对它调用 release ，然而，此时 number 的计数仍然为 1，number 对象仍然存活。为了避免不经意间使用了无效指针，调用完 release 我们可以手动清空指针。（通常都是针对局部变量）

```
number = nil;
```

我们知道，程序在生命期间会创建很多对象，这些对象都相互联系着。所以，这些相互联系的对象就构成一个对象树，这个对象树的根节点是 UIApplocation 对象，它是程序启动时创建的单例。

#### 属性存取方法中的内存管理

设置方法将保留新值，释放旧值，然后更新变量。如下：(该例子是针对 strong 声明的属性)

```
- (void)setFoo:(id)foo{
	[foo retain];
	[_foo release];
	_foo = foo;
}
```

#### autorelease

```
- (NSString *)temp{
	NSString *tmp = @"A";// 计数为 1
	return tmp;
}
```

如上，返回的 temp 对象的引用计数比我们期望的要多 1，因为只有 retain，没有对应的 release 操作。然而，我们又不能在方法中释放 temp，否则这个方法就没有存在的意义了。在方法外仔释放也不行，因为方法名称的原因（后面会讲）。

所以这里我们使用 autorelease，它会在稍后释放对象，从而给调用者留下足够的时间，又不会因为没有释放而造成内存泄露。具体时间是当前线程的下一次时间循环。

```
- (NSString *)temp{
	NSString *tmp = @"A";// 计数为 1
	return [tmp autorelease];
}
```

当然，如果要持有这个 temp 对象的话，比如说设置给实例变量，那就需要 retain 操作：

```
_instance = [[self temp] retain];
/...
[_instance release];
```

#### 理解命名规则

使用以下名称开头的方法意味着，使用这个方法生成的对象，自己会持有该对象，也就是说会自动 retain。

- alloc
- copy
- mutableCopy
- new

例如上面说的：

```
NSNumber *number = [[NSNumber alloc]initWithInt:1];// 计数为 1
```

而像 [NSMutableArray array] 这种初始化对象的方法则不会自动 retain，我们需要自己 retain 一下：（注意，这里讨论的是 MRC 环境下）

```
_object = [NSMutableArray array];
[object retain];//
```

如果是我们自己写的初始化方法，也是同样如此：

```
//以 alloc 开头
- (id)allocObject{
	id object = [NSObject alloc] init];
	return obj;
}

//不以 alloc 开头，使用这种方法需要调用方自己 retain 一下
- (id)object{
	id object = [NSObject alloc] init];
	[object autorelease];
	return obj;
}
```

### ARC

使用 ARC 时，引用计数还是会执行的，只不过是 ARC 为你自动添加的，即上面所说的 retain／release／ autorelease 方法。在对象被创建时 retain count +1，在对象被 release 时 retain count -1. 当 retain count 为 0 时，销毁对象。 程序中加入 autoreleasepool 的对象会由系统自动加上 autorelease 方法，如果该对象引用计数为 0，则销毁。 因为 ARC 会自动执行这些方法，所以在 ARC 下调用这些方法是非法的，会产生编译错误。

使用 ARC 时，创建对象必须附加所有权修饰符，一共有4种：

```
__strong 修饰符
__weak 修饰符
__unsafe_unretained 修饰符
__autoreleasing 修饰符
```

#### __strong 修饰符:

__strong 修饰符 id 类型和对象类型默认的所有权修饰符。

```
id __strong object = [[NSObject alloc]init];
//等价
//id object = [[NSObject alloc]init];
```

为了理解 __strong 的作用，我们先看下 MRC 如何写的：

```
id object = [[NSObject alloc]init];// alloc 会有一次 retain
[object release];//即将离开作用域时，对其进行 release
```
可以看出，使用 __strong 修饰符的对象会在对象离开作用域时被 release。它表示对对象的“强引用”，持有强引用的变量在超出作用域时被废弃。

同时，对于使用非 alloc，copy，mutableCopy，new 开头的方法初始化的对象，ARC 会自动对其进行一次 retain 操作。就像我们前面说的 NSMutableArray array。也就是说，通过 __strong 修饰符，我们再也不用使用 retain 和 release 了。

> cheers！🍻

#### __weak 修饰符:

然而，不要高兴的太早，仅仅通过 __strong 修饰符是不够的，因为对象之间可能会存在循环引用的问题。如下：

```
id A = [[NSObject alloc]init];//引用计数为 1
id B = [[NSObject alloc]init];//引用计数为 1
[A setObject: B];B 引用计数为 2
[B setObject: A];A 引用计数为 2
//超出作用域，A 引用计数为 1（自动执行了release），并等待着 B 的引用计数为 0 时 将自己的引用计数减 1
//超出作用域，B 引用计数为 1（自动执行了release），并等待着 A 的引用计数为 0 时 将自己的引用计数减 1
//相互等待，进入死循环。结果是无法释放。
```

由于 A 和 B 之间相互强引用，如上面的分析，它们都无法释放，这会造成内存泄漏，所谓内存泄漏。是指应当废弃的对象在超出其生存周期之后仍然继续存在。

__weak 修饰符的作用就是在对象超出作用域的时刻将其设置为 nil，这样就不会有内存泄漏的问题了。

```
id __weak object = [[NSObject alloc]init];
```
既不 retain, 也不 release。但出了作用域 set nil。所以你这么写的话会看到编译器发出警告：

![](https://ws3.sinaimg.cn/large/006tNbRwgy1fggj1pmrhjj30le02hq2t.jpg)

使用 __weak 修饰的对象在 setter 方法中，需要对传入的对象不进行引用计数加1的操作。简单来说，就是对传入的对象没有所有权。

```
id A = [[NSObject alloc]init];//引用计数为 1
id __weak B = [[NSObject alloc]init];//引用计数为 0
```

#### __unsafe_unretained 修饰符

unsafe_unretained 修饰符是 iOS5 以下不支持 __weak 修饰符而使用来取代 __weak 修饰符的，正如其名，它是不安全的。因为在对象超出作用域的时刻不会将其设置为 nil，如果访问该对象，就有可能 crash。

```
//既不 retain, 出了作用域也不 release。也不会 set nil。
id __unsafe_unretained object = [[NSObject alloc]init];
```

#### __autoreleasing 修饰符

对象赋值给附有 __autoreleasing 修饰符的变量等价于在 MRC 下调用对象的 autorelease 方法，即使用 __autoreleasing 修饰符的对象会被自动注册到 autoreleasepool 中，如下：

```
@autoreleasepool {
        id __autoreleasing object = [[NSObject alloc]init];
}
```
当@autoreleasepool 清空时，__autoreleasing 修饰的对象会被设置为 nil。

实际上，使用 __autoreleasing 修饰符修饰的对象很罕见，因为如果一个对象作为函数的返回值的话，编译器是会自动将其注册到 autoreleasepool 中的。如下：

```
+ (id)array{
    id object = [[NSMutableArray alloc]init];
    return object;
}
```
object 会被自动注册到 autoreleasepool 中。这时候使用 __autoreleasing 修饰符没有意义，这种情况下，使用 __strong 修饰符也是可以起到同样的作用的。

而使用 __weak 修饰符修饰的对象也会被自动注册到 autoreleasepool 中，因为 __weak 修饰符只有对象的弱引用，在访问对象的过程中，该对象可能被废弃，所以它会自动注册到 autoreleasepool 中以防止访问带废弃的对象。

那 __autoreleasing 修饰符是用来干什么的呢？通常它是用来修饰 id 的指针：id *obj，例如 AFNetworking 中的一个方法，progress 作为一个 id 指针使用了 __autoreleasing 修饰符：

```
- (void)loadRequest:(NSURLRequest *)request
           progress:(NSProgress * __autoreleasing *)progress
            success:(nullable NSString * (^)(NSHTTPURLResponse *response, NSString *HTML))success
            failure:(nullable void (^)(NSError *error))failure;
```

或者我们常见的 NSError ** 指针：

```
- (BOOL)performOperationWithError:(NSError *__autoreleasing *)error{
	*error = [NSError errorWithDomain:MyAppDomain code:errorCode userInfo:nil];
	return NO;
}
```

这种修饰符是默认的，你也可以不显式写出来。那么，问题来了，为什么对象指针就要使用 __autoreleasing 呢？ 首先，上面的方法我们是这么用的：

```
NSError *error = nil;
BOOL result = [obj performOperationWithError:&error];
```

如上，error 对象作为一个指针传入 execute 方法中，也就是说 error 其实离开了 performOperationWithError 的作用域后仍然存在，而按照内存管理的命名方式，即我们前面讲的，使用 alloc，copy，mutableCopy，new 开头的方法可以自己生成并持有对象，其他方法并不可以。而 performOperationWithError 并不是使用 alloc，copy，mutableCopy，new 开头的，所以它不能持有对象。（命名方法并不是无所谓的，使用 alloc，copy，mutableCopy，new 开头的方法编译器才会自动帮你调用 release 方法）。因此，它必须使用 __autoreleasing 修饰符，于是，上面的代码编译器会自动处理为如下：

```
NSError *error = nil;
NSError __autoreleasing *tmp = error;
BOOL result = [obj performOperationWithError:&tmp];
error = tmp;
```

相当于在方法外面注册到 autoreleasepool中。Bingo！

### 属性声明

@Property 是声明属性的语法，它可以快速方便的为实例变量创建存取器，并允许我们通过点语法使用存取器。

>存取器（accessor）：指用于获取和设置实例变量的方法。用于获取实例变量值的存取器是 getter，用于设置实例变量值的存取器是 setter。

如下：
```
@interface Car : NSObject

@property(nonatomic,strong) NSString *carName;

@end

```
m文件中会自动生成以下代码，@synthesize 声明语句和存取方法
```
@synthesize carName = _carName;//可以自己显式指定其他名称
@implementation Car

// setter
- (void)setCarName:(NSString *)newCarName{
    carName = newCarName;
}
// getter
- (NSString *)carName{
    return carName;
}
@end
```

我们可以注意到 @property 中有一些关键字，它们都是有特殊作用的，比如上述代码中的 nonatomic，strong。它们分为三类，分别是：原子性，存取器控制，内存管理它就是我们说的属性声明。 先讲内存管理。

#### 内存管理

理解了上面的修饰符，内存管理属性声明就很好理解了，只要理清它们的对应关系。

- assign : __unsafe_unretained
- strong : __strong
- copy : __strong（但被赋值的是被复制的对象）
- weak : __weak

assign：

适用于基本数据类型。赋值特性，不涉及引用计数，弱引用，仅仅是基本数据类型变量 (scalar type，例如 CGFloat 或 NSlnteger 等) 在 setter 方法中的简单赋值操作。在基本数据类型中是默认的，不显式声明也可以。

assign 其实也可以用来修饰对象，那么我们为什么不用它呢？因为相当于用 __unsafe_unretained。 被 __unsafe_unretained 修饰的对象在释放之后，指针的地址还是存在的，也就是说指针并没有被置为 nil。如果在后续的内存分配中，刚好分到了这块地址，程序就会崩溃掉。 

strong：

强引用，使用之后，计数器+1。

copy：

表示拷贝特性，setter 方法将传入对象复制一份，需要完全一份新的变量时。相当于 strong，只不过在编译器生成的 setter 方法中会额外将传入对象复制一份。如果你自己实现了 setter 方法，不要忘了对变量进行 copy 操作，否则 copy 的声明就没有作用了。

weak：

弱引用 ，weak 修饰的对象在释放之后，指针地址会被置为 nil，可以有效的避免野指针，其引用计数为 1。在 ARC 中 , 在有可能出现循环引用的时候 , 此时通过引用计数无法释放指针， 往往要通过让其中一端使用 weak 来解决，比如 : delegate 代理属性。自身已经对它进行一次强引用 , 没有必要再强引用一次 , 此时也会使用 weak, 自定义 IBOutlet 控件属性一般也使用 weak；当然，也可以使用 strong。

weak 此特质表明该属性定义了一种“非拥有关系” (nonowning relationship)。为这种属性设置新值时，设置方法既不保留新值，也不释放旧值。此特质同 assign 类似， 然而在属性所指的对象遭到摧毁时，属性值也会清空 (nil out)。 。

#### 存取器控制

readwrite：

可读可写特性，需要生成 getter 方法和 setter 方法时使用。有时候为了语意更明确可能需要自定义访问器的名字：

```
@property (nonatomic,getter = isHidden ) BOOL hidden;
```

readonly：
只读特性，只会生成 getter 方法，不会生成 setter 方法，不希望属性在类外改变。

#### 原子性

nonatomic：

非原子操作，不加同步，多线程访问可提高性能，但是线程不安全的。决定编译器生成的 setter getter 是否是原子操作。

atomic：

原子操作，与 nonatomic 相反，系统会为 setter 方法加锁。 具体使用 @synchronized(self){//code } 。它是线程安全，需要消耗大量系统资源来为属性加锁 。（实际上并没有 atomic，只不过当没有 nonatomic 时就是 atomic，不过你要是写上去编译器也不会报错）。

### 总结
MRC 下内存管理的缺点： 

1. 当我们要释放一个堆内存时，首先要确定指向这个堆空间的指针都被 release 了。（避免提前释放） 
2. 释放指针指向的堆空间，首先要确定哪些指针指向同一个堆，这些指针只能释放一次。（MRC 下即谁创建，谁释放，避免重复释放） 
3. 模块化操作时，对象可能被多个模块创建和使用，不能确定最后由谁去释放。 
4. 多线程操作时，不确定哪个线程最后使用完毕。

所以，让我们拥抱 ARC 的时代！（手动滑稽）

