//
//  ViewController.m
//  LocationDemo
//
//  Created by JieYuanZhuang on 15/3/16.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "ViewController.h"
#import "MyLocation.h"
#import "MyAnnotation.h"
#import "MyAnnotationView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self geocodeAddress];
}

-(void)geocodeAddress{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:@"广东工业大学" completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (placemarks.count>0) {
//            CLPlacemark *placemark=[placemarks firstObject];
//            CLLocation *location=placemark.location;//位置
//            CLRegion *region=placemark.region;//区域
//            NSLog(@"位置:%@,区域:%@",location,region);
        }
    }];
}

- (IBAction)getLocationMessage:(UIButton *)sender {
    __block __weak ViewController *wself = self;
    [[MyLocation shareLocation]getLocationMessageCoordinate2D:^(CLLocationCoordinate2D locationCoordinate) {
        NSString  *str = [NSString stringWithFormat:@"%f,%f",locationCoordinate.latitude,locationCoordinate.longitude];
        wself.coordinateLabel.text = str;
    }];
}

- (IBAction)getAddress:(UIButton *)sender {
    __block __weak ViewController *wself = self;
    [[MyLocation shareLocation]getLocationMessageCoordinate2D:^(CLLocationCoordinate2D locationCoordinate) {
    } address:^(NSString *string) {
        wself.addressLabel.text = string;
    } detailAddress:^(NSString *string) {
    }];
}

- (IBAction)getDetailAddress:(UIButton *)sender {
    __block __weak ViewController *wself = self;
    [[MyLocation shareLocation]getLocationMessageCoordinate2D:^(CLLocationCoordinate2D locationCoordinate) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(locationCoordinate, 2000, 2000);
        [wself.mapView setRegion:region];
//        MKCoordinateSpan span=MKCoordinateSpanMake(1, 1);
//        MKCoordinateRegion region=MKCoordinateRegionMake(locationCoordinate, span);
//        [_mapView setRegion:region animated:true];

        wself.mapView.userTrackingMode=MKUserTrackingModeFollow;
        wself.mapView.mapType=MKMapTypeStandard;
        
        //添加大头针
        MyAnnotation *annotation=[[MyAnnotation alloc]init];
        annotation.title=@"位置1";
        annotation.subtitle=@"我获取的位置";
        annotation.image=[UIImage imageNamed:@"locationImage1"];
        annotation.icon=[UIImage imageNamed:@"iconMark"];
        annotation.detail=@"哈哈";
        annotation.detailView=[UIImage imageNamed:@"iconStar"];
        annotation.coordinate=locationCoordinate;
        [wself.mapView addAnnotation:annotation];
        
        //添加我们自定义的大头针
        CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(locationCoordinate.latitude+0.002, locationCoordinate.longitude+0.002);
        MyAnnotation *annotation2 = [[MyAnnotation alloc]init];
        annotation2.title=@"位置2";
        annotation2.subtitle=@"我自定义的位置";
        annotation2.coordinate=location2;
        annotation2.image=[UIImage imageNamed:@"locationImage"];
        annotation2.icon=[UIImage imageNamed:@"iconMark"];
        annotation2.detail=@"呵呵";
        annotation2.detailView=[UIImage imageNamed:@"iconStar"];
        [wself.mapView addAnnotation:annotation2];
        
    } address:^(NSString *string) {
        //
    } detailAddress:^(NSString *string) {
        wself.detailAddressLabel.text = string;
    }];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[MyAnnotation class]]){
        static NSString *annotationIdentifier = @"AnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        if (!pinView){
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            //[pinView setPinColor:MKPinAnnotationColorGreen];
            //pinView.animatesDrop = YES;
            pinView.calloutOffset=CGPointMake(0, 1);
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a"]];
            pinView.leftCalloutAccessoryView = iconView;
        }
        pinView.annotation = annotation;
        pinView.image=((MyAnnotation *)annotation).image;
        return pinView;
    }else if ([annotation isKindOfClass:[CustomAnnotation class]]){
        MyAnnotationView *myView=[MyAnnotationView layoutMyPinViewWithMapView:_mapView];
        myView.canShowCallout = NO;
        myView.annotation = annotation;
        return myView;
    }else{
        return nil;
    }
}

#pragma mark 选中大头针时触发
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    MyAnnotation *annotation=view.annotation;
    if ([view.annotation isKindOfClass:[MyAnnotation class]]) {
        CustomAnnotation *annotation1=[[CustomAnnotation alloc]init];
        annotation1.icon=annotation.icon;
        annotation1.detail=annotation.detail;
        annotation1.detailView=annotation.detailView;
        annotation1.coordinate=view.annotation.coordinate;
        [mapView addAnnotation:annotation1];
    }
}

#pragma mark 取消选中时触发
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self removeCustomAnnotation];
}

#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotation{
    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[CustomAnnotation class]]) {
            [_mapView removeAnnotation:obj];
        }
    }];
}

@end