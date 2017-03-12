//
//  CustomAnnotation.h
//  LocationDemo
//
//  Created by JieYuanZhuang on 15/3/17.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic,strong) UIImage *icon;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,strong) UIImage *detailView;

@end
