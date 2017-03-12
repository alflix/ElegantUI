//
//  AFNViewController.m
//  WebConnectionDemo
//
//  Created by JieYuanZhuang on 15/3/18.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "AFNViewController.h"
#import "AFNetworking.h"

#define kFILEPROTOCOL @"file://"

@interface AFNViewController ()<UISearchBarDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonForward;


@end

@implementation AFNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkNetworkStatus];
    self.searchBar.delegate = self;
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
}

-(void)alert:(NSString *)message{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"System Info" message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [alertView show];
}

-(void)checkNetworkStatus{
    //创建一个用于测试的url
    NSURL *url=[NSURL URLWithString:@"http://www.apple.com"];
    AFHTTPRequestOperationManager *operationManager=[[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
    
    //根据不同的网络状态改变去做相应处理
    [operationManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self alert:@"2G/3G/4G Connection."];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self alert:@"WiFi Connection."];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [self alert:@"Network not found."];
                break;
            default:
                [self alert:@"Unknown."];
                break;
        }
    }];
    //开始监控
    [operationManager.reachabilityManager startMonitoring];
}

- (IBAction)webBack:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (IBAction)webForward:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

#pragma mark 浏览器请求
-(void)request:(NSString *)urlStr{
    //创建url
    NSURL *url;
    
    //如果file://开头的字符串则加载bundle中的文件
    if([urlStr hasPrefix:kFILEPROTOCOL]){
        //取得文件名
        NSRange range= [urlStr rangeOfString:kFILEPROTOCOL];
        NSString *fileName=[urlStr substringFromIndex:range.length];
        url=[[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    }else if(urlStr.length>0){
        //如果是http请求则直接打开网站
        if ([urlStr hasPrefix:@"http"]) {
            url=[NSURL URLWithString:urlStr];
        }else{//如果不符合任何协议则进行搜索
            urlStr=[NSString stringWithFormat:@"http://m.bing.com/search?q=%@",urlStr];
        }
        urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//url编码
        url=[NSURL URLWithString:urlStr];
        
    }
    
    //创建请求
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    //加载请求页面
    [_webView loadRequest:request];
}

#pragma mark - WebView 代理方法
-(void)webViewDidStartLoad:(UIWebView *)webView{
    //显示网络请求加载
    [UIApplication sharedApplication].networkActivityIndicatorVisible=true;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //隐藏网络请求加载图标
    [UIApplication sharedApplication].networkActivityIndicatorVisible=false;
    //设置按钮状态
    [self setBarButtonStatus];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error detail:%@",error.localizedDescription);
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"网络连接发生错误!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}


#pragma mark - SearchBar 代理方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self request:_searchBar.text];
    [searchBar resignFirstResponder];
}

-(void)setBarButtonStatus{
    if (_webView.canGoBack) {
        _barButtonBack.enabled=YES;
    }else{
        _barButtonBack.enabled=NO;
    }
    if(_webView.canGoForward){
        _barButtonForward.enabled=YES;
    }else{
        _barButtonForward.enabled=NO;
    }
}

@end
