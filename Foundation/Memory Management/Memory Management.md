这篇文章的示例代码你可以在 [这里](https://github.com/jieyuanz/ios_demo/blob/master/iosLearningDemo/iosLearningDemo/Memory/JJMemoryViewController.m) 找到。

在讲内存管理之前，我们需要先理解 heap 和 stack 的概念。

在理解 heap 和 stack 的概念之前，我们需要先理解指针的概念。

<!--more-->

### 指针

指针最早是在 C 语言中出现的，指针可以简单地理解为内存的地址。后来众多面向对象的语言例如 Java，Objective-C 也包含了这个概念，但 Java，Objective-C 上的指针实际上是受限制的指针，之所以说“受限制”，是因为不能进行指针运算（比如 p + 1 指向下一个元素之类的）。虽然缺少了灵活性，但却大大减少了程序出错的概率。你可以把 Java，Objective-C 上的指针理解为“引用”。不过，在下面的讨论，我们仍然以指针这个名称来说明。

#### 位，字节......

在讲指针之前，先普及一些小的知识点，比如位，字节，变量类型等。

位（bit），就是电路中的逻辑门，有 0 和 1 两种状态，计算机的内存中由数以亿万计的位组成，例如 00000000000000011111111....(亿万个0或1)，但是一个位只能表示两种状态，所以它最多只能表示 0 和 1 两个数，所以单独的位意义不大。

所以计算机把 8 个位合并为一个字节（byte）。

```
    00000000 00000000 00000000 00000000 00000000 00000000 ....
        |       |        |         |       |        |
        0     	1        2         3       4        5    ....
```

如上，我们把每 8 个位合并为一个字节，每个字节都有一个编号，我们把这些编号称之为地址，类似于我们家的门牌号就是我们家的地址。

> 字节是如何编号的呢？有没有想过这个问题？

也就是说一个字节有 256 种组合方式， 256 种组合方式刚好足够用来表示 26 个英文字母及其相应的大小写，标点符号，0～9，我们把这些称之为符号，即 character。

> 注意，我们上面所指的 0 ～ 9 指的是字符的概念，而不是指具体的数字。

因此， C 语言中定义了一种类型，char 类型，置占一个字节。

#### 为什么需要指针

想象一下如果没有指针，我们的程序应该怎么写？

给一个指针取地址符，意思就是指针的指针，与C、C++中的概念是一致的。 

```
              Memory address    Object
              --------------    ---------
              0
              1
              2
              3
              4
              ...
pointer ----> 10523             myObject1
              10524
              ...

```

char c; //栈上分配
char *p = new char[3]; //堆上分配，将地址赋给了p;

在 编译器遇到第一条指令时，计算其大小，然后去查找当前栈的空间是大于所需分配的空间大小，如果这时栈内空间大于所申请的空间，那么就为其分配
内存空间，注 意：在这里，内存空间的分配是连续的，是接着上次分配结束后进行分配的．如果栈内空间小于所申请的空间大小，
那么这时系统将揭示栈溢出，并给出相应的异常信息。
编译器遇到第二条指令时，由于p是在栈上分配的，所以在为p分配内在空间时和上面的方法一样，但当遇到new关 键字，那么编译器都知道，
这是用户申请的动态内存空间，所以就会转到堆上去为其寻找空间分配．大家注意：堆上的内存空间不是连续的，
它是由相应的链表将其 空间区时的内在区块连接的，所以在接到分配内存空间的指定后，它不会马上为其分配相应的空间，
而是先要计算所需空间，然后再到遍列整个堆（即遍列整个链的 节点），将第一次遇到的内存块分配给它．
最后再把在堆上分配的字符数组的首地址赋给p.，这个时候，大家已经清楚了，p中现在存放的是在堆中申请的字符数组的首地址，
也就是在堆中申请的数组的地址现在被赋给了在栈上申请的指针变量p

### 内存区域

heap 和 stack 是内存管理的两个概念。这里指的不是数据结构上面的堆与栈，这里指的是内存的分配的两个区域：堆区和栈区。（不过这两者之间确实是有相似之处）。

iOS 中某个 app 使用的内存不是一段连续的统一分配空间，而是分布在不同的内存区域，如下：

栈区（stack）：一个线程会分配一个 stack，当一个函数被调用时，例如 app 最开始运行函数 main()  ，一个 stack frame (栈帧) 就会被压到 stack 里。里面包含这个函数涉及的参数 , 局部变量 , 返回地址等相关信息。当执行第二个函数时，又一个 stack frame 会被压到 stack 里。当函数返回后 , 这个栈帧就会被销毁。而且类似数据结构中的 stack ，栈区是一种后进先出（LIFO ）结构 。这一切都是自动的，我们不需要管理栈区变量的内存；栈区地址从高到低分配。

堆区（heap）：我们使用 alloc/new/copy/mutableCopy 创建一个对象时，堆区就会分配一段内存，这部分内存需要我们进行管理，简单来讲 ARC 时代就是通过我们主动声明对象创建的内存管理语义（strong，weak，copy，assign 等），然后编译器在编译的时候自动添加 retain、release、autorelease 等方法，这些方法会通过一种叫作“引用计数”的方式进行内存管理，具体我们后面再讲。堆区的地址是从低到高分配。

全局区 / 静态区（static）：包括两个部分：全局未初始化区（BSS 区） 、全局初始化区（数据区）。也就是说，全局区 / 静态区 在内存中是放在一起的，初始化的全局变量和静态变量在一块区域，未初始化的全局变量和未初始化的静态变量在相邻的另一块区域；eg：int a ; 未初始化的。int a = 10; 已初始化的。

常量区：常量字符串就是放在这里。

代码区：存放 App 二进制代码，代码段需要防止在运行时被非法修改，所以只准许读取操作，而不允许写入（修改）操作——它是不可写的。

![](https://ws3.sinaimg.cn/large/006tNc79gy1fj7iam4mc1j30db0epa9z.jpg)

每个 Objective-C 对象都是指向某块内存数据的指针，所以在声明变量时，类型后面要跟一个“*”字符：

```
NSString *pointerVariable = @"someString";
```

pointerVariable 作为一个局部变量，它是栈上的一个指针变量，@"someString" 是堆上的内存对象，pointerVariable 变量内存放着堆上对象的内存地址。

### 为什么是 Stack 和 Heap？

首先所有的 Objective-C 对象都是分配在 heap 的。在 OC 最典型的内存分配与初始化就是这样的。

```
NSObject *obj = [[NSObject alloc] init];
```

一个对象在 alloc 的时候，就在 Heap 分配了内存空间。
stack 对象通常有速度的优势，而且不会发生内存泄露问题。那么为什么 OC 的对象都是分配在 heap 而不是 stack 呢？
原因在于：

- stack 对象的生命周期所导致的问题。例如一旦函数返回，则所在的 stack frame 就会被摧毁。那么此时返回的对象也会一并摧毁。这个时候我们去 retain 这个对象是无效的。因为整个 stack frame 都已经被摧毁了。简单而言，就是 stack 对象的生命周期不适合 Objective-C 的引用计数内存管理方法。
- stack 对象不够灵活（LIFO），不具备足够的扩展性。创建时长度已经是固定的 , 而 stack 对象的拥有者也就是所在的 stack frame.

### stack 和 heap 的工作原理

栈区（stack）：栈区就是函数运行时的内存，栈区中的变量由编译器负责分配和释放，内存随着函数的运行分配，随着函数的结束而释放，由系统自动完成。只要栈的剩余空间大于所申请空间，系统将为程序提供内存，否则将报异常提示栈溢出。有 2 种分配方式：静态分配和动态分配。静态分配是编译器完成的，比如局部变量的分配。动态分配由 alloc 函数进行分配，但是栈的动态分配和堆是不同的，他的动态分配是由编译器进行释放，无需我们手工实现。

堆区（heap）：系统使用一个链表来维护所有已经分配的内存空间，当系统收到程序的申请时，会遍历该链表，寻找第一个空间大于所申请空间的堆结点，然后将该结点从空闲结点链表中删除，并将该结点的空间分配给程序，另外，对于大多数系统，会在这块内存空间中的首地址处记录本次分配的大小，这样，代码中的 delete 语句才能正确的释放本内存空间。另外，由于找到的堆结点的大小不一定正好等于申请的大小，系统会自动的将多余的那部分重新放入空闲链表中。



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

即便有了 ARC，如果不注意使用的话，也是有可能导致内存泄露的。内存泄漏问题一直是项目开发中的一大问题，下面我们列举出几种常见的内存泄漏场景和解决方案。

### 内存泄漏场景

#### 两个类循环引用

JJMemoryObject.h:

```
@class JJMemoryViewController;
@interface JJMemoryObject : NSObject<NSCopying>
@property (nonatomic, strong) JJMemoryViewController *vc;
@end
```

JJMemoryViewController.m

```
#import "JJMemoryViewController.h"
#import "JJMemoryObject.h"

@implementation JJMemoryViewController{
    JJMemoryObject *_object;
}
```

如上的代码，JJMemoryObject 强引用了 JJMemoryViewController，JJMemoryViewController 也强引用了 JJMemoryObject，这样就导致了循环引用，ARC 无法回收这两个对象，从而导致内存泄露。

可以把其中一个 strong 修改为 weak:

```
@property (nonatomic, weak) JJMemoryViewController *vc;
```

或者在其中一个类中的 dealloc 做以下操作：

```
- (void)dealloc{
    _object = nil;
    NSLog(@"JJMemoryViewController dealloc");
}
```

#### delegate 循环引用问题

delegate 循环引用问题比较基础，原理和两个类循环引用一样，这里特地拿出来讲是因为 delegate 比较常用。具体可看下面的示例图。只需注意将代理属性修饰为 weak 即可。

```
@protocol JJMemoryObjectDelegate <NSObject>
@end

@interface JJMemoryObject : NSObject<NSCopying>
@property (nonatomic, weak) id<JJMemoryObjectDelegate> delegate;
```

![](https://ws1.sinaimg.cn/large/006tNc79gy1fj7jqx0vtfj30gr0710so.jpg)

weak 在这里还可以表达一种非拥有关系，即 delegate 属性并不是创建它的类所拥有的，而是实现 delegate 协议的类所拥有的。

#### Block

我们从一个例子开始讲起。
有这样一个场景：在类 JJMemoryObject 中有一个获取 data 的回调 Block：

JJMemoryObject.h:

```
typedef void(^JJMemoryObjectCompletionHandler)(NSData *data);
@interface JJMemoryObject : NSObject<NSCopying>
- (void)loadDataWithCompletionHandler:(JJMemoryObjectCompletionHandler)completion;
@end
```

JJMemoryObject.m:

```
#import "JJMemoryObject.h"
@interface JJMemoryObject ()
@property (nonatomic, copy) JJMemoryObjectCompletionHandler completion;
@end
@implementation JJMemoryObject
- (void)loadDataWithCompletionHandler:(JJMemoryObjectCompletionHandler)completion{
    _completion = completion;//注意，这里编译器会自动执行 copy 操作
}
//假设类调用了这个方法，通知给 block
- (void)p_requestCompleted{
    if (_completion) {
        NSData *data = nil;
        _completion(data);
    }
}
```

某个类中使用网络工具类发送请求并处理回调,JJMemoryViewController.m

```
@implementation JJMemoryViewController{
    JJMemoryObject *_object;
    NSData *_loadData;
}

- (void)downloadData{
    [_object loadDataWithCompletionHandler:^(NSData *data) {
        _loadData = data;
    }];
}
```

很明显在使用 block 的过程中形成了循环引用：self 持有 _object， _object 持有 block，block 持有 self。三者形成循环引用，内存泄露。

下面这种写法也会造成循环引用，不过只有 _object 持有 block；block 持有 self 一个循环。

JJMemoryObject.m

```
+ (id)shareInstance{
    static dispatch_once_t onceToken;
    static JJMemoryObject *object = nil;
    dispatch_once(&onceToken, ^{
        object = [[JJMemoryObject alloc]init];
    });
    return object;
}

+ (void)easyLoadDataWithCompletionHandler:(JJMemoryObjectCompletionHandler)completion{
    JJMemoryObject *object = [JJMemoryObject shareInstance];
    object.completion = completion;//_object 持有 block
}

```

JJMemoryViewController.m

```
- (void)easyDownloadData{
    [JJMemoryObject easyLoadDataWithCompletionHandler:^(NSData *data) {
        _loadData = data;//block 持有 self
    }];
}

```

解决方案有两种：

1:将 block 回调完成之后，将 block 对象置为 nil，消除引用，打破循环引用：

JJMemoryObject.m

```
- (void)p_requestCompleted{
    if (_completion) {
        NSData *data = nil;
        _completion(data);
//        _completion = nil;
    }
}


```

2:将强引用转换成弱引用，打破循环引用。

```
- (void)downloadData{
    __weak typeof(self) weakSelf = self;
    [_object loadDataWithCompletionHandler:^(NSData *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_loadData = data;
    }];
}

```

如上的代码，我们先创建一个由  __weak  修饰符修饰的局部变量，这里变量指向当前的 self。 其中的 typeof(self) 使用 typeof() 这个方法拿到 self 的类类型。（这里直接写 JJMemoryObject 也 OK）。weakSelf 的  __weak  修饰符表示变量被 block 引用之后会作为 block 的局部变量从栈中复制到堆中，ARC 会管理这个 block 中所有局部变量的内存释放问题。而  __weak 代表一种非拥有关系，weakSelf 和 _loadData 之间不会形成相互引用。

上面的例子中，引用问题由原来的

> self 持有 _object， _object 持有 block，block 持有 self

变成：

> self 持有 _object， _object 持有 block

所以就没有相互引用的问题了。

那这个 strongSelf 又是怎么回事呢？

因为 weakSelf 指向的是 self，而 self 是随时有可能被释放的，尤其是 block 通常执行在并发环境中。所以我们需要再次创建一个指向 weakSelf 的 strongSelf，如果想防止 weakSelf 被释放，例如当 block 回调是在子线程，block 执行的时候，主线程可能在 block 执行到一半的时候就将 self 置空，所以可以再次强引用一次。

我们举个例子来说明为什么 self 可能会被释放。假设 JJMemoryViewController push 到 JJTestMemoryViewController，JJTestMemoryViewController 执行 Block 如下：

```
#import "JJTestMemoryViewController.h"
@interface JJTestMemoryViewController ()
@property (nonatomic, copy) void(^block)();
@end

@implementation JJTestMemoryViewController

- (void)viewDidLoad{
    self.title = @"B 界面 ";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", weakSelf.title);
        });
    };
    self.block();
}
@end

```

如果 JJTestMemoryViewController 10 秒之后返回, JJMemoryViewController 界面会正常打印 weakSelf.title.
但如果 JJTestMemoryViewController 10 秒之内返回 JJTestMemoryViewController 则会打印 null，因为 10 秒之内返回，JJTestMemoryViewController 界面执行 dealloc 销毁，内存提前销毁，JJTestMemoryViewController 界面对应的 self 不存在，因此也不可能执行关于 self 的事项。所以需要使用 strongSelf 。

```
- (void)viewDidLoad{
    self.title = @"B 界面 ";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        	__strong typeof(self) strongSelf = weakSelf;
            NSLog(@"%@", strongSelf);
        });
    };
    self.block();
}

```

而如果具有 strongSelf，会使 B 界面所对应的 self 引用计数+1，即使 10 秒内返回 A 界面， B 界面也不会立刻释放。并且 strongSelf 属于局部变量，存在与栈中，会随着 Block 的执行而销毁。
总之 strongSelf 就是为了保证 Block 中的事件执行正确。

#### performSelector

performSelector 有以下的 API：

```
- (id)performSelector:(SEL)aSelector;
- (id)performSelector:(SEL)aSelector withObject:(id)object;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

```

它的用法其实就是一个对象调用一个方法（Objective-C 中方法被定义为 SEL 类型），例如下面的两种写法是等价的：

```
[object methodName];
[object performSelector:@selector(methodName)];

```

因为这两种写法是等效的关系，我们通常不会用 performSelector 来取代普通的方法调用。performSelector 的好处是可以在运行时决定调用的 SEL，同时，SEL 是由一个 NSString 初始化的，甚至，对象也可以用 NSString 初始化而成。所以，利用这种特性，我们可以做一些对象和方法的动态转发，例如下面的例子：

```
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    Class targetClass = NSClassFromString(targetClassString);
    id target = [[targetClass alloc] init];
    SEL action = NSSelectorFromString(actionString);
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        return nil;
    }
    if ([target respondsToSelector:action]) {
        return [target performSelector:action withObject:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            return nil;
        }
    }
}

```

> 从上面的代码你应该可以猜到常用的热更新方法是怎么实现的吧。

你会发现上面的代码中有这样一个东西：

```
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            //XXXXX
#pragma clang diagnostic pop

```

为什么呢，因为不加这段代码的话你会发现如下的警告：

![](https://ws3.sinaimg.cn/large/006tNc79gy1fge8laxu1fj30fh02pwec.jpg)

它告诉我们，这里的写法可能会导致内存泄漏。我们用一段更简洁的代码来解释为什么会有这段警告：

JJMemoryObject.h

```
@interface JJMemoryObject : NSObject<NSCopying>

- (NSNumber *)copyOne:(NSNumber *)number;
- (NSNumber *)addOne:(NSNumber *)number;

@end

```

JJMemoryObject.m

```
- (NSNumber *)copyOne:(NSNumber *)number{
    NSNumber *returnNumber = [number copy];
    return returnNumber;
}

- (NSNumber *)addOne:(NSNumber *)number{
    NSNumber *returnNumber = @(number.integerValue + 1);
    return returnNumber;
}

```

```
#import "JJMemoryViewController.h"
#import "JJMemoryObject.h"

@implementation JJMemoryViewController{
    JJMemoryObject *_object;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _object = [JJMemoryObject new];
    [self testPerformSelector];
}

- (void)testPerformSelector{
    NSNumber *number = @2;
    //如果这么写的话就有问题
    [_object performSelector:@selector(copyOne:) withObject:nil];
}

```

你可以试下写下上面的代码，你会发现编译器发出一个错误提示：

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fghd0p7zluj30gp00zjr8.jpg)

因为使用 performSelector: 这个方法的话，编译器不会为你添加释放操作，而以 copy 开头的方法是会 retain 一个返回的值的，这时候又没有相应的 release 操作，所以导致了内存泄漏。（为什么不会 release 呢，因为 performSelector 这个方法所调用的 selector 可能是动态的，所以它不了解方法签名和返回值，甚至是否有返回值都不懂，所以编译器无法用 ARC 的内存管理规则来判断返回值是否应该释放。因此，ARC 采用了比较谨慎的做法，不添加释放操作）。

你可能会想，既然有错误提示，那我们在出现错误提示时修改代码不就可以了吗？看看下面的写法：

```
SEL selector = number.integerValue > 1?@selector(copyOne:):@selector(addOne:);
_object = [_object performSelector:selector withObject:number];

```

这时候没有编译器错误提示了！因为 selector 时在运行时才能确定的，所以编译器无法确定哪个方法会被真正调用，所以没有错误提示，于是，当你自信地写下如上代码时，就有可能会引发内存泄漏。

如上面的代码，，即在方法返回对象时就可能将其持有，从而可能导致内存泄露。

#### NSNotificationcenter

NSNotificationcenter 其实不会有循环引用的问题，例如我们这里写：

```
- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"JJMemoryViewControllerNotification"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * notification) {
                                                      self.title = notification.userInfo[@"title"];
                                                  }];
}

```

这里只有单向的强引用。

只有这么写才会有循环引用的问题：

```
__weak __typeof__(self) weakSelf = self;
 _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"testKey"
                                                               object:nil
                                                                queue:nil
                                                           usingBlock:^(NSNotification *note) {
     __typeof__(self) strongSelf = weakSelf;
     [strongSelf dismissModalViewControllerAnimated:YES];
 }];

```

NSNotificationcenter 需要注意的是解除监听的问题：

```
[[NSNotificationCenter defaultCenter] removeObserver:self];

```

这个比较常见，如果你在 viewWillAppear 中监听了一个 NSNotificationcenter，记得在 viewWillDisappear 中调用 removeObserver。同样的，如果你在 viewDidLoad 监听了一个 NSNotificationcenter，记得在 dealloc 中调用 removeObserver。 

为什么说需要注意呢，当你的类本来有内存泄漏的时候，你的类很可能不会调用 dealloc 方法，所以你在 dealloc 中调用 removeObserver 可以说没什么卵用。

又或者，当你使用以下方法进行控制器的切换时：

```
+ (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

```

viewWillDisappear 也不会调用，所以你想当然的想在 viewWillDisappear 中调用 removeObserver 也没什么卵用。所以我们必须确保 removeObserver 这个操作会真的执行。

#### NSTimer

在使用 NSTimer addtarget 时，为了防止 target 被释放而导致的程序异常，timer 会持有 self，所以这也是一处内存泄露的隐患。

看下面的例子：

```
@implementation JJMemoryViewController{
    NSTimer *_timer;
}

- (void)viewDidLoad{
    [super viewDidLoad];    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f
                                              target:self
                                            selector:@selector(timerFire:)
                                            userInfo:nil
                                             repeats:YES];
    [_timer fire];
}

-(void)timerFire:(id)userinfo {
    NSLog(@"\n A 界面");
}
@end

```

上面代码的引用关系为 self 强引用 _timer,  _timer 强引用 self（其中的 selector）。所以会造成内存泄漏，为了防止内存泄漏，我们在 可能会想到在 delloc 方法中调用 cleanTimer。

```
- (void)dealloc{
	[_timer invalidate];
    NSLog(@"JJMemoryViewController dealloc");
}

```

然而这并没有什么作用，因为 _timer 对象并没有正常释放，所以 delloc 无法执行，定时器仍然在无限的执行下去。当前类销毁执行 dealloc 的前提是定时器需要停止并滞空，而定时器停止并滞空的时机在当前类调用 dealloc 方法时，这样就造成了互相等待的场景，从而内存一直无法释放。

所以，如何解决？

如果将 _timer 设置为 weak 可以解决吗？

```
@implementation JJMemoryViewController{
    NSTimer __weak *_timer;
}

```

不可以。因为这个 _timer 实际上是由 RunLoop 持有的，我们上面说的 “self 强引用 _timer,  _timer 强引用 self” 并不准确。所以将 _timer 设置为 weak 并不能解决问题。

<div class="tip">
我们上面的写法 timer 会被默认注册到 NSDefaultRunLoopMode 模式的 RunLoop 中，这个点需要注意，因为 RunLoop 只能运行在一种mode下，如果要换 mode，当前的 loop 也需要停下重启成新的。

利用这个机制，ScrollView 滚动过程中 NSDefaultRunLoopMode 的 mode 会切换到 UITrackingRunLoopMode 来保证 ScrollView 的流畅滑动, 只能在 NSDefaultRunLoopMode 模式下处理的事件会影响ScrollView的滑动。

如果我们把一个 NSTimer 对象以 NSDefaultRunLoopMode 添加到主运行循环中的时候, ScrollView 滚动过程中会因为 mode 的切换，而导致 NSTimer 将不再被调度。
所以正确的方式是这么写：

[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
</div>

方案1: 可以在 `viewDidDisappear` 或 `viewWillDisappear` 做如下操作：

```
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
}

```

或者 cleanTimer 方法外漏，在外部调用。

```
- (void)cleanTime{
    [_timer invalidate];
}

```

可是并不是特别优雅，要是其他开发者忘记调用 cleanTimer，或者 `viewDidDisappear` 或 `viewWillDisappear` 没有被正确调用到， 这个类就会一直存在内存泄漏，然后定时器也不会停止。

方案2: 将 _timer 对 selector 的强引用转移到 block:

```
+ (NSTimer *)jj_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats{
    void (^block)() = [inBlock copy];
    NSTimer * timer = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
    return timer;
}

+ (NSTimer *)jj_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats{
    void (^block)() = [inBlock copy];
    NSTimer * timer = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
    return timer;
}

+ (void)__executeTimerBlock:(NSTimer *)inTimer;{
    if([inTimer userInfo]){//相当于 if(block)
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

```

调用：

```
_timer = [NSTimer jj_scheduledTimerWithTimeInterval:1 block:^{
        NSLog(@"\n A 界面");
    } repeats:YES];
[_timer fire];

```

这样的话 _timer 和 self 之间就没有了强引用，（因为没有 targer 了，targer 被转移到 NSTimer 身上了）问题解决。对 block 执行 copy 是因为防止等下执行的时候，block 无效了。

方案3: 推荐用 dispatch 的 timer：

基于 GCD 的，并且不受 runLoop 的影响，对 target 是 weak 引用，不会引起循环引用的问题，总是在主线程调用。
具体可以参考 [YYTimer](https://github.com/ibireme/YYKit/blob/master/YYKit/Utility/YYTimer.m>)

#### 非 OC 对象内存处理

对于一些非 OC 对象，使用完毕后其内存仍需要我们手动释放。举个例子，比如常用的滤镜操作调节图片亮度：

```
CIImage *beginImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"yourname.jpg"]];
CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
[filter setValue:beginImage forKey:kCIInputImageKey];
[filter setValue:[NSNumber numberWithFloat:.5] forKey:@"inputBrightness"];// 亮度-1~1
CIImage *outputImage = [filter outputImage];
//GPU 优化
EAGLContext * eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
eaglContext.multiThreaded = YES;
CIContext *context = [CIContext contextWithEAGLContext:eaglContext];
[EAGLContext setCurrentContext:eaglContext];

CGImageRef ref = [context createCGImage:outputImage fromRect:outputImage.extent];
UIImage *endImg = [UIImage imageWithCGImage:ref];
_imageView.image = endImg;
CGImageRelease(ref);// 非 OC 对象需要手动内存释放

```

在如上代码中的 CGImageRef 类型变量非 OC 对象，其需要手动执行释放操作 CGImageRelease(ref)，否则会造成大量的内存泄漏导致程序崩溃。其他的对于 CoreFoundation 框架下的某些对象或变量需要手动释放、C 语言代码中的 malloc 等需要对应 free 等都需要注意。

#### 代理未清空引起野指针

iOS 的某些 API，或者你使用一些年代比较久远的第三方库，其 delegate 声明为 assign 的，(__weak 在 iOS5 之后才出现)。这样就会引起野指针的问题，可能会引起一些莫名其妙的 crash。当一个对象被回收时，对应的 delegate 实体也就被回收，但是 delegate 的指针确没有被 nil，从而就变成了游荡的野指针了。所以在 delloc 方法中要将对应的 assign 代理设置为 nil，如：

```
- (void)dealloc{
	self.XXX.delegate = nil;
}

```

### 检测内存泄漏

#### 借助 Xcode 自带的 Instruments 工具（选取真机测试）

![](https://ws1.sinaimg.cn/large/006tNc79gy1fj7jq7zf43j30yg0i7wfq.jpg)

 这种检测方法存在各种问题和不便：

- 首先，你得打开 Allocations

- 其次，你得一个个场景去重复的操作

- 无法及时得知泄露，得专门做一遍上述操作，十分繁琐

  所以通常我都不会使用，所以具体就不展开。

#### 重写 dealloc 方法

简单暴力的重写 dealloc 方法，加入断点或打印判断某类是否正常释放。

dealloc 调用方式如下： 如果 a 持有对象 b ，b 持有 c， c 持有 d， 假设 a 是一个 vc(其实只要是个对象都是一样的) 这时候 a.navigationxxxx popviewcon......  这时候如果 a “本身”没有内存泄漏，dealloc 回正常执行，
但在执行 dealloc 的，a 会驱使 b 释放，b 如果没有泄漏会执行 b 的 delloc 然后 b 在 dealloc 执行完之前首先驱使 c 释放，c 如果没有泄漏，在 c 的 dealloc 执行完之前会首先驱使 d 释放。这是整个释放链。

我们现在假设 a 确实没内存泄漏，但是 b 有，则 b 的 delloc 不会执行，这样 c、d 的也不会执行，你就会看到，a 的 delloc 执行了，但是 它所持有的 b， b 持有的 c， c 持有的 d 都没有释放。

因此 单纯以一个 delloc 来确定我整个类释放了是不准确的，你要保证你这个对象所有所持有的对象（系统对象应该不与考虑，即使你考虑了 系统控件／对象造成的对象你也解决不了）都执行了 delloc 方法，你才可以保证的说：没有内存泄漏了。

#### 使用 微信阅读开源的 MLeaksFinder

具体介绍可看 [MLeaksFinder](https://wereadteam.github.io/2016/02/22/MLeaksFinder/)

#### Facebook 开源 的 FBRetainCycleDetector 。

<https://github.com/facebook/FBRetainCycleDetector>



前面的文章讲述了 ARC 以及 ARC 下内存泄漏问题，通常呢，前面讲到的那些点都做到了，一般不会有什么内存泄漏的问题。

不过，另外一个问题是，没有内存泄漏问题了，那内存占用过多如何解决和避免呢？要知道，如果 App 占用了系统过多的使用内存，系统会根据情况把 App 直接 kill，所以，内存占用问题也是一个需要关心的点。下面我们总结一些内存优化的小技巧。

<!--more-->

### 留意内存警告

通常一个应用程序会包含多个 view controllers，当从 A 跳转到另一个 B 时，之前的 A 只是不可见状态，并不会立即被清理掉，而是保存在内存中，以便下一次的快速显现。

当出现内存警告时，系统会发出 UIApplicationDidReceiveMemoryWarningNotification 的通知，所以，我们可以监听这个 UIApplicationDidReceiveMemoryWarningNotification，并做相应处理。同时，所有在内存中的 view controllers 也会调用 didReceiveMemoryWarning 方法，所以，我们也可以在 view controllers 做相应处理。

其实内存警告有时候不一定是你 App 的问题，内存警告是一个全局的概念，指的是你的手机的内存资源占用情况。所以，内存问题可能是你刚刚在运行的游戏 App 造成的，也许你的 App 并没有占用太多的内存，这时候还是会收到内存警告的问题。

不过，当收到内存警告的时候：我们还是应该释放一些资源，尤其是图片等占用内存多的资源，等需要的时候再进行重建。不过，你要确保释放的资源必须对当前类没有造成太大的影响。例如，你可以使用 Lazy Allocation（懒加载）模式调用对象，这样我们把对象直接 set nil 即可。

```
- (void)didReceiveMemoryWarning{
    self.imageArray = nil;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[[UIImage imageNamed:@"large_image1"],[UIImage imageNamed:@"large_image2"],[UIImage imageNamed:@"large_image3"],[UIImage imageNamed:@"large_image4"]];
    }
    return _imageArray;
}
```

或者，把内存中的对象移到文件缓存中，不过，这种做法也有系统 IO 的开销，通常我们只针对内存占用较大的对象这样处理。通常，图片问题是内存警告处理的主要点，可以优先处理图片问题。

例如，我们看 SDImageCache 在收到内存警告时的处理 ，它也会把对象清除掉。下次从网络或文件中读取即可。

```
@interface AutoPurgeCache : NSCache
@end

@implementation AutoPurgeCache

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}
@end
```

### 使用 autoreleasepool 降低内存峰值

#### 关于 autorelease

在前面的《内存管理-什么是ARC?》一文中，我们讲过 autorelease 这个概念。

```
- (NSString *)temp{
	NSString *tmp = @"A";// 计数为 1
	return [tmp autorelease];
}
```

字面上理解：自动释放。那么这个自动的时机是什么时候呢？首先，肯定不是 temp 函数调用结束的时候释放，这样 autorelease 就没有意义了。
答案是：tmp 对象在出了作用域之后，会被添加到最近一次创建的 autoreleasepool 即自动释放池中，并会在当前的 runloop 迭代结束时释放。

#### autoreleasepool

这个 autoreleasepool 的创建方法如下：

```
@autoreleasepool{
	//注意，可以嵌套使用。
}
```

就是这么的 easy。在作用域的结尾处，即右括号处，所有 autoreleasepool 中的对象都会被清理掉。

我们知道 main.m 中有一个 autoreleasepool ，那么 tmp 对象是被放到这个自动释放池吗？

```
int main(int argc, char * argv[]) {
@autoreleasepool {
    return UIApplicationMain(argc, argv, nil∂ç
    NSStringFromClass([AppDelegate class]));
}
```

答案是否定的。这个 autoreleasepool 块的运行范围是整个 app 的生命周期，这个时候才执行清理工作显然没有意义。（你可能会想那为什么 main 函数还会创建这个 autoreleasepool？那是因为 UIApplicationMain 中也有对象需要被放进自动释放池中，这个池可以理解为最外围捕捉自动释放对象所用的池）。在一次完整的运行循环结束之前，会被销毁。

回到前面说的，这个最近一次创建的 autoreleasepool 是什么时间创建的？答案是 runloop （即运行循环）检测到事件并启动后，就会创建自动释放池。

<div class="tip">

注意，自定义的 NSOperation 和 NSThread 需要手动创建自动释放池。比如：自定义的 NSOperation 类中的 main 方法里就必须添加自动释放池。否则出了作用域后，自动释放对象会因为没有自动释放池去处理它，而造成内存泄露。
但对于 blockOperation 和 invocationOperation 这种默认的Operation 或者 GCD ，系统已经帮我们封装好了，每次执行事件循环时，就会将其清理，所以不需要手动创建自动释放池。

</div>

#### 使用 autoreleasepool 避免内存峰值

那么为什么在 ARC 时代还需要使用自动释放池呢？其中一个原因就是为了避免内存峰值，比如说，我有一个很大的For 循环，里面不断读入较大的文件。其实每迭代一次，资源都已经用完了（就是说我用好了，还你），不需要再用了，这个时候就可以释放了，但是自动释放池要等线程执行下一次事件循环时才会清空，所以，在这个 for 循环期间，程序所占的内存就会持续上涨，这就增大了内存的峰值。

例如下面这个例子，每次 for 循环产生临时变量，占用的内存空间是十分可观的：

```
for (int i = 0; i < 100000; i++) {
    NSNumber *num = [NSNumber numberWithInt:i];
    NSString *str = [NSString stringWithFormat:@"%d ", i];
    NSString *getMemoryUsage = [NSString stringWithFormat:@"%@%@", num, str];
    [memoryUsageList1 addObject:getMemoryUsage];
}
```

所以我们可以通过下面这种方案来解决：

```
for (int i = 0; i < 100000; i++) {
    @autoreleasepool {
        NSNumber *num = [NSNumber numberWithInt:i];
        NSString *str = [NSString stringWithFormat:@"%d ", i];
        NSString *getMemoryUsage = [NSString stringWithFormat:@"%@%@", num, str];
        [memoryUsageList1 addObject:getMemoryUsage];
    }
}
```

每执行一次 for 循环，都会清空 for 循环中产生的临时变量，而不是等到某个事件循环时才清空，所以可以有效避免内存峰值。

#### MRC 下的 autoreleasepool

MRC 下 autoreleasepool 是这么写的，权当了解一些。

```
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
NSString* str = [[[NSString alloc] initWithString:@"tutuge"] autorelease];
[pool drain];
```

#### autoreleasepool 的其他 tips：

使用容器的 block 版本的枚举器时，内部会自动添加一个 AutoreleasePool：

```
[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    // 这里被一个局部 autoreleasepool包围着
}];

```

#### autoreleasepool 的原理

autoreleasepool 以一个队列数组的形式实现,主要通过下列三个函数完成:

- objc_autoreleasepoolPush
- objc_autoreleasepoolPop
- objc_autorelease

看函数名就可以知道，对 autorelease 分别执行 push，和 pop 操作。销毁对象时执行release操作。

### 图片的读取问题

```
UIImage *image1 = [UIImage imageNamed:@"smallImage"];
NSString *path =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bigImage.png"];
UIImage *image2 = [UIImage imageWithContentsOfFile:@"bigImage"];

```

上面这两种写法有什么区别吗？[UIImage imageNamed:] 只适合与 UI 界面中小的贴图的读取，而一些比较大的资源文件应该尽量避免使用这个接口。直接读取文件路径 [UIImage imageWithContentsOfFile] 来解决图片的读取问题

- 对于第一种，是带缓存机制的，如果频繁读取小文件，用它就只需要读取一次就好，但是缺点就是如果使用大图片会常驻内存，对于降低内存峰值是不利的。
- 对于第二种方法，不带缓存机制，适合使用大图片，使用完就释放

注意，使用 imageNamed 获取的图片可以放在 Assets.xcassets 中，然后只要传入图片名称即可，系统会自动适配 2x 和 3x 的图片。

而 imageWithContentsOfFile 获取的图片，参数不可以只是图片的名称，必须是图片的文件路径，同时，图片不能放在 Assets.xcassets，否则获取不到图片的路径。放在 Assets.xcassets 中的图片只能通过imageNamed:方式去加载。因为 Assets.xcassets中 的图片根本就不在 MainBundle 里面，而是被系统打包统一打入到 ASSets.car 中。

留意下获取 path 的方法:

```
NSString *path =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bigImage.png"];

```

如果是下面这么写也是可以的，但是就没办法适配 2x 和 3x 的图片了。

```
NSString *path = [[NSBundle mainBundle]pathForResource:@"bigImage@2x" ofType:"png"];

```

### NSData 的读取问题

取一个几十 M 的大数据文件，如果采用 NSData 的 dataWithContentsOfFile: 方法，将会耗尽 iOS 的内存。其实这个是可以改善的。
NSData 还有一个API：

```
+ (id)dataWithContentsOfFile:(NSString *)path options:(NSDataReadingOptions)readOptionsMask error:(NSError **)errorPtr;

```

其中 NSDataReadingOptions 可以附加一个参数 NSDataReadingMappedIfSafe 参数。使用这个参数后，iOS 就不会把整个文件全部读取的内存了，而是将文件映射到进程的地址空间中，这么做并不会占用实际内存。这样就可以解决内存满的问题。

```
    NSString *path = @"test";
    NSError *error = nil;
    NSData *data1 = [[NSData alloc] initWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];

```

对于体积很大文件，使用内存映射方式读取将会减少大量内存占用。什么是文件内存映射呢？

文件内存映射是指把一个文件的内容映射到进程的内存虚拟地址空间中，这个实际上并没有为文件内容分配物理内存。实际上就相当于将内存地址值指向文件的磁盘地址。如果对这些内存进行读写，实际上就是对文件在磁盘上内容进行读写。

