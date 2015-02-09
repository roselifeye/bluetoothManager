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
/**
 Once the system get the new beacon, this function will be recalled.
 **/
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

/**
 beaconFilterID is the prefix-characters of beacons' name or UUID, aimed to filter bluetooth devices which you want.
 **/
@property (nonatomic, retain) NSString *beaconFilterID;
/**
 filterType is the type of bluetooth devices filter,
 has two types: 1 = name;
 2 = UUID;
 **/
@property (nonatomic) int filterType;
/**
 beacons shows that all the beacons you get;
 **/
@property (strong,nonatomic) NSMutableArray *beacons;


/**
 Start to search beacons
 **/
- (void)discoverBeacons;



@end
