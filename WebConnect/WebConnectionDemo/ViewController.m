//
//  ViewController.m
//  WebConnectionDemo
//
//  Created by JieYuanZhuang on 15/3/18.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *process;
@property (strong, nonatomic) NSURLSessionDownloadTask *cancellableTask; // 可取消的下载任务
@property (strong, nonatomic) NSURLSessionDownloadTask *resumableTask;   // 可恢复的下载任务
@property (strong, nonatomic) NSURLSessionDownloadTask * backgroundDownloadTask;//后台下载任务
@property (strong, nonatomic) NSData *partialData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark --  loadData

- (IBAction)loadData:(UIButton *)sender {
    // 创建Data Task，
    NSURL *url = [NSURL URLWithString:@"http://www.jianshu.com/users/9tsPFp/latest_articles"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          // 输出返回的状态码，请求成功的话为200
                                          if (!error) {
                                              [self showResponseCode:response];
                                          }else{
                                              NSLog(@"error is :%@",error.localizedDescription);
                                          }
                                      }];
    // 使用resume方法启动任务
    [dataTask resume];
}


- (void)showResponseCode:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    NSLog(@"状态码--%ld", (long)responseStatusCode);
}

#pragma mark -- GET and POST

- (IBAction)GETRequest:(id)sender {
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"https://api.douban.com/v2/book/1220562"];
    
    NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithURL:url
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             if(error == nil)
                                                             {
                                                                 NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                 NSLog(@"GET请求数据= %@",text);
                                                             }
                                                             
                                                         }];
    
    [dataTask resume];
}


- (IBAction)POSTRequest:(UIButton *)sender {
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:@"http://hayageek.com/examples/jquery/ajax-post/ajax-post.php"];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString * params =@"name=Ravi&loc=India&age=31&submit=true";
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask =[delegateFreeSession dataTaskWithRequest:urlRequest
                                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                NSLog(@"Response:%@ %@\n", response, error);
                                                                if(error == nil)
                                                                {
                                                                    NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                                    NSLog(@"POST返回数据 = %@",text);
                                                                }
                                                                
                                                            }];
    [dataTask resume];

}


#pragma mark -- download

- (IBAction)download:(UIButton *)sender {
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    if (self.partialData) {
        self.cancellableTask = [defaultSession downloadTaskWithResumeData:self.partialData];
    }
    else{
    NSURL * url = [NSURL URLWithString:@"http://pic3.zhimg.com/9ff80696f539f18c52933275feaceaca_r.jpg"];
    self.cancellableTask =[ defaultSession downloadTaskWithURL:url];
    }
    [self.cancellableTask resume];
}

//为了实现下载进度的显示，需要在委托中的以下方法中实现：
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(),^ {
        [self.process setProgress:progress animated:YES];
    });
    NSLog(@"Progress =%f",progress);
    NSLog(@"Received: %lld bytes (Downloaded: %lld bytes)  Expected: %lld bytes.\n",
          bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

//转移下载后文件的目录
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if (downloadTask == self.cancellableTask) {
        NSLog(@"Temporary File :%@\n", location);
        NSError *err = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSURL *docsDirURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"out1.zip"]];
        if ([fileManager moveItemAtURL:location
                                 toURL:docsDirURL
                                 error: &err]){
            NSLog(@"File is saved to =%@",docsDir);
        }
        else{
            NSLog(@"failed to move: %@",[err userInfo]);
        }
    }else if(downloadTask == self.backgroundDownloadTask){
        NSLog(@"Background URL session %@ finished events.\n", session);
        
        AppDelegate * delegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(delegate.completionHandler)
        {
            void (^handler)() = delegate.completionHandler;
            handler();
        }
    }
}

//取消下载
- (IBAction)cancleDownload:(UIButton *)sender {
    if (self.cancellableTask) {
        [self.cancellableTask cancelByProducingResumeData:^(NSData *resumeData) {
            self.partialData = resumeData;
        }];
        self.cancellableTask = nil;
    }
}



//恢复下载时，NSURLSessionDownloadDelegate中的以下方法将被调用：
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    NSLog(@"NSURLSessionDownloadDelegate: Resume download at %lld", fileOffset);
}



#pragma mark -- background download

- (IBAction)downoadBackground:(id)sender {
    NSURL * url = [NSURL URLWithString:@"https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaEncyclopedia/CocoaEncyclopedia.pdf"];
    NSURLSessionConfiguration * backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"backgroundtask1"];
    
    NSURLSession *backgroundSeesion = [NSURLSession sessionWithConfiguration: backgroundConfig delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    self.backgroundDownloadTask =[ backgroundSeesion downloadTaskWithURL:url];
    [self.backgroundDownloadTask resume];
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session

{
    NSLog(@"Background URL session %@ finished events.\n", session);
    
    AppDelegate * delegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(delegate.completionHandler)
    {
        void (^handler)() = delegate.completionHandler;
        handler();
    }    
}

@end
