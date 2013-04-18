//
//  IdentityService.m
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-17.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import "IdentityService.h"

NSString *identityServiceUUID = @"aea61d16-caeb-4c10-a232-eda391ee8f5c";

NSString *rossServiceUUID = @"4963a932-8fed-48bc-806f-ee38408a5f69";
NSString *garethServiceUUID = @"0ccbd3be-72c1-4b7a-86b7-6e705c615674";
NSString *trevorServiceUUID = @"7dfbf576-9bee-4f81-a85c-db4504ad8f69";

@implementation IdentityService

- (id)init {
    self = [super init];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    return self;
}

- (void)startWithIdentity:(NSString *)newIdentity {
    NSLog(@"IdentityService --- Start");
    self.identity = newIdentity;
    [self startAdvertising];
}

- (void)stop {
    [self stopAdvertising];
}

- (void)startAdvertising {
    NSLog(@"IdentityService --- StartAdvertising");

    NSString *identityUUID;

    if ([self.identity isEqualToString:@"Ross"]) {
        NSLog(@"IdentityService --- Advertising as Ross");
        identityUUID = rossServiceUUID;
    } else if ([self.identity isEqualToString:@"Gareth"]) {
        NSLog(@"IdentityService --- Advertising as Gareth");
        identityUUID = garethServiceUUID;
    } else if ([self.identity isEqualToString:@"Trevor"]) {
        NSLog(@"IdentityService --- Advertising as Trevor");
        identityUUID = trevorServiceUUID;
    }

    NSLog(@"I am %@", self.identity);
    NSLog(@"Service UUID: %@", identityUUID);
    
    [self.peripheralManager startAdvertising:@{
                CBAdvertisementDataLocalNameKey: self.identity,
                CBAdvertisementDataServiceUUIDsKey :
                    @[//[CBUUID UUIDWithString:identityServiceUUID],
                      [CBUUID UUIDWithString:identityUUID]
                    ]
     }];
}

- (void)stopAdvertising {
    NSLog(@"IdentityService --- StopAdvertising");
    [self.peripheralManager stopAdvertising];
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"IdentityService --- peripheralManagerDidUpdateState");
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        // when we're powered on, set up the service
        return;
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"IdentityService --- didStartAdvertising");
}

@end
