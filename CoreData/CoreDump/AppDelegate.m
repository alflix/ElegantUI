//
//  AppDelegate.m
//  CoreDump
//
//  Created by JieYuanZhuang on 15/3/10.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "AppDelegate.h"
#import "ContextSetup.h"
#import "MasterViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) ContextSetup* contextSetup;
@property (strong, nonatomic) NSManagedObjectContext *databaseContext;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    self.contextSetup = [[ContextSetup alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    self.databaseContext = self.contextSetup.managedObjectContext;
    controller.managedObjectContext = self.databaseContext;
    application.applicationSupportsShakeToEdit = YES;
    return YES;
}

//保存
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [self saveContext];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.databaseContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSURL*)storeURL
{
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    NSLog(@"路径-%@",[documentsDirectory URLByAppendingPathComponent:@"db.sqlite"]);
    
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"CoreDump" withExtension:@"momd"];
}

@end
