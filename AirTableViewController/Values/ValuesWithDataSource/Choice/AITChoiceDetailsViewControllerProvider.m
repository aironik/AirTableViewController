//
//  AITChoiceDetailsViewControllerProvider.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 05.11.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITChoiceDetailsViewControllerProvider.h"

#import "AITChoiceOptionSelectorViewController.h"
#import "AITChoiceValue.h"
#import "AITValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITChoiceDetailsViewControllerProvider ()
@end


#pragma mark - Implementation

@implementation AITChoiceDetailsViewControllerProvider

- (AITDetailsPresentationStyle)presentationStyle {
    return AITDetailsPresentationStylePushNavigation;
}

- (UIViewController *)detailsViewControllerForValue:(AITValue *)value {
    NSParameterAssert([value isKindOfClass:[AITChoiceValue class]]);
    return [AITChoiceOptionSelectorViewController choiceOptionSelectorWithValue:(AITChoiceValue *)value];
}

@end
