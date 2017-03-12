//
//  MyAnnotationView.h
//  LocationDemo
//
//  Created by JieYuanZhuang on 15/3/17.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CustomAnnotation.h"

@interface MyAnnotationView : MKPinAnnotationView

@property (nonatomic ,strong) CustomAnnotation *annotation;

+(instancetype)layoutMyPinViewWithMapView:(MKMapView *)mapView;


@end
