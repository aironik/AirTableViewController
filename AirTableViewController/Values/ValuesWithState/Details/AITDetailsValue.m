//
//  AITDetailsValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.07.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "AITDetailsValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDetailsValue ()

@property (nonatomic, strong, readonly) id<AITDetailsViewControllerProvider> detailsViewControllerProvider;

@end


#pragma mark - Implementation

@implementation AITDetailsValue


- (instancetype)initWithTitle:(NSString *)title detailsProvider:(id<AITDetailsViewControllerProvider>)detailsProvider {
    if (self = [super initWithTitle:title]) {
        NSParameterAssert(detailsProvider != nil);
        _detailsViewControllerProvider = detailsProvider;
    }
    return self;
}

+ (instancetype)valueWithTitle:(NSString *)title detailsProvider:(id<AITDetailsViewControllerProvider>)detailsProvider {
    return [[self alloc] initWithTitle:title detailsProvider:detailsProvider];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return YES;
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}

- (void)becomeFirstAitResponder {
    [super becomeFirstAitResponder];
    [super resignFirstAitResponder];
}

- (void)setFirstAitResponder:(BOOL)firstAitResponder {
    [super setFirstAitResponder:firstAitResponder];
}


@end
