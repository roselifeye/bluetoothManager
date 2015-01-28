//
//  SPBeacon.h
//  CompLocBlueT
//
//  Created by 叶思盼 on 15/1/27.
//  Copyright (c) 2015年 roselifeye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPBeacon : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *rssi;
@property (nonatomic, retain) NSString *uuid;

/**
 *  Distance indicator
 *
 *  Immediate: rssi is between 0 ~ -50
 *  Near: rssi is between -50 ~ -80
 *  Far: rssi is less than -80
 *  Unknown: rssi is not Immediate, Near or far
 */
@property (nonatomic, retain) NSString *distance;

@end
