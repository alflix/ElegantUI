//
//  ContextSetup.m
//  CoreDataDemo
//
//  Created by JieYuanZhuang on 15/3/10.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "ContextSetup.h"


@interface ContextSetup ()

@property (nonatomic,strong,readwrite) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSURL* modelURL;
@property (nonatomic,strong) NSURL* storeURL;
@property (nonatomic,strong) UIManagedDocument *document;
@end


@implementation ContextSetup

- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL{
    self = [super init];
    if (self) {
        self.storeURL = storeURL;
        self.modelURL = modelURL;
        [self setupManagedObjectContext];
    }
    return self;
}


//设置 Core Data 堆栈(相当于建立数据库)：为其提供一个 Core Data 模型和一个文件名，会返回一个 managed object context。该堆栈拥有持久化存储协调器的 managed object context。
- (void)setupManagedObjectContext {
    //初始化：在比较老的代码中，你可能见到 [[NSManagedObjectContext alloc] init]。现在你应该用 initWithConcurrencyType: 初始化，以明确你是使用基于队列的并发模型。
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    //设置持久化存储协调器
    _managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    
    NSError* error;
    [_managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                   configuration:nil
                                                                             URL:self.storeURL
                                                                         options:nil
                                                                           error:&error];
    //当Core Data数据模型改变时，就会暂停操作。你可以通过设置选项来告诉Core Data在遇到这种情况后怎么做.例如删掉原有的数据库重新建立等。
    if (error) {
        NSLog(@"error: %@", error);
    }
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    
}


- (NSManagedObjectModel*)managedObjectModel {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end
