//
//  blueToothManager.h
//  CompLocBlueT
//
//  Created by 叶思盼 on 15/1/27.
//  Copyright (c) 2015年 roselifeye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SPBeacon.h"

#pragma mark - blueToothManagerDelegate
@protocol SPBlueToothManagerDelegate <NSObject>

@required
- (void)beaconManagerDidDiscoverBeacon:(SPBeacon *)beacon;

@end

@interface SPBlueToothManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
    
    CBCentralManager *beaconManager;
}

@property (nonatomic,assign) id<SPBlueToothManagerDelegate> delegate;

/**
 timer is designed to run a runloop to refresh RSSI
 **/
@property (nonatomic, retain) NSTimer *timer;

- (void)discoverBeacons;

@end
