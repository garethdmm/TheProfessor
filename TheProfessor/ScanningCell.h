//
//  ScanningCell.h
//  TheProfessor
//
//  Created by Gareth MacLeod on 2013-04-17.
//  Copyright (c) 2013 Gareth MacLeod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanningCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *scanningLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
