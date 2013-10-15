//
//  AITResponderValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITResponderValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


NSString *const kAITValueBecomeFirstAitResponder = @"kAITValueBecomeFirstAitResponder";
NSString *const kAITValueResignFirstAitResponder = @"kAITValueResignFirstAitResponder";


@interface AITResponderValue ()
@end


#pragma mark - Implementation

@implementation AITResponderValue

@synthesize firstAitResponder = _firstAitResponder;


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return NO;
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}

- (void)becomeFirstAitResponder {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(otherValueBecomeFirstAitResponderNotification:)
                                                 name:kAITValueBecomeFirstAitResponder
                                               object:nil];
    if ([self canBecomeFirstAitResponder]) {
        self.firstAitResponder = YES;
    }
}

- (void)resignFirstAitResponder {
    if ([self canResignFirstAitResponder]) {
        self.firstAitResponder = NO;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kAITValueBecomeFirstAitResponder
                                                  object:nil];
}

- (void)setFirstAitResponder:(BOOL)firstAitResponder {
    if (_firstAitResponder != firstAitResponder) {
        _firstAitResponder = firstAitResponder;

        NSString *name = (_firstAitResponder ? kAITValueBecomeFirstAitResponder : kAITValueResignFirstAitResponder);
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self];
    }
}

- (void)otherValueBecomeFirstAitResponderNotification:(NSNotification *)notification {
    if ([notification object] != self && [self isFirstAitResponder]) {
        [self resignFirstAitResponder];
    }
}

@end
