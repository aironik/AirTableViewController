//
//  AITActionValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 20.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITActionValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITActionValue ()
@end


#pragma mark - Implementation

@implementation AITActionValue

- (instancetype)initWithTitle:(NSString *)title action:(AITActionValueBlock)action {
    if (self = [super initWithTitle:title]) {
        _action = [action copy];
        _enabled = YES;
    }
    return self;
}

+ (instancetype)valueWithTitle:(NSString *)title action:(AITActionValueBlock)action {
    // TODO: why warning witout cast?
    return [(AITActionValue *)[self alloc] initWithTitle:title action:action];
}

- (void)perform {
    if ([self canPerform]) {
        self.action(self);
    }
}

- (BOOL)canPerform {
    return (self.enabled && self.action);
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return [self canPerform];
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}

- (void)becomeFirstAitResponder {
    [super becomeFirstAitResponder];
    [super resignFirstAitResponder];
}

- (void)setFirstAitResponder:(BOOL)firstAitResponder {
    if (firstAitResponder) {
        [self perform];
    }
    [super setFirstAitResponder:firstAitResponder];
}

@end
