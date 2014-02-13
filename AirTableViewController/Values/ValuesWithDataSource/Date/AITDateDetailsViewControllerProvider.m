//
//  AITDateDetailsViewControllerProvider.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 01.11.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDateDetailsViewControllerProvider.h"
#import "AITValue.h"
#import "AITDatePickerViewController.h"
#import "AITDateValue.h"
#import "AITTableViewController.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDateDetailsViewControllerProvider ()
@end


#pragma mark - Implementation

@implementation AITDateDetailsViewControllerProvider

- (instancetype)init {
    if (self = [super init]) {
        _showDatePickerInPopover = [[self class] systemDatePickerInPopover];
    }
    return self;
}

+ (BOOL)systemDatePickerInPopover {
    return ([AITTableViewController userInterfaceIdiomVersion] == AITUserInterfaceIdiomVersion6);
}

- (AITDetailsPresentationStyle)presentationStyle {
    if (self.showDatePickerInPopover) {
        return AITDetailsPresentationStylePopover;
    }
    return AITDetailsPresentationStyleCell;
}

- (UIViewController *)detailsViewControllerForValue:(AITValue *)value {
    NSParameterAssert([value isKindOfClass:[AITDateValue class]]);
    return [AITDatePickerViewController datePickerWithValue:(AITDateValue *)value];
}

@end
