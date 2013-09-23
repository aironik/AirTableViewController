//
//  AITActionCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 20.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITActionCell.h"
#import "AITTableViewCell+AITProtected.h"

#import "AITActionValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITActionCell ()
@end


#pragma mark - Implementation

@implementation AITActionCell

- (AITActionValue *)actionValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITActionValue class]]);
    return (AITActionValue *)self.value;
}

- (void)setActionValue:(AITActionValue *)actionValue {
    NSParameterAssert(!actionValue || [actionValue isKindOfClass:[AITActionValue class]]);
    self.value = actionValue;
}

- (NSArray *)keyPathsForSubscribe {
    return [@[ @"enabled" ] arrayByAddingObjectsFromArray:[super keyPathsForSubscribe]];
}

- (void)updateSubviews {
    [super updateSubviews];
    
    if ([self.actionValue canPerform]) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.titleLabel.textColor = [UIColor blackColor];
    }
    else {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel.textColor = [UIColor grayColor];
    }
}

@end
