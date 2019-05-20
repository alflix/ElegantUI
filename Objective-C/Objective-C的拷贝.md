---

title: Objective-C的拷贝

date: 2016-06-02

desc: iOS 开发

---

### 深拷贝与浅拷贝

首先，只有遵守 NSCopying 协议的类才能发送 copy 消息。同理，遵守了 NSMutableCopying 协议的类才能发送 mutableCopy 消息。大部分 Foundation 中的类都遵守 NSCopying 协议，但是 NSObject 的子类，也就是我们自定义的类并未遵守 NSCopying 协议。

<!--more-->

浅拷贝，又称为指针拷贝，并不会分配新的内存空间，新的指针和原指针指向同一地址。深拷贝，又称对象拷贝，会分配新的内存空间，新指针和原指针指向不同的内存地址，但是存储的内容相同。

依照深拷贝浅拷贝的特性，浅拷贝多用于添加引用，达到操作新对象，则所有指向同步发生变化的目的；反之深拷贝是隔离原对象和新对象，各自操作互不干扰。

#### Foundation 中非容器对象的 Copy

```
copy	mutableCopy
NSString	浅拷贝	深拷贝
NSMutableString	深拷贝	深拷贝
```

由表格可见，除了不可变对象 NSString 的不可变副本是浅拷贝以外，其他均为深拷贝。由于对象本身为不可变对象，所以在 copy 不可变副本的时候才用了指针复制，无必要新分配空间做深拷贝。

#### Foundation 中容器对象的 Copy

```
copy	mutableCopy
NSArray	浅拷贝	深拷贝
NSMutableArray	深拷贝	深拷贝
Object in NSArray	浅拷贝	浅拷贝
Object in NSMutableArray	浅拷贝	浅拷贝
```

除了不可变对象 NSArray 的不可变副本为浅拷贝以外，其他容器对象均为深拷贝。需要指出的是，容器内的对象均为浅拷贝，这就意味着，新容器的内部的对象改变，原容器内部的对象会同步改变。

如果要实现容器和内部对象的深拷贝，需要遵循 NSCoding 协议，先将对象 archive 再 unarchive。

```
NSArray *array  = @[@1, @2];
NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
NSArray *newArray = [NSUnarchiver unarchiveObjectWithData:data];
```

此时 newArray 无论是容器本身还是容器内部对象都和原来的 array 无关联。

#### 自定义对象的 Copy

自定义对象继承自 NSObject，需要自己实现 NSCopying 协议下的 copyWithZone 方法。

Person.h

```objective-c
import <Foundation/Foundation.h>
@interface Person : NSObject<NSCopying>
- (Person *)personWithName:(NSString *)name age:(NSString *)age;
@end
```

Person.m

```objective-c
import "Person.h"

@interface Person ()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *age;
@end

@implementation Person

- (Person *)initWithName:(NSString *)name age:(NSString *)age {
if (self = [super init]) {
self.name  = name;
self.age = age;
}
return self;
}

- (Person *)personWithName:(NSString *)name age:(NSString *)age {
return [[self alloc] initWithName:name age:age];
}

- (Person *)copyWithZone:(NSZone *)zone {
Person *person = [[Person allocWithZone:zone] init];
person.name = [self.name copyWithZone:zone];
person.age = [self.age copyWithZone:zone];
return person;
}
@end
```

### Hash/Equal

####  Equal

NSObject 类中的 equal 方法的判断，是包括内存地址的。换句话说，NSObject 若想判断两个对象相等，那这两个对象的地址必须相同。

但实际编码中，我们常常设计一个对象，其各项属性相同， 我们就认为他们 equal，要达到这个目的，我们就要重载 equal 方法。于是我们在上述的 Person 对象中重载如下方法：

Person.m

```
- (BOOL)isEqual:(Person *)other {
BOOL isMyClass     = [other isKindOfClass:self.class];
BOOL isEqualToName = [other.name isEqualToString:self.name];
BOOL isEqualToAge  = [other.age isEqualToString:other.age];
if (isMyClass && isEqualToName && isEqualToAge) {
return YES;
}
return NO;
}
```

main.m

```
# import <Foundation/Foundation.h>
# import "Person.h"

int main(int argc, const char *argv[]) {

@autoreleasepool {
Person *person1 = [Person personWithName:@"Joe" age:@"32"];
Person *person2 = [Person personWithName:@"Joe" age:@"32"];
NSLog(@"isEqual-----%zd", [person1 isEqual:person2]);
}
return 0;
}
```
控制台打印结果为

isEqual-----1
证明确实完成了属性相同，就判断两个对象 equal 的目的。

#### Hash

任何 Objective-C 都有 hash 方法，该方法返回一个 NSUInteger，是该对象的 hashCode。

