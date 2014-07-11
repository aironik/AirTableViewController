//
//  AITDDataSource.m
//  AirTableViewControllerDemo
//
//  Created by Oleg Lobachev aironik@gmail.com on 25.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITDDataSource.h"

#import "AITDChoiceOptionSelectorDelegate.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDDataSource ()
@end


#pragma mark - Implementation

@implementation AITDDataSource


- (id<AITChoiceOptionSelectorViewControllerDelegate>)choiceDelegate {
    if (_choiceDelegate == nil) {
        _choiceDelegate = [[AITDChoiceOptionSelectorDelegate alloc] init];
    }
    return _choiceDelegate;
}

@end
