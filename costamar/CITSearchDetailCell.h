//
//  CITSearchDetailCell.h
//  costamar
//
//  Created by Mahavir Jain on 05/12/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CITSearchDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *salidaLabel;
@property (weak, nonatomic) IBOutlet UILabel *llegadaLabel;
@property (weak, nonatomic) IBOutlet UILabel *aerolineaLabel;
@property (weak, nonatomic) IBOutlet UILabel *operadoLabel;
@property (weak, nonatomic) IBOutlet UILabel *tarifaLabel;
@property (weak, nonatomic) IBOutlet UILabel *hora1Label;
@property (weak, nonatomic) IBOutlet UILabel *hora2Label;
@property (weak, nonatomic) IBOutlet UILabel *vueloLabel;

@end
