//
//  ShowMapViewController.m
//  MapDemo
//
//  Created by 56tg on 2016/10/10.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import "ShowMapViewController.h"
#import "ShowMapView.h"

@interface ShowMapViewController ()
{
    ShowMapView *showMapView;
}
@end

@implementation ShowMapViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"中心位置信息";
    
    showMapView = [[ShowMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:showMapView];
}

@end
