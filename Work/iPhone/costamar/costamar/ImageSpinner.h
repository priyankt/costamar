//
//  ImageSpinner.h
//  costamar
//
//  Created by Mahavir Jain on 16/11/13.
//  Copyright (c) 2013 Mobisys Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSpinner : UIImageView {
    BOOL _animate;
    double _rotationAngle;
}
- (void)startAnimating;
- (void)stopAnimating;
@end
