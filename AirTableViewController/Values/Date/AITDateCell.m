//
//  AITDateCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 15.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDateCell.h"

#import "AITDateValue.h"
#import "AITTableViewCell+AITProtected.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDateCell ()
@end


#pragma mark - Implementation

@implementation AITDateCell

- (AITDateValue *)dateValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITDateValue class]]);
    return (AITDateValue *)self.value;
}


- (void)setDateValue:(AITDateValue *)dateValue {
    NSParameterAssert(!dateValue || [dateValue isKindOfClass:[AITDateValue class]]);
    self.value = dateValue;
}

- (NSArray *)keyPathsForSubscribe {
    return [@[ @"value", @"dateEditable" ] arrayByAddingObjectsFromArray:[super keyPathsForSubscribe]];
}

- (void)updateSubviews {
    [super updateSubviews];

    NSDate *date = self.dateValue.value;
    self.valueLabel.text = (date ? [self.dateValue.dateFormatter stringFromDate:date] : nil);
}


#pragma mark - AITResponder protocol implementation

- (void)becomeFirstAitResponder {
    [self setSelected:YES animated:NO];
    [self setSelected:NO animated:YES];
    [super becomeFirstAitResponder];
}

- (void)resignFirstAitResponder {
    [self setSelected:NO animated:YES];
    [super resignFirstAitResponder];
}

@end
