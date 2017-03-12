//
//  AppDelegate.m
//  WebConnectionDemo
//
//  Created by JieYuanZhuang on 15/3/18.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    NSLog(@"Save completionHandler");
    self.completionHandler = completionHandler;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

@end
