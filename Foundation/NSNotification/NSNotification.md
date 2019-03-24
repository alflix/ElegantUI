### Notification

NSNotificationCenter 是一个单例。要在代码中的两个不相关的模块中传递消息时，通知机制是非常好的工具。通知机制广播消息，当消息内容丰富而且无需指望接收者一定要关注的话这一招特别有用。

比如我们可以接收一个 UIKeyboardWillShowNotification 来监听键盘的出现 :

```objective-c
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
```

在相应的地方注销通知：

```objective-c
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self
	name:UIKeyboardWillShowNotification
	object:nil];
}
```

发送通知使用以下方法：

```objective-c
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject;
- (void)postNotificationName:(NSNotificationName)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;
```

通知可以用来发送任意消息，甚至可以包含一个 userInfo 字典。通知的独特之处在于，发送者和接收者不需要相互知道对方，所以通知可以被用来在不同的相隔很远的模块之间传递消息。这就意味着这种消息传递是单向的，我们不能回复一个通知。



