//
//  AITPendingOperationCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITPendingOperationCell.h"

#import "AITTableViewCell+AITProtected.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITPendingOperationCell ()
@end


#pragma mark - Implementation

@implementation AITPendingOperationCell

- (void)setup {
    [super setup];

    [self.activityIndicator startAnimating];
}

- (UITableViewCellSelectionStyle)defaultSelectionStyle {
    return UITableViewCellSelectionStyleNone;
}

- (void)updateSubviews {
    [super updateSubviews];

    [self.activityIndicator startAnimating];
}


@end
