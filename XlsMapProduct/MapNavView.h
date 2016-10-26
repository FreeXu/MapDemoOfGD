//
//  MapNavView.h
//  XlsMapProduct
//
//  Created by 56tg on 2016/10/25.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface MapNavView : UIView

- (void)calculateRouteWithStartPoints:(NSArray *)startPoints andEndPoints:(NSArray *)endPoints;

@end
