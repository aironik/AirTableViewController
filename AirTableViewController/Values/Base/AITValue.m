//
//  AITValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 29.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


NSString *const kAITValueBecomeFirstAitResponder = @"kAITValueBecomeFirstAitResponder";
NSString *const kAITValueResignFirstAitResponder = @"kAITValueResignFirstAitResponder";


@interface AITValue ()
@end


#pragma mark - Implementation

@implementation AITValue

@synthesize firstAitResponder = _firstAitResponder;
@synthesize title = _title;

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _title = [title copy];
        _empty = NO;
    }
    return self;
}


+ (NSString *)cellIdentifier {
    NSAssert(NO, @"This nethod for override.");
    return nil;
}

- (void)perform {
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ title == \"%@\", empty == \"%@\">",
                     [super description],
                     self.title,
                     (self.empty ? @"YES" : @"NO")];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return NO;
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}

- (void)becomeFirstAitResponder {
    if ([self canBecomeFirstAitResponder]) {
        self.firstAitResponder = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(otherValueBecomeFirstAitResponderNotification:)
                                                 name:kAITValueBecomeFirstAitResponder
                                               object:nil];
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
