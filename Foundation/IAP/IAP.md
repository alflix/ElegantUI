内购的核心流程：

- 1.客户端基于 product id （通常是服务器返回，也可能是本地写死）向 StoreKit 请求购买产品。

  ```[[SKPaymentQueue defaultQueue] addPayment:payment]```

- 2.客户端监听购买结果。apple 验证产品有效后，从用户的账户扣费

   ``` [[SKPaymentQueue defaultQueue] addTransactionObserver:self]``` 

- 3.成功的话，StoreKit 会将 receipt-data 保存在 bundle, 客户端从 bundle 中拿到 receipt-data，里面记录了本次交易的证书和签名信息。

  ```objective-c
  NSData *receiptData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]];
  NSString *receipt = [receiptData base64EncodedStringWithOptions:0];
  ```

- 4.客户端把苹果给的 receipt_data , transaction_id, product_id 上报给服务器。

  ```objective-c
  [self.apimanager loadData]
  ```

- 5.服务器对上传的数据进行初步合法校验后，发往 itunes.appstore 进行验证

- 6.itunes.appstore 返回验证结果给服务器

- 7.服务器根据商品的验证结果以及商品类型，向客户端发放相应的道具或者通知购买凭据无效，客户端把这笔交易 finish 掉

客户端上传的数据格式大概（>iOS7）：

```json
{
    "status": 0, 
    "environment": "Sandbox", 
    "receipt": {
        "receipt_type": "ProductionSandbox", 
        "adam_id": 0, 
        "app_item_id": 0, 
        "bundle_id": "com.xxx.xxx", 
        "application_version": "84", 
        "download_id": 0, 
        "version_external_identifier": 0, 
        "receipt_creation_date": "2016-12-05 08:41:57 Etc/GMT", 
        "receipt_creation_date_ms": "1480927317000", 
        "receipt_creation_date_pst": "2016-12-05 00:41:57 America/Los_Angeles", 
        "request_date": "2016-12-05 08:41:59 Etc/GMT", 
        "request_date_ms": "1480927319441", 
        "request_date_pst": "2016-12-05 00:41:59 America/Los_Angeles", 
        "original_purchase_date": "2013-08-01 07:00:00 Etc/GMT", 
        "original_purchase_date_ms": "1375340400000", 
        "original_purchase_date_pst": "2013-08-01 00:00:00 America/Los_Angeles", 
        "original_application_version": "1.0", 
        //这个数组里面会包含了当前的内购项目以及之前除了消耗型内购之外的其他内购项目，通常用于后台的一个校验手段
        "in_app": [ 
            {
                "quantity": "1", 
                "product_id": "rjkf_itemid_1", 
                "transaction_id": "10000003970", 
                "original_transaction_id": "10000003970", 
                "purchase_date": "2016-12-05 08:41:57 Etc/GMT", 
                "purchase_date_ms": "1480927317000", 
                "purchase_date_pst": "2016-12-05 00:41:57 America/Los_Angeles", 
                "original_purchase_date": "2016-12-05 08:41:57 Etc/GMT", 
                "original_purchase_date_ms": "1480927317000", 
                "original_purchase_date_pst": "2016-12-05 00:41:57 America/Los_Angeles", 
                "is_trial_period": "false"
            }
        ]
    }
```

---------------------------------------------------------------------------------------------------------------

#### 问题一：有哪几种类型的内购项目？

- Consumable 消耗型项目：只可使用一次的产品，使用之后即失效，必须再次购买。例如：虚拟币

- Non-Consumable 非消耗型项目：只需购买一次，不会过期或随着使用而减少的产品。这个一般是游戏那里用的多，一般是付费解锁关卡的场景，例如异次元中的章节 

- Auto-Renewable Subscriptions 自动续期订阅：允许用户在固定时间段内购买动态内容的产品。除非用户选择取消，否则此类订阅会自动续期。iTunces上给的示例是：每月订阅提供流媒体服务的 App。比较少用

