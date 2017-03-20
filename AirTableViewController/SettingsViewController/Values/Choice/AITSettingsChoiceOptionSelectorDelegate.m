//
//  AITSettingsChoiceOptionSelectorDelegate.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 19.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsChoiceOptionSelectorDelegate.h"

#import "AITChoiceOptionSelectorViewController.h"
#import "AITSettingsChoiceValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsChoiceOptionSelectorDelegate ()
@end


#pragma mark - Implementation


@implementation AITSettingsChoiceOptionSelectorDelegate


- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
            didStartForValue:(AITChoiceValue *)value
{
    NSParameterAssert([value isKindOfClass:[AITSettingsChoiceValue class]]);
    optionsSelector.allOptions = [(AITSettingsChoiceValue *)value allOptions];
}

- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
             didStopForValue:(AITChoiceValue *)value
{
}

- (BOOL)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
         allowFilterForValue:(AITChoiceValue *)value
{
    return NO;
}

- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
            filterDidChanged:(NSString *)filter
                    forValue:(AITChoiceValue *)value
{
}


@end
