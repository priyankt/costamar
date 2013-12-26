//
//  CITAddNewDestViewController.h
//  costamar
//
//  Created by Mahavir Jain on 18/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CITMultiDestData;

@interface CITAddNewDestViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) CITMultiDestData *multiDestData;

@end
