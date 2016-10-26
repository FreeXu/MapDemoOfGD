//
//  ShowMapView.m
//  MapDemo
//
//  Created by 56tg on 2016/10/9.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import "ShowMapView.h"

@interface ShowMapView ()<MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *mapView_show;
    AMapSearchAPI *search;
    UILabel *lbl_showAddress;
    
    CGFloat view_width;
    CGFloat view_height;
    BOOL isUserCurrentLocation;
}
@end

@implementation ShowMapView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        view_width  = CGRectGetWidth(frame);
        view_height = CGRectGetHeight(frame);
        
        //初始化
        mapView_show = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, view_width, view_height)];
        mapView_show.delegate = self;
        [self addSubview:mapView_show];
        mapView_show.showsCompass = NO;
        mapView_show.showsScale   = NO;
        mapView_show.showsUserLocation = YES;
        mapView_show.userTrackingMode = MAUserTrackingModeFollow;
        mapView_show.zoomLevel = 13.555;
        
        //搜索
        search = [[AMapSearchAPI alloc] init];
        search.delegate = self;
        
        //中心点logo
        UIView *mark = [[UIView alloc] initWithFrame:CGRectMake((view_width - 20) / 2.0, (view_height - 20) / 2.0, 20, 20)];
        mark.backgroundColor = [UIColor blueColor];
        [self addSubview:mark];
        mark.layer.cornerRadius  = 10.0;
        mark.layer.masksToBounds = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, view_height - 70, 50, 50);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:@"定位" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        btn.layer.cornerRadius  = 25.0;
        btn.layer.masksToBounds = YES;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnAction_position:) forControlEvents:UIControlEventTouchUpInside];
        
        //显示当前位置信息控件
        lbl_showAddress = [[UILabel alloc] initWithFrame:CGRectMake(100, view_height - 70, view_width - 130, 50)];
        lbl_showAddress.backgroundColor = [UIColor whiteColor];
        lbl_showAddress.textColor = [UIColor blackColor];
        lbl_showAddress.font = [UIFont systemFontOfSize:14.0];
        lbl_showAddress.textAlignment = NSTextAlignmentCenter;
        lbl_showAddress.numberOfLines = 0;
        [self addSubview:lbl_showAddress];
        lbl_showAddress.layer.cornerRadius  = 5.0;
        lbl_showAddress.layer.masksToBounds = YES;
    }
    return self;
}

- (void)btnAction_position:(UIButton *)btn {
    [mapView_show setCenterCoordinate:mapView_show.userLocation.location.coordinate animated:YES];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"纬度：%f  经度：%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    if (!isUserCurrentLocation) { //将地图显示在当前位置
        isUserCurrentLocation = YES;
        [mapView_show setCenterCoordinate:mapView_show.userLocation.location.coordinate animated:NO];
    }
    else {
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location                    = [AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
        regeo.requireExtension            = YES;
        [search AMapReGoecodeSearch:regeo];
    }
    
    //iOS  自带
//    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
//    CLLocation *tempLoction = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
//    [clGeoCoder reverseGeocodeLocation:tempLoction completionHandler: ^(NSArray *placemarks,NSError *error) {
//        for (CLPlacemark *placeMark in placemarks) {
//            NSDictionary *addressDic = placeMark.addressDictionary;
//            NSString *state = [addressDic objectForKey:@"State"];
//            NSString *city = [addressDic objectForKey:@"City"];
//            NSString *subLocality = [addressDic objectForKey:@"SubLocality"];
//            NSString *street = [addressDic objectForKey:@"Street"];
//            
//            NSLog(@"%@ %@ %@ %@",state,city,subLocality,street);
//        }
//    }];
}

#pragma mark - AMapSearchDelegate
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        NSString *province = response.regeocode.addressComponent.province;
        NSString *city     = response.regeocode.addressComponent.city;
        NSString *district = response.regeocode.addressComponent.district;
        NSLog(@"%@ %@ %@",province,city,district);
        
        NSString *address  = response.regeocode.formattedAddress;
        NSLog(@"%@",address);
        lbl_showAddress.text = address;
        
        NSString *street   = [address stringByReplacingOccurrencesOfString:province withString:@""];
        street = [street stringByReplacingOccurrencesOfString:city withString:@""];
        street = [street stringByReplacingOccurrencesOfString:district withString:@""];
        NSLog(@"%@",street);
        
        NSString *adCode = response.regeocode.addressComponent.adcode;
        NSLog(@"%@",adCode);
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
