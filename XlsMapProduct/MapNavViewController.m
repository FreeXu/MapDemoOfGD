//
//  MapNavViewController.m
//  XlsMapProduct
//
//  Created by 56tg on 2016/10/25.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import "MapNavViewController.h"
#import "MapNavView.h"

@interface MapNavViewController ()
{
    MapNavView *mapNavView;
}
@end

@implementation MapNavViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地图导航";
    
    mapNavView = [[MapNavView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    [self.view addSubview:mapNavView];
    
    AMapNaviPoint *start = [AMapNaviPoint locationWithLatitude:28.695495 longitude:115.849769];
    AMapNaviPoint *end = [AMapNaviPoint locationWithLatitude:28.622628 longitude:115.808101];
    [mapNavView calculateRouteWithStartPoints:@[start] andEndPoints:@[end]];
}

@end
