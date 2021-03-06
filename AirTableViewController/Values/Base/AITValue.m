//
//  AITValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 29.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITValue.h"

#import "AITValueDelegate.h"


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
@synthesize cellIdentifier = _cellIdentifier;


- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _title = [title copy];
        _empty = NO;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willAppear {

}

- (void)didDisappear {

}

- (NSString *)cellIdentifier {
    static NSString *const valueSuffix = @"Value";
    static NSString *const cellSuffix = @"Cell";
    if (_cellIdentifier == nil) {
        NSString *name = NSStringFromClass([self class]);
        if ([name hasSuffix:valueSuffix]) {
            name = [name substringToIndex:[name length] - [valueSuffix length]];
        }
        _cellIdentifier = [name stringByAppendingString:cellSuffix];
    }
    return _cellIdentifier;
}

- (void)setEmpty:(BOOL)empty {
    if (_empty != empty) {
        _empty = empty;
        [self.delegate valueEmptyChanged:self];
    }
}

- (id<AITDetailsViewControllerProvider>)detailsViewControllerProvider {
    return nil;
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

        if (_firstAitResponder) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAITValueBecomeFirstAitResponder  object:self];
            [self.delegate valueDidBecomeFirstAitResponder:self];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAITValueResignFirstAitResponder object:self];
            [self.delegate valueDidResignFirstAitResponder:self];
        }
    }
}

- (void)otherValueBecomeFirstAitResponderNotification:(NSNotification *)notification {
    if ([notification object] != self && [self isFirstAitResponder]) {
        [self resignFirstAitResponder];
    }
}

@end
