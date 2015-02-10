//
//  blueToothManager.m
//  CompLocBlueT
//
//  Created by 叶思盼 on 15/1/27.
//  Copyright (c) 2015年 roselifeye. All rights reserved.
//

#import "SPBlueToothManager.h"


@implementation SPBlueToothManager

+ (SPBlueToothManager *)shareInstance {
    static SPBlueToothManager *btManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        btManager = [[SPBlueToothManager alloc] init];
    });
    return btManager;
}

-(id)init{
    self = [super init];
    
    beaconManager = [[CBCentralManager alloc] initWithDelegate:self
                                                         queue:nil
                                                       options:nil];
    //self.beacons = [NSMutableArray new];
    beaconsDic = [NSMutableDictionary new];
    
    return self;
}

- (void)discoverBeacons {
    
    [self scanBegin];
}

- (void)scanBegin {
    //If CBConnectPeripheralOptionNotifyOnDisconnectionKey is YES, it will let the system show all the results without filter
    [beaconManager scanForPeripheralsWithServices:nil options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                                                          forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
}
/*
 // To refresh the value of RSSI every 2 seconds
 - (void)refreshRSSI {
 if (!self.timer) {
 self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
 target:self
 selector:@selector(readRSSI)
 userInfo:nil
 repeats:1.0];
 [[NSRunLoop currentRunLoop] addTimer:self.timer
 forMode:NSDefaultRunLoopMode];
 }
 }
 */

- (void)connectBeaconWithPeripheral:(CBPeripheral *) peripheral{
    
    //[beaconManager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnConnectionKey]];
    [beaconManager connectPeripheral:peripheral
                             options:nil];
    //NSLog(@"peri %@", peripheral.name);
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"State not powered on");
        return;
    }
    [self scanBegin];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    // Filter the Beacons we want
    NSString *filterStr = _beaconFilterID;
    switch (_filterType) {
        case 1:
            // The [String length]>0 is in order to avoiding get the null name of the peripheral.name
            if ([peripheral.name rangeOfString:filterStr].location != NSNotFound
                && [peripheral.name length] > 0) {
                // Dictionary用法
                SPBeacon *beacon = [beaconsDic objectForKey:peripheral.name];
                if (beacon != nil) {
                    if ([beacon.lastRefreshTime timeIntervalSinceNow] >= 1.0f) {
                        [beacon.rssi addObject:RSSI];
                        beacon.lastRefreshTime = [NSDate date];
                        // This funtion is to designed to remove the expired datas.
                        if ([beacon.rssi count] > 10) {
                            [beacon.rssi removeObjectsInRange:NSMakeRange (0, 9)];
                        }
                        [_delegate beaconManagerDidDiscoverBeacons:beaconsDic];
                    }
                } else {
                    [self centralManager:central
                         storeNewBeacons:peripheral
                                    RSSI:RSSI];
                }
                /*
                 //Array用法
                 [self.beacons addObject:peripheral];
                 //[self connectBeaconWithPeripheral:peripheral];
                 //今天先做到这里，接下来将做数据的更新。每秒一次，
                 for (SPBeacon *beacon in self.beacons) {
                 
                 //这是用来过滤字段的
                 NSPredicate *predicate;
                 predicate = [NSPredicate predicateWithFormat:@"name==%@", peripheral.name];
                 if ([predicate evaluateWithObject:beacon]) {
                 NSLog(@"123");
                 }
                 }*/
            }
            break;
        case 2:
            // Same as above
            if ([peripheral.identifier.UUIDString rangeOfString:filterStr].location != NSNotFound && [peripheral.identifier.UUIDString length] > 0) {
                [central connectPeripheral:peripheral options:nil];
                [self centralManager:central
                     storeNewBeacons:peripheral
                                RSSI:RSSI];
            }
            break;
            
        default:
            break;
    }
}

/**
 The function is designed to store new beacon.
 **/
- (void)centralManager:(CBCentralManager *)central storeNewBeacons:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Name :%@", peripheral.name);
    NSLog(@"RSSI :%d", [RSSI intValue]);
    SPBeacon *beacon = [[SPBeacon alloc] init];
    beacon.name = peripheral.name;
    [beacon.rssi addObject: [NSString stringWithFormat:@"%d", [RSSI intValue]]];
    beacon.uuid = [NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString];
    beacon.lastRefreshTime = [NSDate date];
    [beaconsDic setObject:beacon forKey:peripheral.name];
    
    //[self.beacons addObject:beacon];
    
    [_delegate beaconManagerDidDiscoverBeacons:beaconsDic];
}


- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    NSLog(@"run");
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected");
    peripheral.delegate = self;
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [beaconManager connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect");
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error {
    NSLog(@"Got RSSI update: %4.1f", [RSSI doubleValue]);
}

@end
