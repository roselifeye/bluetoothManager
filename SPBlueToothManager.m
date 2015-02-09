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
    self.beacons = [NSMutableArray new];
    
    return self;
}

- (void)discoverBeacons {
    
    [self scanBegin];
}

- (void)scanBegin {
    //If CBConnectPeripheralOptionNotifyOnDisconnectionKey is YES, it will let the system show all the results without filter
    [beaconManager scanForPeripheralsWithServices:nil options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                                                          forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
}

//To refresh the value of RSSI every 2 seconds
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

- (void)connectBeaconWithPeripheral:(CBPeripheral *) peripheral{
    
    //[beaconManager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnConnectionKey]];
    [beaconManager connectPeripheral:peripheral options:nil];
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
    
    NSString *filterStr = _beaconFilterID;
    //    NSLog(@"%@", peripheral.identifier.UUIDString);
    
    switch (_filterType) {
        case 1:
            //The [String length]>0 is in order to avoiding get the null name of the peripheral.name
            if ([peripheral.name rangeOfString:filterStr].location != NSNotFound && [peripheral.name length] > 0) {
                //[self.beacons addObject:peripheral];
                [self connectBeaconWithPeripheral:peripheral];
                [self centralManager:central storeFilterBeacons:peripheral RSSI:RSSI];
            }
            break;
        case 2:
            //Same as above
            if ([peripheral.identifier.UUIDString rangeOfString:filterStr].location != NSNotFound && [peripheral.identifier.UUIDString length] > 0) {
                [central connectPeripheral:peripheral options:nil];
                [self centralManager:central storeFilterBeacons:peripheral RSSI:RSSI];
            }
            break;
            
        default:
            break;
    }
    /*
     //Filter the Beacons we want
     if ([peripheral.name length] > 8) {
     if ([[peripheral.name substringToIndex:7] isEqualToString:_beaconFilterID]) {
     
     peripheral.delegate = self;
     NSLog(@"Name :%@", peripheral.name);
     SPBeacon *beacon = [[SPBeacon alloc] init];
     beacon.name = peripheral.name;
     beacon.rssi = [NSString stringWithFormat:@"%d", [RSSI intValue]];
     beacon.uuid = [NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString];
     
     [_delegate beaconManagerDidDiscoverBeacon:beacon];
     
     //            [central connectPeripheral:peripheral options:nil];
     }
     }*/
}

- (void)centralManager:(CBCentralManager *)central storeFilterBeacons:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Name :%@", peripheral.name);
    NSLog(@"RSSI :%d", [RSSI intValue]);
    SPBeacon *beacon = [[SPBeacon alloc] init];
    beacon.name = peripheral.name;
    beacon.rssi = [NSString stringWithFormat:@"%d", [RSSI intValue]];
    beacon.uuid = [NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString];
    
    
    [_delegate beaconManagerDidDiscoverBeacon:beacon];
    
    //            [central connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    NSLog(@"run");
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected");
    peripheral.delegate = self;
    //[peripheral readRSSI];
    //[self refreshRSSI];
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