```
-(NSUInteger)hash {
return (NSUInteger)self>>4;
}
```

上述是 Cocotron 的 hashCode 的计算方式，简单通过移位实现。右移 4 位，左边补 0。因为对象大多存于堆中，地址相差 4 位应该很正常，所以不同对象可能会有相同的 hashCode。当对象存入集合 (NSSet, NSDictionary) 中，他们的 hashCode 会作为 key 来决定放入哪个集合中。

存储表

```
hashCode	subCollection
code1		value1,value2,value3,value4
code2		value5,value6
code3		value7
code4		value8,value9,value10
```

集合的内部是一个 hash 表，由于不同对象的 hashCode 可能相同，所以同一个 hashCode 对象的将会是一个 subCollection 的集合。如果要删除或者比较集合内元素，它首先根据 hashCode 找到子集合，然后跟子集合的每个元素比较。

集合内部的查找策略是，先比较 hashCode，如果 hashCode 不同，则直接判定两个对象不同；如果 hashCode 相同，则落到同一个 subCollection 中，再调用 equal 方法具体判断对象是否相同。所以，如果两个对象相同，则 hashCode 一定相同；反之，hashCode 相同的两个对象，并不一定是相同的对象。

如果所有对象的 hashCode 都相同，那么每次比较都会调用 equal 方法，整个查询效率会变得很低。也就是说，hashCode 是为了来提高查询效率的。

#### 集合中自定义对象的存取

本节中集合对象选定为 NSDictionary。上面说讲，我们得知了集合内部实际是一个 HashTable。那自定义对象，按照新逻辑重载 equal 方法之后，在集合中的存取应该如何？

参考 Cocotron 源码，NSDictionary 使用 NSMapTable 实现的。

```objective-c
@interface NSMapTable : NSObject {

NSMapTableKeyCallBacks   *keyCallBacks;
NSMapTableValueCallBacks *valueCallBacks;
NSUInteger               count;
NSUInteger               nBuckets;
struct _NSMapNode        * *buckets;
```

}
上面是 NSMtabtable 真正的描述，可以看出来 NSMapTable 是一个哈希＋链表的数据结构，因此在 NSMapTable * 

中插入或者删除一对对象时 :

- 为对 key 进行 hash 得到 bucket 的位置
- 遍历该 bucket 后面冲突的 value，通过链表连接起来。

由于一对键值存入字典中之后，key 是不能随意改变的，这样会造成 value 的丢失。所以一个自定义对象作为 key 存入 NSDictionary，必定要深拷贝。正是为了实现这一目的，则 key 必须遵守 NSCopying 协议。

main.m

```objective-c
# import <Foundation/Foundation.h>
# import "Person.h"

int main(int argc, const char *argv[]) {

@autoreleasepool {
Person *person1 = [Person personWithName:@"Joe" age:@"32"];
Person *person2 = [Person personWithName:@"Joe" age:@"32"];
Person *person3 = [Person personWithName:@"Joe" age:@"33"];
NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
[dict setObject:@"1" forKey:person1];
[dict setObject:@"2" forKey:person2];
[dict setObject:@"3" forKey:person3];
NSLog(@"person1----%@", [dict objectForKey:person1]);
NSLog(@"person2----%@", [dict objectForKey:person2]);
NSLog(@"person3----%@", [dict objectForKey:person3]);
NSLog(@"dict count: %ld", dict.count);
}
return 0;
```

}
由于我们重载了 equal 方法，person1 和 person2 应该是相同对象，理论上 dict 的 count 应该是 2。

事实上打印结果是随机的，dict 内部可能会有 2 或 3 组键值对。Person 实例化对象取出的值也是不尽相同。这是因为，在对象存入 key 时，每次都要进行 hash/equal 验证，如果为相同对象，则不增加键值对数量，直接覆盖之前 key 的 value。我们重载了 equal 方法，但是 person1 和 person2 的 hashCode 是不同的，则他们直接会被判定为不同的对象，person2 直接作为新的 key 存入了 dict。

在取 key 的时候，依旧要执行 hash/equal ，由于存入 dict 中的副本是深拷贝，那副本的 hashCode 和原对象也是不同的，会判定要查找的对象在 key 中不存在，造成了能存不能查的情况。

这就是我们为什么重载了 equal 就必须还要重载 hash 的根本原因。

重载 hash 要保证，其 hash 算法只跟成员变量相关，即 name 和 age；同时要保证其深拷贝副本的 hashCode 与 原对象相同。

Person.m
```objective-c
- (NSUInteger)hash {
return [self.name hash] ^ [self.age hash];
}  
```

切记不能全部返回相同的 hashCode，这样会每次都调用 equal，效率很差。


