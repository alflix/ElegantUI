//
//  MyAnnotationView.m
//  LocationDemo
//
//  Created by JieYuanZhuang on 15/3/17.
//  Copyright (c) 2015年 JieYuanZhuang. All rights reserved.
//

#import "MyAnnotationView.h"

#define kSpacing 5
#define kDetailFontSize 12
#define kViewOffset 80

@interface MyAnnotationView(){
    UIView *_backgroundView;
    UIImageView *_iconView;
    UILabel *_detailLabel;
    UIImageView *_detailView;
}

@end

@implementation MyAnnotationView


-(instancetype)init{
    if(self=[super init]){
        [self layoutUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

-(void)layoutUI{
    _backgroundView=[[UIView alloc]init];
    _backgroundView.backgroundColor=[UIColor whiteColor];
    _iconView=[[UIImageView alloc]init];
    
    _detailLabel=[[UILabel alloc]init];
    _detailLabel.lineBreakMode=NSLineBreakByWordWrapping;
    _detailLabel.font=[UIFont systemFontOfSize:kDetailFontSize];
    
    _detailView=[[UIImageView alloc]init];
    
    [self addSubview:_backgroundView];
    [self addSubview:_iconView];
    [self addSubview:_detailLabel];
    [self addSubview:_detailView];
}


+(instancetype)layoutMyPinViewWithMapView:(MKMapView *)mapView{
    static NSString *annotationIdentifier = @"AnnotationIdentifier2";
    MyAnnotationView *pinView = (MyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!pinView){
        pinView = [[MyAnnotationView alloc]init];
    }
    return pinView;
}

-(void)setAnnotation:(CustomAnnotation *)annotation{
    [super setAnnotation:annotation];
    //根据模型调整布局
    _iconView.image=annotation.icon;
    _iconView.frame=CGRectMake(kSpacing, kSpacing, annotation.icon.size.width, annotation.icon.size.height);
    
    _detailLabel.text=annotation.detail;
    float detailWidth=150.0;
    CGSize detailSize= [annotation.detail boundingRectWithSize:CGSizeMake(detailWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kDetailFontSize]} context:nil].size;
    float detailX=CGRectGetMaxX(_iconView.frame)+kSpacing;
    _detailLabel.frame=CGRectMake(detailX, kSpacing, detailSize.width, detailSize.height);
    _detailView.image=annotation.detailView;
    _detailView.frame=CGRectMake(detailX, CGRectGetMaxY(_detailLabel.frame)+kSpacing, annotation.detailView.size.width, annotation.detailView.size.height);
    
    float backgroundWidth=CGRectGetMaxX(_detailLabel.frame)+kSpacing;
    float backgroundHeight=_iconView.frame.size.height+2*kSpacing;
    _backgroundView.frame=CGRectMake(0, 0, backgroundWidth*2, backgroundHeight);
    self.bounds=CGRectMake(0, 0, backgroundWidth, backgroundHeight+kViewOffset);
}

@end
