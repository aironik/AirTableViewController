//
//  AITDateValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDateValue.h"

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
@property (nonatomic, strong) AITDatePickerPopover *datePickerPopover;

@end


#pragma mark - Implementation

@implementation AITDateValue


+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName
{
    return [[self alloc] initWithTitle:title sourceObject:sourceObject sourcePropertyName:sourcePropertyName];
}

- (instancetype)initWithTitle:(NSString *)title
                 sourceObject:(NSObject *)sourceObject
           sourcePropertyName:(NSString *)sourcePropertyName
{
    if (self = [super init]) {
        _title = [title copy];
        _sourceObject = sourceObject;
        _sourcePropertyName = [sourcePropertyName copy];
        _empty = NO;

        _dateEditable = YES;

        [_sourceObject addObserver:self
                        forKeyPath:sourcePropertyName
                           options:NSKeyValueObservingOptionNew
                           context:NULL];

        _pickerCellIdentifier = @"AITDatePickerCell";

        _showDatePickerInPopover = [[self class] systemDatePickerInPopover];
    }
    return self;
}

- (void)dealloc {
    [_sourceObject removeObserver:self forKeyPath:_sourcePropertyName];
}

+ (NSString *)cellIdentifier {
    return @"AITDateCell";
}

- (void)perform {
}

- (NSDate *)value {
    return [self.sourceObject valueForKeyPath:self.sourcePropertyName];
}

- (void)setValue:(NSDate *)value {
    [self.sourceObject setValue:value forKeyPath:self.sourcePropertyName];
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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.sourceObject && [keyPath isEqualToString:self.sourcePropertyName]) {
        [self willChangeValueForKey:@"value"];
        [self didChangeValueForKey:@"value"];
    }
    else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ title == \"%@\", value == \"%@\">",
                     [super description],
                     self.title,
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
    UIViewController *viewController = [AITDatePickerPopover datePickerWithValue:self];
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
