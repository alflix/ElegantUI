//
//  JJMemoryViewController.m
//  MemoryManagement
//
//  Created by jieyuan on 2017/6/9.
//  Copyright © 2017年 jieyuan. All rights reserved.
//

#import "JJMemoryViewController.h"
#import "JJMemoryObject.h"
#import "JJTestMemoryViewController.h"
#import "NSTimer+JJHelper.h"
#import "JJMRCTestObject.h"

@interface JJMemoryViewController ()

@property (nonatomic, copy) NSArray *imageArray;

@end

@implementation JJMemoryViewController{
    JJMemoryObject *_object;
    NSData *_loadData;
    NSTimer __weak *_timer;
    UIImageView *_imageView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _object = [JJMemoryObject new];
    NSString *s = @"";
    [self testStackAndHeap:&s];
}

#pragma mark - 堆和栈

- (void)testStackAndHeap:(NSString **)str{
    int a = 0;
    NSNumber *b = @(1);
    char *p = malloc(3);
    JJMemoryObject *c = [JJMemoryObject new];
    void (^d)() = ^{};
    NSLog(@"\n a:%d, &a:%p, \n b:%p, &b:%p,size: %lu \n c:%p,&c:%p,size: %lu\n d:%p, &d:%p",a,&p,b,&b,sizeof(&b), c,&c,sizeof(c), d,&d);
    JJMRCTestObject *object = [JJMRCTestObject new];
}

#pragma mark - 互相引用问题

- (void)dealloc{
    _object = nil;
    [_timer invalidate];
    NSLog(@"JJMemoryViewController dealloc");
}

#pragma mark - Block 问题

- (void)downloadData{
    __weak typeof(self) weakSelf = self;
    [_object loadDataWithCompletionHandler:^(NSData *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_loadData = data;
    }];
}

- (void)easyDownloadData{
    [JJMemoryObject easyLoadDataWithCompletionHandler:^(NSData *data) {
        _loadData = data;
    }];
}

- (void)testPushViewController{
    [self.navigationController pushViewController:[JJTestMemoryViewController new] animated:YES];
}

#pragma mark - performSelector 问题

- (void)testPerformSelector{
    NSNumber *number = @2;
    
    //编译器报错
//    [_object performSelector:@selector(copyOne:) withObject:nil];
    
    SEL selector = number.integerValue > 1?@selector(copyOne:):@selector(addOne:);
    _object = [_object performSelector:selector withObject:number];
}

#pragma mark Timer 问题

- (void)testTimer{
    //    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
    //                                              target:self
    //                                            selector:@selector(timerFire:)
    //                                            userInfo:nil
    //                                             repeats:YES];
    _timer = [NSTimer jj_scheduledTimerWithTimeInterval:1 block:^{
        NSLog(@"\n A 界面");
    } repeats:YES];
    [_timer fire];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [_timer invalidate];
}

- (void)cleanTime{
    [_timer invalidate];
}

-(void)timerFire:(id)userinfo {
    NSLog(@"\n A 界面");
}

#pragma mark - 非 OC 对象内存处理

- (void)CGObjectReleaseExample{
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
}

#pragma mark - 留意内存警告

- (void)didReceiveMemoryWarning{
    self.imageArray = nil;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[[UIImage imageNamed:@"large_image1"],[UIImage imageNamed:@"large_image2"],[UIImage imageNamed:@"large_image3"],[UIImage imageNamed:@"large_image4"]];
    }
    return _imageArray;
}

#pragma mark - 使用 autoReleasePool 降低内存峰值

- (void)autoreleasePoolTest{
    NSMutableArray *memoryUsageList1 = [NSMutableArray array];
    
    for (int i = 0; i < 100000; i++) {
        NSNumber *num = [NSNumber numberWithInt:i];
        NSString *str = [NSString stringWithFormat:@"%d ", i];
        NSString *getMemoryUsage = [NSString stringWithFormat:@"%@%@", num, str];
        [memoryUsageList1 addObject:getMemoryUsage];
    }
    
    for (int i = 0; i < 100000; i++) {
        @autoreleasepool {
            NSNumber *num = [NSNumber numberWithInt:i];
            NSString *str = [NSString stringWithFormat:@"%d ", i];
            NSString *getMemoryUsage = [NSString stringWithFormat:@"%@%@", num, str];
            [memoryUsageList1 addObject:getMemoryUsage];
        }
    }
}

#pragma mark - 图片的读取问题

- (void)imageLoad{
    //smallImage 可以放在 Assets.xcassets
    UIImage *image1 = [UIImage imageNamed:@"smallImage"];
    //bigImage 这张图不能放在 Assets.xcassets，按照下面这种写法可以自动适配 @2x 和 @3x
    NSString *path =  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bigImage.png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:@"bigImage"];
}

#pragma mark - NSData 的读取问题

- (void)dataLoad{
    NSString *path = @"test";
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error = nil;
    NSData *data1 = [[NSData alloc] initWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
}

@end
