//
//  blueToothManager.m
//  CompLocBlueT
//
//  Created by 叶思盼 on 15/1/27.
//  Copyright (c) 2015年 roselifeye. All rights reserved.
//

#import "SPBlueToothManager.h"


@implementation SPBlueToothManager

-(id)init{
    self = [super init];
    
    beaconManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    
    if (beaconManager.state != CBCentralManagerStatePoweredOn) {
        //return;
    }
    [beaconManager scanForPeripheralsWithServices:nil options:nil];
    
    return self;
}


#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    [beaconManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered Name: %@", peripheral.name);
    NSLog(@"Discovered RSSI: %d", [RSSI intValue]);
    if ([peripheral.name length] > 8) {
        if ([[peripheral.name substringToIndex:7] isEqualToString:@"D05FB8"]) {
            SPBeacon *beacon = [[SPBeacon alloc] init];
            beacon.name = peripheral.name;
            beacon.rssi = [NSString stringWithFormat:@"%d", [RSSI intValue]];
            
            [_delegate beaconManagerDidDiscoverBeacon:beacon];
        }
    }
}

@end
