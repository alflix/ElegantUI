//
//  KVCModel.m
//  CommunicationPatterns
//
//  Created by JieYuanZhuang on 15/2/28.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "Contact.h"

@interface Contact()
@property (nonatomic, readwrite, assign) NSUInteger count;
@end

@implementation Contact

- (instancetype)init
{
    self = [super init];
    if (self) {
        _address = [[Address alloc]init];
        self.name = @"庄洁元";
        self.city = @"潮州";
        self.dic = @{@"1":@"一",@"2":@"二"};
    }
    return self;
}

- (NSUInteger)countOfNumbers {
    return 2;
}

- (id)objectInNumbersAtIndex:(NSUInteger)index {
    return @(index * 2);
}

//-(NSArray *)getNumbers{
//    return [NSArray arrayWithObjects:@"sss",@"ddd", nil];
//}


//KVO
- (BOOL)isReady {
    return (self.object && [self.property length] > 0);
}

- (void)update {
    NSLog(@"KVO--%@",self.isReady ?
          [[self.object valueForKeyPath:self.property] description]
          : @"");
}


- (void)removeObservation {
    if (self.isReady) {
        [self.object removeObserver:self
                         forKeyPath:self.property];
    }
}

- (void)addObservation {
    if (self.isReady) {
        [self.object addObserver:self forKeyPath:self.property
                         options:0
                         context:(void*)self];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ((__bridge id)context == self) {
        // Our notification, not our superclass’s
        [self update];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

- (void)dealloc {
    if (_object && [_property length] > 0) {
        [_object removeObserver:self
                     forKeyPath:_property
                        context:(void *)self];
    }
}

- (void)setObject:(id)anObject {
    [self removeObservation];
    _object = anObject;
    [self addObservation];
    [self update];
}

- (void)setProperty:(NSString *)aProperty {
    [self removeObservation];
    _property = aProperty;
    [self addObservation];
    [self update];
}

@end
