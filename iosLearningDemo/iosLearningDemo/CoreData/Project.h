//
//  Project.h
//  CoreDump
//
//  Created by JieYuanZhuang on 15/3/11.
//  Copyright (c) 2015年 Michael Privat and Rob Warner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bug;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *bugs;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addBugsObject:(Bug *)value;
- (void)removeBugsObject:(Bug *)value;
- (void)addBugs:(NSSet *)values;
- (void)removeBugs:(NSSet *)values;

@end
