//
//  CITMultiDestCell.h
//  costamar
//
//  Created by Mahavir Jain on 18/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CITMultiDestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *destLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@end
