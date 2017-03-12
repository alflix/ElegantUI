//
//  MyLocation.h
//  LocationDemo
//
//  Created by JieYuanZhuang on 15/3/16.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyLocation : NSObject<CLLocationManagerDelegate,UIAlertViewDelegate>

typedef void (^locationCorrrdinate)(CLLocationCoordinate2D locationCoordinate);
typedef void(^address)(NSString *string);

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *detailAddress;
@property(nonatomic,assign)float latitude;
@property(nonatomic,assign)float longitude;

-(void)getLocationMessageCoordinate2D:(locationCorrrdinate)locationCoordinate;

-(void)getLocationMessageCoordinate2D:(locationCorrrdinate)locationCoordinate address:(address)address detailAddress:(address)detailAddress;

+ (MyLocation *)shareLocation;
@end
