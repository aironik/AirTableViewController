//
//  AITBoolCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITBoolCell.h"

#import "AITTableViewCell.h"
#import "AITTableViewCell+AITProtected.h"
#import "AITBoolValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITBoolCell ()
@end


#pragma mark - Implementation

@implementation AITBoolCell

- (AITBoolValue *)switchValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITBoolValue class]]);
    return (AITBoolValue *)self.value;
    
}

- (void)setSwitchValue:(AITBoolValue *)switchValue {
    NSParameterAssert(!switchValue || [switchValue isKindOfClass:[AITBoolValue class]]);
    self.value = switchValue;
}

- (void)setup {
    [super setup];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.switchControl addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)changeValue:(UISwitch *)switchControl {
    NSParameterAssert(switchControl == self.switchControl);
    self.switchValue.value = self.switchControl.on;
}

- (NSArray *)keyPathsForSubscribe {
    return [@[ @"enabled", @"value" ] arrayByAddingObjectsFromArray:[super keyPathsForSubscribe]];
}

- (void)updateSubviews {
    [super updateSubviews];
    
    [self.switchControl setOn:self.switchValue.value animated:YES];
}

@end
