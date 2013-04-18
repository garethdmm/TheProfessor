//
//  IdentityService.h
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-17.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *identityServiceUUID;
extern NSString *rossServiceUUID;
extern NSString *garethServiceUUID;
extern NSString *trevorServiceUUID;

@interface IdentityService : NSObject <CBPeripheralManagerDelegate>

@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) NSString *identity;

- (void)startWithIdentity:(NSString *)newIdentity;
- (void)stop;

@end