- Non-Renewing Subscriptions 非续期订阅：月卡，腾讯体育会员等。实现方式可以完全照搬消耗性项目，不用做什么额外处理，也不用去管返回的订阅日期什么的东西，就是以服务器那边为准。服务器的日期开始，服务器的日期结束。既简单又保险，不需要额外的做什么处理。

---------------------------------------------------------------------------------------------------------------

#### 问题二：为什么需要服务器来检验？客户端校验不行吗？

一个真理，“凡是在客户端的数据都是不安全的”

IAP built-in Model，本地验证

1.回调成功后，直接发货：有很多工具专门利用这样的IAP漏洞的，🙅‍♂️

2.回调成功后，客户端直接 发往 itunes.appstore 进行验证？

但如果能伪造一个完全合法的receipt-data，是不是一样可以达到欺骗目的？所以出现了可以伪造”合法订单”的 in-appstore 。这是最坑最坑的地方，伪造的receipt_data苹果校验也返回支付成功，因此这种本地加强验证的方法也不能完全避免IAP攻击

3.通过服务器验证相当于在2 的基础上多了一道防线（当然也不是百分百安全的，但是是最佳方案了）

4.服务器除了相对安全之外，还可以防止刷单/漏单等操作

---------------------------------------------------------------------------------------------------------------

#### 问题三：我们平常接触的微信购买等流程是有订单号这个东西的，上面的流程中怎么没有？如果有的话，服务器如何将内购和订单关联起来？

例如，有很多很多虚拟商品，通过价格建立一些内购 id，然后通过关联订单号的方式来进行购买某个商品，是否可行呢？

答案，不行。其中最关键的是： SKMutablePayment 中的 applicationUsername 有**一定概率**没有持久化成功。

