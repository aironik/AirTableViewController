//
//  AITSettingsSubtitledActionValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsSubtitledActionValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsSubtitledActionValue ()
@end


#pragma mark - Implementation


@implementation AITSettingsSubtitledActionValue


@synthesize subtitle = _subtitle;


+ (instancetype)valueWithTitle:(NSString *)title subtitle:(NSString *)subtitle action:(AITActionValueBlock)action {
    return [[self alloc] initWithTitle:title subtitle:subtitle action:action];
}

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle action:(AITActionValueBlock)action {
    if (self = [super initWithTitle:title action:action]) {
        _subtitle = [subtitle copy];
    }
    return self;
}

@end
