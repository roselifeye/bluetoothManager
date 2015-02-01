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
    [self discoverBeacons];
    
    return self;
}

- (void)discoverBeacons {
    if (beaconManager.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"State not powered on");
        return;
    }
    [self scanBegin];
}

- (void)scanBegin {
    [beaconManager scanForPeripheralsWithServices:nil options:nil];
}

//To refresh the value of RSSI every 2 seconds
- (void)refreshRSSI {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                      target:self
                                                    selector:@selector(readRSSI)
                                                    userInfo:nil
                                                     repeats:1.0];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)connectBeaconWithPeripheral:(CBPeripheral *) peripheral{
    [beaconManager connectPeripheral:peripheral
                             options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                                 forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
}


#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    [self scanBegin];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    //Filter the Beacons we want
    if ([peripheral.name length] > 8) {
        if ([[peripheral.name substringToIndex:7] isEqualToString:@"D05FB8"]) {
            
            peripheral.delegate = self;
            NSLog(@"Name :%@", peripheral.name);
            SPBeacon *beacon = [[SPBeacon alloc] init];
            beacon.name = peripheral.name;
            beacon.rssi = [NSString stringWithFormat:@"%d", [RSSI intValue]];
            beacon.uuid = [NSString stringWithFormat:@"%@", peripheral.identifier.UUIDString];
            
            [_delegate beaconManagerDidDiscoverBeacon:beacon];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    NSLog(@"run");
}

@end
