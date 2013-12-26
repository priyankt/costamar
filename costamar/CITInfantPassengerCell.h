//
//  CITInfantPassengerCell.h
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITPassengerInfoTextField;
@class CITPassengerInfoSelectButton;

@interface CITInfantPassengerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infantLabel;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *nameLabel;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *lastNameP;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *lastNameM;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *dobLabel;
@property (weak, nonatomic) IBOutlet CITPassengerInfoSelectButton *adultInchargeButton;

@end