苹果的官方文档是有讲过可以这样做的：[链接](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/RequestPayment.html#//apple_ref/doc/uid/TP40008267-CH4-SW6)

```
The App Store can’t detect this kind of irregular activity on its own—it needs information from your app about which account on your server is associated with the transaction.

To provide this information, populate the applicationUsername property of the payment object with a one-way hash of the user’s account name on your server.
```

例如, 以下，我们正常情况下，将订单号赋值给 payment.applicationUsername

```objective-c
SKMutablePayment* payment = [SKMutablePayment paymentWithProductIdentifier:productId];
payment.applicationUsername = self.order;
[[SKPaymentQueue defaultQueue]addPayment:payment];
```

在支付成功后苹果回调的 transaction 的 [[transaction payment] applicationUsername] 中可以获取到该透传字段，以作为服务器识别发送虚拟商品的目标。

```objective-c
NSString* order = [[transaction payment] applicationUsername];
```

可惜的是，applicationUsername 在一定概率情况下可能为空，https://forums.developer.apple.com/thread/14136，属于 apple 的一个 bug

如果有很多很多虚拟商品这种情况，考虑用虚拟币的方案来实现。

---------------------------------------------------------------------------------------------------------------

#### 问题四：如何防止刷单？（服务器相关）

对验证 receipt-data 的 reponse content 不进行验证和记录，只根据 Product 直接发放商品。这样只要客户端不断提交 receipt-data ，按照正常逻辑你就需要不断验证并且重复发放商品。较为安全的做法是：

在每一次收到 receipt-data 之后，都把提交的玩家账号以及 receipt-data 中的单号建立映射并记录下来，在每次验证 receipt-data 时，先判断其是否已经存在。

⚠️：这个虽然和客户端无关，但客户端需要测试这个流程

---------------------------------------------------------------------------------------------------------------

#### 问题五：如何防止漏单

我们知道手机网络是不稳定的，在付款成功后不能确保把 receipt-data 一定提交到服务器。如果出现了这样的情况，那就意味着玩家被扣费了，却没收到服务器发放的道具

如何处理？

1.依赖苹果的回调。可以，但不完全可以解决问题

- 凭据没有任何用户信息记录，用户可能重新执行了切换账号等操作，重新提交服务器时不知道是谁的？

- 只有重新启动的时刻才有回调

2.本地记录并结合苹果的回调

在客户端提交 receipt-data 给我们的服务器，让我们的服务器向苹果服务器发送验证请求，验证这个 receipt-data 账单的有效性. 在没有收到回复之前，客户端必须要把 receipt-data + 用户信息 + 交易信息保存好。

```objective-c
/**
 保存 Transaction
 @param transaction Transaction Value
 @param transactionIdentifier Transaction Identifier
 */
- (void)updateTransactionsListByTransaction:(CLPaymentTransaction *)transaction
                      transactionIdentifier:(NSString *)transactionIdentifier{
    DLog(@"支付成功，以 transactionIdentifier 为 key 保存到本地 ");
    NSMutableDictionary *mutableTransactionsList = [self.transactionsList mutableCopy];
    [mutableTransactionsList setObject:transaction forKey:transactionIdentifier];
    _transactionsList = [mutableTransactionsList copy];
    [_cache setObject:_transactionsList forKey:CLTransactionCacheKey];
    DLog(@"开始更新本地 transactions");
}
```

并且定期或在合理的UI界面触发向服务端发起请求，直至收到服务端的回复后删除客户端的receipt账单记录。

```objective-c
- (void)handleUnPurchargeData{
    DLog(@"处理本地存在的下一笔交易");
    NSString *key = self.transactionsOfCurrentUser.allKeys.firstObject;
    if (key.length) {
        [self beginLoadDataWithIndentifier:key];
    }
}
```

----------------------------------------------------------------------------------------------------------------------------------------------------

#### 问题六：什么是「恢复购买」？

对于非消耗型内购来讲，用户买过一次，卸载重装或者同一个 Apple id ，但换手机时，也要能保证用户重新获得该内购商品。这个就叫做恢复购买。

注意对于消耗型商品无效 https://stackoverflow.com/questions/6449312/iphone-in-app-purchase-consumable-correct-approach?rq=1

我们会发现一个问题。这个流程是基于 Apple id 的，和自己的用户系统冲突了怎么办？例如同一个 Apple id，不同的登录用户？难道也要做恢复购买吗？做的话，服务器的判断逻辑是给发货呢？还是不给发货呢？

1.首先，如果苹果不做要求，可以先不做这个功能

2.如果要做，可以这样处理：

- 在游客状态下遵循苹果恢复购买的逻辑，因为一部设备只会有一个游客，可以将这种情况视为 Apple id 作为一种标示了

- 如果是登录状态下，服务器做判断，还没发货的商品允许恢复购买，已经发货的商品不允许重复发放。这种处理方式可以理解为之前的防止漏单处理中「本地记录并结合苹果的回调」的一种加强的验证方式而已，实际上并不是真正的恢复购买的逻辑。

------

#### 问题七：什么？还有「游客状态」？

对于游戏类应用，苹果通常都会要求你增加游客状态下也可以进行内购

对于游客模式，我们通常会生成一个唯一设备标识 UUID 来作为游客模式的一个标示，在服务器端，把其当成一个特殊的登录用户。此外还会涉及到游客登录后数据如何同步等问题。

![1](1.png)

---------------------------------------------------------------------------------------------------------------

#### 问题八：服务器应该返回给客户端什么？（服务器相关）

服务器提交苹果服务器验证的时候，会收到以下的返回码

21000	App Store不能读取你提供的JSON对象
21002	receipt-data域的数据有问题
21003	receipt无法通过验证
21004	提供的shared secret不匹配你账号中的shared secret
21005	receipt服务器当前不可用
21006	receipt合法，但是订阅已过期。服务器接收到这个状态码时，receipt数据仍然会解码并一起发送
21007	receipt是Sandbox receipt，但却发送至生产系统的验证服务
21008	receipt是生产receipt，但却发送至Sandbox环境的验证服务

服务器需要根据返回码，返回给客户端下面三种返回码：

- 1.凭据有效，校验成功
- 2.凭据无效，校验失败 
- 3.连接苹果服务器失败/超时

对于 1 和 2 来讲，我们客户端就可以 finishTransaction了，3 不可以，还需要下次重新请求，直至出现1或2为止（属于上面提到的漏单处理的其中一个流程）

---------------------------------------------------------------------------------------------------------------

#### 问题九：什么是沙盒账号？关于沙盒账号，服务器要注意什么？（服务器相关）

我们在测试 IAP 或苹果的审核人员在测试的时候，用户都是沙盒账号。字如其意，就是用来测试的，不会真的扣款，服务器在校验时也是连接苹果的沙盒服务器。

创建沙盒账号可以参考一些网上的文章，很多，不多讲。

https://juejin.im/post/5a367718f265da4320035351

然而我们 app 上线了的话，用的却是真正的账号，去苹果服务器验证也是真正的服务器，那如何处理呢？

审核通过再手动切换吗？

可以是可以，但是这种办法很蠢，通常的做法是，让服务器做双重验证，即，先以线上交易验证地址进行验证，如果苹果正式验证服务器的返回验证码 code 为21007，则再一次连接沙盒测试服务器进行验证即可。在应用提审时，苹果IAP提审验证时是在沙盒环境的进行的，即：苹果在审核App时，只会在 sandbox 环境购买，其产生的购买凭证，也只能连接苹果的测试验证服务器，如果没有做双验证，需要特别注意此问题，否则会被拒。

---------------------------------------------------------------------------------------------------------------

#### 问题十：退款怎么办？（服务器相关）


有退款的话，苹果不会通知任何一方，所以服务器需要每一个月，手动查询最近3个月的凭据状态是否被取消了，是的话将其发货的东西收回。

---------------------------------------------------------------------------------------------------------------

#### 证书的配置文件，XCode 等杂七杂八，这些就不讲了，网上的资料很多

第三方框架：（都没用过）

https://github.com/saturngod/IAPHelper 

https://github.com/Liqiankun/DLInAppPurchase

https://github.com/mattt/CargoBay

https://github.com/robotmedia/RMStore

参考文章：

[贝聊 IAP 实战之满地是坑](https://www.jianshu.com/p/07b5ec193353)

[iOS内购-防越狱破解刷单](https://www.jianshu.com/p/5cf686e92924)

[沙盒账号使用注意事项](https://juejin.im/post/5a367718f265da4320035351)

[ios 内购服务器验票（漏单处理）](https://blog.csdn.net/goodeveningbaby/article/details/53372934)

[iOS开发支付篇——内购(IAP)详解](http://www.cnblogs.com/TheYouth/p/6847014.html)

[iOS 内购的最新讲解(审核上线的坑)](https://www.jianshu.com/p/4f8a854ff427)

[苹果应用内购买(IAP)，服务器端开发处理流程](https://www.jianshu.com/p/7e7c3a918946)

[iOS内购 服务端票据验证及漏单引发的思考](https://www.cnblogs.com/widgetbox/p/7529970.html)

[iOS内购调研(内购类型讲解比较详细)](http://www.asunquan.com/2017/07/iOS%E5%86%85%E8%B4%AD%E8%B0%83%E7%A0%94/)

[iOS IAP内购 VS 支付宝](https://www.jianshu.com/p/dce9643acd55)

[苹果IAP开发中的那些坑和掉单问题](http://zhangtielei.com/posts/blog-iap.html)

[内购之恢复购买记录](https://www.jianshu.com/p/5d92fb42aae8)

[谈谈苹果应用内支付(IAP)的坑](https://www.jianshu.com/p/c3c0ed5af309)

官方文档：

 https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Introduction.html