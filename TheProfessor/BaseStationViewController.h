//
//  BaseStationViewController.h
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-17.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseStationService.h"

@interface BaseStationViewController : UITableViewController <BaseStationServiceDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMutableArray *events;

@property (strong, nonatomic) BaseStationService *baseService;

@end
