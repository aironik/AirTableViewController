//
//  AITDChoiceOptionSelectorDelegate.m
//  AirTableViewControllerDemo
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.07.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "AITDChoiceOptionSelectorDelegate.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDChoiceOptionSelectorDelegate ()
@end


#pragma mark - Implementation


@implementation AITDChoiceOptionSelectorDelegate

- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
            didStartForValue:(AITChoiceValue *)value
{
    optionsSelector.allOptions = @[
            @(111),
            @(112),
            @(122),
            @(222),
            @(151),
            @(152),
    ];
}

- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
             didStopForValue:(AITChoiceValue *)value
{
}

- (BOOL)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
         allowFilterForValue:(AITChoiceValue *)value
{
    return YES;
}

- (void)choiceOptionSelector:(AITChoiceOptionSelectorViewController *)optionsSelector
            filterDidChanged:(NSString *)filter
                    forValue:(AITChoiceValue *)value
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *str = [evaluatedObject description];
        return ([str rangeOfString:filter].location != NSNotFound);
    }];
    optionsSelector.filteredOptions = [optionsSelector.allOptions filteredArrayUsingPredicate:predicate];
}


@end
