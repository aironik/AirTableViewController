//
//  AITSettingsBoolWithStateViewCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsBoolWithStateViewCell.h"

#import "AITSettingsBoolWithStateViewValue.h"
#import "AITTableViewCell+AITProtected.h"


@implementation AITSettingsBoolWithStateViewCell


- (AITSettingsBoolWithStateViewValue *)boolWithStateValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITBoolValue class]]);
    return (AITSettingsBoolWithStateViewValue *)self.value;
}

- (void)setBoolWithStateValue:(AITSettingsBoolWithStateViewValue *)boolWithStateValue {
    NSParameterAssert(boolWithStateValue != nil
                      && [boolWithStateValue isKindOfClass:[AITSettingsBoolWithStateViewValue class]]);
    self.value = boolWithStateValue;
}

- (NSArray *)keyPathsForSubscribe {
    return [@[ @"bottomTitle", @"color" ] arrayByAddingObjectsFromArray:[super keyPathsForSubscribe]];
}

- (void)updateSubviews {
    [super updateSubviews];
    
    self.stateView.clipsToBounds = YES;
    self.stateView.layer.cornerRadius = CGRectGetHeight(self.stateView.frame) / 2.f;
    
    AITSettingsBoolWithStateViewValue *boolWithStateValue = self.boolWithStateValue;
    
    self.bottomLabel.text = boolWithStateValue.bottomTitle;
    self.stateView.backgroundColor = boolWithStateValue.color;
}


@end
