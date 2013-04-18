//
//  IdentityNodeViewController.m
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-17.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import "IdentityNodeViewController.h"
#import "IdentityService.h"

@interface IdentityNodeViewController ()

@end

@implementation IdentityNodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.identities = @[@"Gareth", @"Ross", @"Trevor"];
    self.myIdentity = nil;
    self.identityService = [[IdentityService alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickIdentityButton:(id)sender {
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick your Language" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    self.pickerView = [[UIPickerView alloc] init];
    [self.pickerView setDataSource:self];
    [self.pickerView setDelegate:self];
    [self.pickerView setShowsSelectionIndicator:YES];
    
    [self.actionSheet addSubview:self.pickerView];
    
    // show the actionSheet
    [self.actionSheet showInView:self.view];
    
    // Size the actionSheet with smooth animation
    [UIView beginAnimations:nil context:nil];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 260)];
    [UIView commitAnimations];
}

- (void)startIdentityBroadcasting {
    self.broadcastingLabel.hidden = false;
    self.activityIndicator.hidden = false;

    [self.identityService startWithIdentity:self.myIdentity];
}

# pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"DidSelectRow %d", row);
    
    self.myIdentity = [self.identities objectAtIndex:row];
    NSString *buttonTitle = [NSString stringWithFormat:@"I am %@", self.myIdentity];
    
    [self.identityButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];

    [self startIdentityBroadcasting];
    return;
}

# pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.identities count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.identities objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}


@end
