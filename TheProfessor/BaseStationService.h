//
//  BaseStationService.h
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-18.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BaseStationViewController;

@protocol BaseStationServiceDelegate <NSObject>

- (void)didFindPerson:(NSString *)person;

@end

@interface BaseStationService : NSObject <CBCentralManagerDelegate>

@property (strong, nonatomic) BaseStationViewController *delegate;
@property (strong, nonatomic) CBCentralManager *centralManager;

@end
