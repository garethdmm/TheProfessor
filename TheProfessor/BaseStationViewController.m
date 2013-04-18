//
//  BaseStationViewController.m
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-17.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import "BaseStationViewController.h"
#import "ScanningCell.h"

@interface BaseStationViewController ()

@end

@implementation BaseStationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.baseService = [[BaseStationService alloc] init];
    [self.baseService setDelegate:self];

    self.events = [[NSMutableArray alloc] init];
    
    UINib *cellNib = [UINib nibWithNibName:@"ScanningCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ScanningCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BaseStationServiceDelegate

- (void)didFindPerson:(NSString *)person {
    NSLog(@"BaseStationVC --- didFindPerson");
    NSString *eventString = [NSString stringWithFormat:@"%@ arrived!", person];
    [self.events addObject:eventString];
    // do anything else, like texting the others to let them know
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.events count]) {
        // the last row of the table is always a spinner;
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ScanningCell"];
       
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventCell"];
        
        cell.textLabel.text = (NSString *)self.events[indexPath.row];
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
