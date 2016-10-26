//
//  MapNavView.m
//  XlsMapProduct
//
//  Created by 56tg on 2016/10/25.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import "MapNavView.h"

@interface MapNavView ()<AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>
{

}
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;

@end

@implementation MapNavView

- (AMapNaviDriveManager *)driveManager {
    if (!_driveManager) {
        _driveManager = [[AMapNaviDriveManager alloc] init];
        _driveManager.delegate = self;
    }
    return _driveManager;
}

- (AMapNaviDriveView *)driveView {
    if (!_driveView) {
        _driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _driveView.delegate = self;
        _driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _driveView.showUIElements = NO;
        _driveView.showTrafficLayer = NO;
    }
    return _driveView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.driveManager addDataRepresentative:self.driveView];
        [self addSubview:self.driveView];
    }
    return self;
}

- (void)calculateRouteWithStartPoints:(NSArray *)startPoints andEndPoints:(NSArray *)endPoints {
    [self.driveManager calculateDriveRouteWithStartPoints:startPoints
                                                endPoints:endPoints
                                                wayPoints:nil
                                          drivingStrategy:AMapNaviDrivingStrategyMultipleAvoidCostAndCongestion];
}

#pragma mark - AMapNaviDriveManagerDelegate
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    NSLog(@"success");
    
//    [self.driveManager startGPSNavi];
    [self.driveManager startEmulatorNavi];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
