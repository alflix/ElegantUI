//
//  MyLocation.m
//  LocationDemo
//
//  Created by JieYuanZhuang on 15/3/16.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "MyLocation.h"

@interface MyLocation ()

@property (nonatomic,strong)locationCorrrdinate locationCoordinateBlock;
@property (nonatomic,strong) address addressBlock;
@property (nonatomic,strong) address detailAddressBlock;
@end

@implementation MyLocation
{
    CLLocationManager *_manager;
}

+ (MyLocation *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(void)getLocationMessageCoordinate2D:(locationCorrrdinate)locationCoordinate{
    self.locationCoordinateBlock = [locationCoordinate copy];
    [self startLocation];
}

-(void)getLocationMessageCoordinate2D:(locationCorrrdinate)locationCoordinate address:(address)address detailAddress:(address)detailAddress{
    self.locationCoordinateBlock = [locationCoordinate copy];
    self.addressBlock = [address copy];
    self.detailAddressBlock = [detailAddress copy];
    [self startLocation];
}

//delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *loc = [locations firstObject];
    self.coordinate = loc.coordinate;
    self.locationCoordinateBlock(loc.coordinate);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];

    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            _address = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.locality];
            _detailAddress = [NSString stringWithFormat:@"%@",placemark.name];//详细地址
            
             //        NSString *name=placemark.name;//地名
             //        NSString *thoroughfare=placemark.thoroughfare;//街道
             //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
             //        NSString *locality=placemark.locality; // 城市
             //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
             //        NSString *administrativeArea=placemark.administrativeArea; // 州
             //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
             //        NSString *postalCode=placemark.postalCode; //邮编
             //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
             //        NSString *country=placemark.country; //国家
             //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
             //        NSString *ocean=placemark.ocean; // 海洋
             //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        }
        if (self.addressBlock) {
            self.addressBlock(_address);
        }
        if (self.detailAddressBlock) {
            self.detailAddressBlock(_detailAddress);
        }
    }];
}

-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _manager=[[CLLocationManager alloc]init];
        _manager.delegate=self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;//desiredAccuracy：定位精确度
        _manager.distanceFilter=100;//distanceFilter：每隔多少米定位一次
        [_manager requestAlwaysAuthorization];
        [_manager startUpdatingLocation];
    }
    else {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你还未开启定位服务" delegate:nil cancelButtonTitle:@"设置" otherButtonTitles: @"取消", nil];
        alvertView.delegate = self;
        [alvertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (&UIApplicationOpenSettingsURLString != NULL) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self stopLocation];
}

-(void)stopLocation{
    _manager = nil;
}

@end