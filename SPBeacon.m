//
//  SPBeacon.m
//  CompLocBlueT
//
//  Created by 叶思盼 on 15/1/27.
//  Copyright (c) 2015年 roselifeye. All rights reserved.
//

#import "SPBeacon.h"

@implementation SPBeacon

- (void)setRssi:(NSString *)rssi {
    /**
     *  Distance indicator
     *
     *  Immediate: rssi is between 0 ~ -50
     *  Near: rssi is between -50 ~ -80
     *  Far: rssi is less than -80
     *  Unknown: rssi is not Immediate, Near or far
     **/
    _rssi = [rssi copy];
    if ([rssi intValue] <= 0) {
        _distance = @"Immediate";
        if ([rssi intValue] <= -50) {
            _distance = @"Near";
            if ([rssi intValue] <= -80) {
                _distance = @"Far";
            }
        }
    } else {
        _distance = @"Unknown";
    }
}


@end
