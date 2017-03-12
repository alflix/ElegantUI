//
//  Bug.h
//  CoreDump
//
//  Created by JieYuanZhuang on 15/3/11.
//  Copyright (c) 2015年 Michael Privat and Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Bug : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSData * screenshot;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Project *project;

@end
