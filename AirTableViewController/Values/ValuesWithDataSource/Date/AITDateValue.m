//
//  AITDateValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDateValue.h"
#import "AITValueWithSource+AITProtected.h"

#import "AITDateDetailsViewControllerProvider.h"
#import "AITDatePickerViewController.h"
#import "AITValueDelegate.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDateValue ()

@property (nonatomic, copy) NSString *sourcePropertyName;

@property (nonatomic, copy) NSString *pickerCellIdentifier;

@property (nonatomic, strong, readonly) AITDateDetailsViewControllerProvider *detailsViewControllerProvider;

@end


#pragma mark - Implementation

@implementation AITDateValue


@synthesize detailsViewControllerProvider = _detailsViewControllerProvider;
@synthesize defaultDateValue = _defaultDateValue;


- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
                sourceKeyPath:(NSString *)sourceKeyPath
{
    if (self = [super initWithTitle:title sourceObject:sourceObject sourceKeyPath:sourceKeyPath]) {
        _dateEditable = YES;

        _pickerCellIdentifier = @"AITDatePickerCell";
    }
    return self;
}

- (id<AITDetailsViewControllerProvider>)detailsViewControllerProvider {
    if (!_detailsViewControllerProvider) {
        _detailsViewControllerProvider = [[AITDateDetailsViewControllerProvider alloc] init];
    }
    return _detailsViewControllerProvider;
}

- (NSDate *)value {
    return self.sourceValue;
}

- (void)setValue:(NSDate *)value {
    self.sourceValue = value;
}

- (NSDate *)defaultDateValue {
    NSDate *date = self.value;
    if (!date) {
        date = _defaultDateValue;
    }
    if (!date) {
        date = [NSDate date];
    }

    if (self.maximumDate && [date compare:self.maximumDate] == NSOrderedDescending) {
        date = self.maximumDate;
    }
    if (self.minimumDate && [self.minimumDate compare:date] == NSOrderedDescending) {
        date = self.minimumDate;
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
    }
}


@end
