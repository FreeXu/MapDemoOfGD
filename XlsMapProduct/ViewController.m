//
//  ViewController.m
//  MapDemo
//
//  Created by 56tg on 2016/10/9.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ViewController.h"
#import "ShowMapViewController.h"
#import "MapNavViewController.h"

#define IOS83_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3 )

@interface ViewController ()<AMapLocationManagerDelegate, UIActionSheetDelegate>
{
    UILabel *lbl_showAddress;
    
    CLLocationCoordinate2D startCoor;
    CLLocationCoordinate2D endCoor;
    NSString *appName;
    NSString *urlScheme;
}
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"地图相关功能";
    
    [self buildView];
    
    //定位初始化
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    [self.locationManager startUpdatingLocation]; //开始实时定位
    
    //
    endCoor = CLLocationCoordinate2DMake(28.622628, 115.808101);
    appName = @"XlsMapProduct";
    urlScheme = @"xlsmapdemo://";
}

- (void)buildView {
    //实时定位
    lbl_showAddress = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, CGRectGetWidth(self.view.frame) - 100, 30)];
    lbl_showAddress.backgroundColor = [UIColor whiteColor];
    lbl_showAddress.textColor = [UIColor blueColor];
    lbl_showAddress.font = [UIFont systemFontOfSize:12.0];
    lbl_showAddress.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl_showAddress];
    
    //获取地图中心点，并显示具体信息
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(100, 180, CGRectGetWidth(self.view.frame) - 200, 40);
    addressBtn.backgroundColor = [UIColor whiteColor];
    [addressBtn setTitle:@"中心点位置" forState:UIControlStateNormal];
    [addressBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:addressBtn];
    addressBtn.tag = 100;
    [addressBtn addTarget:self action:@selector(btnAction_skip:) forControlEvents:UIControlEventTouchUpInside];
    
    //导航
    UIButton *mapNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapNavBtn.frame = CGRectMake(100, CGRectGetMaxY(addressBtn.frame) + 30, CGRectGetWidth(self.view.frame) - 200, 40);
    mapNavBtn.backgroundColor = [UIColor whiteColor];
    [mapNavBtn setTitle:@"地图导航" forState:UIControlStateNormal];
    [mapNavBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    mapNavBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:mapNavBtn];
    mapNavBtn.tag = 101;
    [mapNavBtn addTarget:self action:@selector(btnAction_skip:) forControlEvents:UIControlEventTouchUpInside];
    
    //跳到第三方地图
    UIButton *skipMapApp = [UIButton buttonWithType:UIButtonTypeCustom];
    skipMapApp.frame = CGRectMake(100, CGRectGetMaxY(mapNavBtn.frame) + 30, CGRectGetWidth(self.view.frame) - 200, 40);
    skipMapApp.backgroundColor = [UIColor whiteColor];
    [skipMapApp setTitle:@"地图跳转" forState:UIControlStateNormal];
    [skipMapApp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    skipMapApp.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:skipMapApp];
    skipMapApp.tag = 102;
    [skipMapApp addTarget:self action:@selector(btnAction_skip:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - btn action
- (void)btnAction_skip:(UIButton *)btn {
    if (btn.tag == 100) {
        ShowMapViewController *showMapVC = [[ShowMapViewController alloc] init];
        [self.navigationController pushViewController:showMapVC animated:YES];
    }
    else if (btn.tag == 101) {
        MapNavViewController *mapNavVC = [[MapNavViewController alloc] init];
        [self.navigationController pushViewController:mapNavVC animated:YES];
    }
    else if (btn.tag == 102) {
        [self showSelectView];
    }
}

- (void)showSelectView {
    if (IOS83_OR_LATER) {
        UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            [sheetController addAction:[UIAlertAction actionWithTitle:@"百度地图"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",endCoor.latitude, endCoor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                                                              }]];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            [sheetController addAction:[UIAlertAction actionWithTitle:@"高德地图"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,endCoor.latitude,endCoor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                                                              }]];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            [sheetController addAction:[UIAlertAction actionWithTitle:@"谷歌地图"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,endCoor.latitude,endCoor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                                                              }]];
        }
        [sheetController addAction:[UIAlertAction actionWithTitle:@"苹果地图"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                                                              MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
                                                              [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                                                                             launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                                                                             MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
                                                          }]];
        [sheetController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:sheetController animated:YES completion:nil];
    } else {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"苹果地图", nil];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            [choiceSheet addButtonWithTitle:@"百度地图"];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])  {
            [choiceSheet addButtonWithTitle:@"高德地图"];
        }
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            [choiceSheet addButtonWithTitle:@"谷歌地图"];
        }
        [choiceSheet showInView:self.view];
    }
}

#pragma mark - AMapLocationManager delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    NSLog(@"lat:%f; lon:%f; accuracy:%f",location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    lbl_showAddress.text = [NSString stringWithFormat:@"实时位置：lat:%f; lon:%f;", location.coordinate.latitude, location.coordinate.longitude];
    startCoor = location.coordinate;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"百度地图"]) {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",endCoor.latitude, endCoor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"高德地图"]) {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,endCoor.latitude,endCoor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"谷歌地图"]) {
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,endCoor.latitude,endCoor.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"苹果地图"]) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
}

@end
