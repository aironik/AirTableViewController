//
//  AITSettingsChoiceCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsChoiceCell.h"

#import "AITCellEtchedView.h"
#import "AITTableViewCellOverride.h"
#import "AITSettingsChoiceValue.h"
#import "UIView+AITUserInterfaceIdiom.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsChoiceCell ()
@end


#pragma mark - Implementation


@implementation AITSettingsChoiceCell


AIT_CELL_OVERRIDE_DETAILED


- (void)updateSubviews {
    [super updateSubviews];
    
    AITSettingsChoiceValue *value = (AITSettingsChoiceValue *)self.value;
    self.arrowImageView.hidden = !value.enabled;
}


@end
