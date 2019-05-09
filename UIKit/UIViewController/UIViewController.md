作为每个初学者99.9%会接触到的UIViewController，这篇文章主要来讲讲UIViewController的生命周期。

我们从一个例子来证明这个结论：

如下是storyBoard的配置：

ViewController.m

```objective-c
@interface ViewController ()
@property (nonatomic,strong)NSString *str;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end
```

下面是生命周期有关的方法：

```objective-c
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"0");
    }
    return self;
}

-(void)awakeFromNib{
    NSLog(@"1");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"2");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"3");
}

-(void)viewWillLayoutSubviews{
    NSLog(@"4");
}

-(void)viewDidLayoutSubviews{
    NSLog(@"5");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"6");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"7");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"8");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
```

运行后点击按钮跳转到第二个控制器，打印如下：


```objective-c
2015-03-24 00:00:44.771 test[2925:305854] 0
2015-03-24 00:00:44.772 test[2925:305854] 1
2015-03-24 00:00:44.778 test[2925:305854] 2
2015-03-24 00:00:44.779 test[2925:305854] 3
2015-03-24 00:00:44.785 test[2925:305854] 4
2015-03-24 00:00:44.785 test[2925:305854] 5
2015-03-24 00:00:44.788 test[2925:305854] 6
2015-03-24 00:00:47.982 test[2925:305854] 7
2015-03-24 00:00:47.987 test[2925:305854] 4
2015-03-24 00:00:47.988 test[2925:305854] 5
2015-03-24 00:00:48.489 test[2925:305854] 8
```

也就是说，ViewController的生命周期基本是下面的步骤：

Instantiated ：初始化
awakeFromNib：主要做一些viewDidLoad之前的事情
outlets 的配置
viewDidLoad
viewWillLayoutSubviews和viewDidLayoutSubviews:
viewWillAppear和viewDidAppear
￼viewWillDisappear: and viewDidDisappear
didReceiveMemoryWarning：收到内存警告
现在不存在“unload”方法

你可能会问为什么outlets 的配置介于awakeFromNib和viewDidLoad之间呢，我们可以通过下面的代码证实一下：

```objective-c
-(void)awakeFromNib{
    NSLog(@"1");
    [_button setTitle:@"哈哈" forState:UIControlStateNormal];
}
```

运行结果发现按钮的标题并没有发生变化，我们再看：

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    [_button setTitle:@"呵呵" forState:UIControlStateNormal];
    NSLog(@"2");
}
```

运行结果发现按钮的标题发生变化了，所以可以知道outlets 的配置是介于awakeFromNib和viewDidLoad，这点比较重要。


1.initWithCoder ，
关于initWithCoder ，你是不是觉得它更应该出现在[数据持久化](http://www.jianshu.com/p/1a8d286ea83c)中呢？确实它是一个NSCoding protocol, 所以你在UIViewController的文档中不会找到它。initWithCoder 是一个类在IB中创建但在xocde中被实例化时被调用的。你可以理解为是一个解固过程，所以在这个时候view还没初始化，你可以完成一些需要在view未初始化之前调用的方法。注意这个方法在生命周期中只会调用一次。

2.awakeFromNib
当.nib文件或storyBoard文件被加载的时候，会发送一个awakeFromNib的消息到.nib文件或storyBoard文件中的每个对象，每个对象都可以定义自己的awakeFromNib函数来响应这个消息，执行一些必要的操作。也就是说通过nib文件创建view对象时执行awakeFromNib

如果你不是从.nib文件或storyBoard文件中加载view，你可以在loadView方法通过代码初始化view。

3.viewWillLayoutSubviews和viewDidLayoutSubviews

viewWillAppear和viewDidAppear前会调用改方法，主要是和布局相关。在当几何方向改变时也会再次调用以下方法，例如旋转方向变化。
(当选择方向改变还会收到 will/didRotateTo/From messages)

再说下可能会看到的initWithNibName 和 loadNibNamed。
主要是用于加载子view，使用此方法加载用户界面（xib文件）到我们的代码中，这样，可以通过操作这个加载进来的（xib）对象，来操作xib文件内容。 它们之间的区别是initWithNibName方法：是延迟加载，这个View上的控件是 nil 的，只有到 需要显示时，才会不是 nil 。
loadNibNamed方法：即时加载，用该方法加载的xib对象中的各个元素都已经存在。

```objective-c
- (void)submitShare:(id)sender
{
    if (![self checkInputContentLegal]) {
        return;
    }
    [_textView resignFirstResponder];
    if (!_locationEnable) {//如果不显示地理位置
        _latitude = 0;
        _longtitude = 0;
        NSLog(@"不显示地理位置");
    }else{
        NSLog(@"显示地理位置,%f,%f",_latitude,_longtitude);
    }
    NSString *accseeToken = [AccountTool sharedAccountTool].account.accessToken;
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUploadURL]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSString *encodeStatus = _textView.text;
    if (_images.count == 0) {
        [manager POST:@"2/statuses/update.json"
           parameters:@{@"access_token": accseeToken,
                             @"status" : encodeStatus,
                             @"visible" : @(_intVisible),
                             @"lat" : @(_latitude),
                             @"long" : @(_longtitude)}
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  NSLog(@"发送成功");
                  [self showSuccessHUD];
                  [self performSelector:@selector(back) withObject:self afterDelay:1.5];
                }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  [self showFailHUD];
                  NSLog(@"发送失败");
                }];
    }else{
        [manager POST:@"2/statuses/upload.json"
           parameters:@{@"access_token": accseeToken,
                           @"status" : encodeStatus,
                           @"visible" : @(_intVisible),
                           @"lat" : @(_latitude),
                           @"long" : @(_longtitude)}
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSMutableArray *images = [NSMutableArray arrayWithArray:weakSelf.images];
                for (id asset in images) {
                    NSData *data = nil;
                    if ([asset isKindOfClass:[UIImage class]]) {
                        data = UIImageJPEGRepresentation(asset, 0.4);
                    }
                    if ([asset isKindOfClass:ALAsset.class]) {
                        UIImage *original = [UIImage imageWithCGImage: [[asset defaultRepresentation] fullScreenImage]];
                        data = UIImageJPEGRepresentation(original, 0.4);
                    }
                    [formData appendPartWithFileData:data name:@"pic" fileName:@"pic.jpg" mimeType:@"multipart/form-data"];
                    //新浪开放的API一次只能上传一张图片，选择多张的时候会使用最后一张，通过调用[http://open.weibo.com/wiki/2/statuses/upload_pic]() 接口生成高级接口statuses/upload_url_text中的参数pic_id，可以实习上传多张图片
                }
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"发送成功");
                [self back];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showFailHUD];
            }];
    }
}
```