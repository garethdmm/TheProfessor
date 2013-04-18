//
//  BaseStationService.m
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-18.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import "BaseStationService.h"
#import "BaseStationViewController.h"
#import "BLEUtility.h"


extern NSString *rossServiceUUID;// = @"4963a932-8fed-48bc-806f-ee38408a5f69";
extern NSString *garethServiceUUID;// = @"0ccbd3be-72c1-4b7a-86b7-6e705c615674";
extern NSString *trevorServiceUUID;// = @"7dfbf576-9bee-4f81-a85c-db4504ad8f69";

@implementation BaseStationService

- (id)init {
    self = [super init];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    return self;
}

- (void)startScanning {
    NSLog(@"BaseStationService --- startScanning");
    NSLog(@"Searching for UUIDs: %@", trevorServiceUUID);
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    [self.centralManager scanForPeripheralsWithServices:@[
        [CBUUID UUIDWithString:trevorServiceUUID],
        [CBUUID UUIDWithString:garethServiceUUID],
        [CBUUID UUIDWithString:rossServiceUUID]
     ] options:options];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"BaseStationService --- didDiscoverPeripheral");
    NSLog(@"AdvertisingData: %@", advertisementData);
    
    // identify the peripheral

    NSArray * services = advertisementData[CBAdvertisementDataServiceUUIDsKey];
    for (CBUUID *serviceUUID in services) {
        if ([[BLEUtility CBUUIDToString:serviceUUID] isEqualToString:trevorServiceUUID]) {
            NSLog(@"Trevor is here!");
            [self.delegate didFindPerson:@"Trevor"];
        } else if ([[BLEUtility CBUUIDToString:serviceUUID] isEqualToString:rossServiceUUID]) {
            NSLog(@"Ross is here!");
            [self.delegate didFindPerson:@"Ross"];
        } else if ([[BLEUtility CBUUIDToString:serviceUUID] isEqualToString:garethServiceUUID]) {
            NSLog(@"Gareth is here!");
            [self.delegate didFindPerson:@"Gareth"];
        }
    }
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"BaseStationService --- centralDidUpdateState");
    static CBCentralManagerState previousState = -1;
    
	switch ([self.centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
			/* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
            if (previousState != -1) {
                
            }
			break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
			break;
		}
            
		case CBCentralManagerStateUnknown:
		{
			break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
            NSLog(@"BaseStationService --- statePoweredOn");
            [self startScanning];
            break;
		}
            
		case CBCentralManagerStateResetting:
		{
            break;
		}
	}
    
    previousState = [self.centralManager state];
}

@end
