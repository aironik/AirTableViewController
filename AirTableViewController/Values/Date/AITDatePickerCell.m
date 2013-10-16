//
//  AITDatePickerCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDatePickerCell.h"

#import "AITDateValue.h"
#import "AITTableViewCell+AITProtected.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDatePickerCell ()
@end


#pragma mark - Implementation

@implementation AITDatePickerCell

- (CGFloat)prefferedHeight {
    return 216.;
}

- (AITDateValue *)dateValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITDateValue class]]);
    return (AITDateValue *)self.value;
}


- (void)setDateValue:(AITDateValue *)textValue {
    NSParameterAssert(!textValue || [textValue isKindOfClass:[AITDateValue class]]);
    self.value = textValue;
}

- (NSArray *)keyPathsForSubscribe {
    return [@[ @"value" ] arrayByAddingObjectsFromArray:[super keyPathsForSubscribe]];
}

- (void)updateSubviews {
    [super updateSubviews];

    NSDate *date = self.dateValue.value;
    if (!date) {
        date = self.dateValue.maximumDate;
    }
    if (!date) {
        date = self.dateValue.minimumDate;
    }
    if (!date) {
        date = [NSDate date];
    }
    
    [self.datePicker setDate:date animated:YES];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return NO;
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}

- (void)becomeFirstAitResponder {
}

- (void)resignFirstAitResponder {
}

@end
