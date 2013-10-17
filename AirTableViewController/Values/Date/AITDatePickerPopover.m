//
//  AITDatePickerPopover.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDatePickerPopover.h"

#import "AITDateValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDatePickerPopover ()
@end


#pragma mark - Implementation

@implementation AITDatePickerPopover


+ (instancetype)datePickerWithValue:(AITDateValue *)value {
    AITDatePickerPopover *result = nil;

    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:[NSBundle bundleForClass:[self class]]];
    NSArray *content = [nib instantiateWithOwner:self options:nil];
    for (NSObject *object in content) {
        if ([object isKindOfClass:[self class]]) {
            result = (AITDatePickerPopover *)object;
        }
    }

    result.dateValue = value;
    return result;
}

- (instancetype)initWithValue:(AITDateValue *)value {
    if (self = [super init]) {
    }
    return self;
}

- (void)setDateValue:(AITDateValue *)dateValue {
    _dateValue = dateValue;
    self.navigationBar.topItem.title = _dateValue.title;
    self.pickerView.date = [_dateValue dateForPicker];
}


@end
