//
//  AITDateValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDateValue.h"
#import "AITValueWithSource+AITProtected.h"

#import "AITDatePickerPopover.h"
#import "AITValueDelegate.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDateValue ()<UIPopoverControllerDelegate>

@property (nonatomic, weak) NSObject *sourceObject;
@property (nonatomic, copy) NSString *sourcePropertyName;

@property (nonatomic, copy) NSString *pickerCellIdentifier;

@property (nonatomic, assign) BOOL showDatePickerInPopover;
@property (nonatomic, strong) UIPopoverController *datePickerPopover;

@end


#pragma mark - Implementation

@implementation AITDateValue


- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
                sourceKeyPath:(NSString *)sourceKeyPath
{
    if (self = [super initWithTitle:title sourceObject:sourceObject sourceKeyPath:sourceKeyPath]) {
        _dateEditable = YES;

        _pickerCellIdentifier = @"AITDatePickerCell";

        _showDatePickerInPopover = [[self class] systemDatePickerInPopover];
    }
    return self;
}

+ (NSString *)cellIdentifier {
    return @"AITDateCell";
}

- (NSDate *)value {
    return self.sourceValue;
}

- (void)setValue:(NSDate *)value {
    self.sourceValue = value;
}

- (void)setupDatePicker:(UIDatePicker *)datePicker {
    [datePicker setDate:[self dateForPicker] animated:YES];
    if (self.minimumDate) {
        datePicker.minimumDate = self.minimumDate;
    }
    if (self.maximumDate) {
        datePicker.maximumDate = self.maximumDate;
    }
}

- (NSDate *)dateForPicker {
    NSDate *date = self.value;
    if (!date) {
        date = self.maximumDate;
    }
    if (!date) {
        date = self.minimumDate;
    }
    if (!date) {
        date = [NSDate date];
    }
    return date;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        // NSDateFormatter creates slowly. So we optimize if need.
        static NSDateFormatter *staticDateFormatter = nil;
        static dispatch_once_t dateFormatterPredicate;
        dispatch_once(&dateFormatterPredicate, ^{
            staticDateFormatter = [[NSDateFormatter alloc] init];
            [staticDateFormatter setTimeStyle:NSDateFormatterNoStyle];
            [staticDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        });
        _dateFormatter = staticDateFormatter;
    }
    return _dateFormatter;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ value == \"%@\">",
                     [super description],
                     self.value];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return self.dateEditable;
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}

- (void)becomeFirstAitResponder {
    if ([self isFirstAitResponder]) {
        [self resignFirstAitResponder];
    }
    else {
        [super becomeFirstAitResponder];
        if (self.dateEditable) {
            [self presentDatePicker];
        }
    }
}

- (void)resignFirstAitResponder {
    [super resignFirstAitResponder];
    if (self.dateEditable) {
        [self dismissDatePicker];
    }
}


#pragma mark -

+ (BOOL)systemDatePickerInPopover {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSInteger majorVersion = [systemVersion integerValue];
    return (majorVersion > 0 && majorVersion < 7);
}

- (void)presentDatePicker {
    if (self.showDatePickerInPopover) {
        [self presentDatePickerPopover];
    }
    else {
        [self.delegate value:self presentAdditionalaDataInCellWithIdentifier:self.pickerCellIdentifier];
    }
}

- (void)dismissDatePicker {
    if (self.showDatePickerInPopover) {
        [self dismissDatePickerPopover];
    }
    else {
        [self.delegate value:self dismissAdditionalaDataInCellWithIdentifier:self.pickerCellIdentifier];
    }
}

- (void)presentDatePickerPopover {
    AITDatePickerPopover *viewController = [AITDatePickerPopover datePickerWithValue:self];
    viewController.closeButton.target = self;
    viewController.closeButton.action = @selector(dismissDatePickerPopover);

    self.datePickerPopover = [self.delegate value:self showPopoverWithController:viewController];
    self.datePickerPopover.delegate = self;
}

- (void)dismissDatePickerPopover {
    [self.datePickerPopover dismissPopoverAnimated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if ([self isFirstAitResponder]) {
        [self resignFirstAitResponder];
    }
    self.datePickerPopover = nil;
}

@end
