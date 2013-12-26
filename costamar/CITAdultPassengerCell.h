//
//  CITAdultPassengerCell.h
//  costamar
//
//  Created by Mahavir Jain on 16/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITPassengerInfoSelectButton;
@class CITPassengerInfoTextField;

@interface CITAdultPassengerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *adultLabel;
@property (weak, nonatomic) IBOutlet CITPassengerInfoSelectButton *titleButton;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *nameLabel;

@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *lastNameP;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *lastNameM;
@property (weak, nonatomic) IBOutlet CITPassengerInfoSelectButton *countryButton;
@property (weak, nonatomic) IBOutlet CITPassengerInfoSelectButton *docTypeButton;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *docNumber;

@end
