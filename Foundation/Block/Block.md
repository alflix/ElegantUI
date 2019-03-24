### block

Block 首次出现在 OSX10.6 和 iOS4 平台上。Block 通常可以完全替代 delegate 其作为代理消息传递机制的角色。它类似于 C 上的函数指针，可以将代码块像对象一样传递，同时可以访问上下文，使代码更紧凑。不用像 delegate 一样生成很多局部变量。

#### 语法

block 很好，但是它的语法很难记。

1：创建 block 的语法为：returnType (^ blockName)(parameterTypes)

其中 blockName 是 block 的名称（竟然在中间，简直反人类），returnType 是返回类型，parameterTypes 是参数。可以说，这三个参数和一个函数一摸一样。

例如
```objective-c
@property (nonatomic, copy) int(^BlockName)(int a);
```

调用方式：
```objective-c
self.BlockName = ^(int a){
	return 1;
};
```

2：作为方法参数又是另外一种写法(BlockName 到最右边了)：
(returnType (^ )(parameterTypes)) blockName :

```objective-c
- (void)testBlock:(int(^)(int a))BlockName{
    
}
```

调用：
```objective-c
-(void)test {
	[self testBlock:self.BlockName];
	[self testBlock:^(int a){
        return 1;
   }];
}
```

3：typedef 特性可以让我们从泥潭中挽救出来：

Block 可以看作一种特殊语法的 “objects” 。通常我们 typedef 一个 block 来存储它：

```objective-c
//typedef 这个 block 为 BlockName 类型：
typedef int(^BlockName)(int a);
```

然后就可以这样子传递参数了，简直不能更畅快：
```objective-c
- (void)testBlock2:(BlockName)blockName{
    NSLog(@"----- %@",blockName);
}
```

#### 注意事项

1：block 在实现时会对 block 外的变量进行只读拷贝，在 block 块内使用该只读拷贝。此时， block 是默认将其复杂到其数据结构中来实现访问的。

如果我们想要让 block 修改或同步使用 block 外的变量，就需要用 __block 来修饰 outside 变量。此时，block 是复制其引用地址来实现访问和修改的。

```objective-c
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

```objective-c
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



