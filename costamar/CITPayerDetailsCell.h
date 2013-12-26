//
//  CITPayerDetailsCell.h
//  costamar
//
//  Created by Mahavir Jain on 19/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITPassengerInfoTextField;
@class CITPassengerInfoSelectButton;

@interface CITPayerDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *emailLabel;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *confirmEmailLabel;
@property (weak, nonatomic) IBOutlet CITPassengerInfoSelectButton *citySelectButton;
@property (weak, nonatomic) IBOutlet CITPassengerInfoTextField *phoneLabel;

@end
