//
//  IdentityNodeViewController.h
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-17.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdentityService.h"

@interface IdentityNodeViewController : UIViewController <
    UIPickerViewDataSource,
    UIPickerViewDelegate,
    UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIButton *identityButton;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *broadcastingLabel;

- (IBAction)didClickIdentityButton:(id)sender;

@property (strong, nonatomic) NSArray *identities;
@property (strong, nonatomic) NSString *myIdentity;

@property (strong, nonatomic) IdentityService *identityService;

@end
