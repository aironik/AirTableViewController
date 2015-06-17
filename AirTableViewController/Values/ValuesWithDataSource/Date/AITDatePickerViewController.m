//
//  AITDatePickerViewController.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDatePickerViewController.h"

#import "AITDateValue.h"
#import "NSBundle+AITLoader.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDatePickerViewController ()
@end


#pragma mark - Implementation

@implementation AITDatePickerViewController


+ (instancetype)datePickerWithValue:(AITDateValue *)value {
    AITDatePickerViewController *result = nil;

    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:[NSBundle ait_bundle]];
    NSArray *content = [nib instantiateWithOwner:self options:nil];
    for (NSObject *object in content) {
        if ([object isKindOfClass:[self class]]) {
            result = (AITDatePickerViewController *)object;
            break;
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
    self.titleLabel.text = _dateValue.title;

    [self.pickerView setDate:dateValue.defaultDateValue animated:YES];
    self.pickerView.minimumDate = dateValue.minimumDate;
    self.pickerView.maximumDate = dateValue.maximumDate;
}

- (IBAction)dateValueDidChanged:(UIDatePicker *)sender {
    self.dateValue.value = sender.date;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.dateValue resignFirstAitResponder];
}

@end
