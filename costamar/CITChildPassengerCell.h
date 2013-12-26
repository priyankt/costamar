//
//  CITChildPassengerCell.h
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITPassengerInfoTextField;

@interface CITChildPassengerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *childLabel;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *nameLabel;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *lastNameP;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *lastNameM;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *dobLabel;

@end
