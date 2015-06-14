//
//  AITSettingsPendingOperationCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsPendingOperationCell.h"

#import "AITCellEtchedView.h"
#import "AITTableViewCellOverride.h"
#import "UIView+AITUserInterfaceIdiom.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsPendingOperationCell ()
@end


#pragma mark - Implementation


@implementation AITSettingsPendingOperationCell


AIT_CELL_OVERRIDE_STATIC


+ (CGFloat)preferredHeightForValue:(AITValue *)value {
    return 88.;
}


@end
