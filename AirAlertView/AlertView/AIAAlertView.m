//
//  AIAAlertView.m
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.01.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "AIAAlertView.h"

#import <UIKit/UIKit.h>

#import "AIAButtonDescriptor.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AIAAlertView ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *nativeAlertView;
@property (nonatomic, strong) AIAButtonDescriptor *cancelButtonDescriptor;
@property (nonatomic, strong) NSMutableArray *buttonDescriptors;
@property (nonatomic, strong) AIAAlertView *selfHolder;

@end


#pragma mark - Implementation

@implementation AIAAlertView


+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithTitle:title message:message];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    if (self = [super init]) {
        NSAssert([title length] + [message length], @"Title and message are empty. This case is obscure.");
        _title = [title copy];
        _message = [message copy];
        _buttonDescriptors = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [self hide];
}

- (BOOL)isShown {
    return self.nativeAlertView.visible;
}

- (void)setNativeAlertView:(UIAlertView *)nativeAlertView {
    if (_nativeAlertView != nativeAlertView) {
        _nativeAlertView = nativeAlertView;
        // While nativeAlertView presented we should retain self.
        // Otherwise alert view cannot handle result blocks.
        self.selfHolder = nativeAlertView ? self : nil;
    }
}


- (void)addCancelButtonWithTitle:(NSString *)title actionBlock:(AIAAlertViewActionBlock)actionBlock {
    if (self.cancelButtonDescriptor) {
        [self addButtonDescriptor:self.cancelButtonDescriptor];
    }
    self.cancelButtonDescriptor = [AIAButtonDescriptor buttonDescriptorWithTitle:title actionBlock:actionBlock];
}

- (void)addButtonWithTitle:(NSString *)title actionBlock:(AIAAlertViewActionBlock)actionBlock {
    [self addButtonDescriptor:[AIAButtonDescriptor buttonDescriptorWithTitle:title actionBlock:actionBlock]];
}

- (void)addButtonDescriptor:(AIAButtonDescriptor *)descriptor {
    NSAssert(!self.shown, @"Buttons should not chenges while view shown.");
    [self.buttonDescriptors addObject:descriptor];
}

- (void)show {
    if (!self.shown) {
        self.nativeAlertView = [[UIAlertView alloc] initWithTitle:self.title
                                                          message:self.message
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
        [self createCancelButtonIfNeed];
        for (AIAButtonDescriptor *buttonDescriptor in self.buttonDescriptors) {
            NSInteger idx = [self.nativeAlertView addButtonWithTitle:buttonDescriptor.title];
            buttonDescriptor.index = idx;
        }
        if (self.cancelButtonDescriptor) {
            NSInteger idx = [self.nativeAlertView addButtonWithTitle:self.cancelButtonDescriptor.title];
            self.cancelButtonDescriptor.index = idx;
            self.nativeAlertView.cancelButtonIndex = idx;
        }
        [self.nativeAlertView show];
    }
}

- (void)createCancelButtonIfNeed {
    NSInteger buttonsCount = [self.buttonDescriptors count] + (self.cancelButtonDescriptor ? 1 : 0);
    if (buttonsCount == 0) {
        [self addCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel button title") actionBlock:NULL];
    }
}

- (void)hide {
    [self.nativeAlertView dismissWithClickedButtonIndex:self.nativeAlertView.cancelButtonIndex animated:YES];
}


#pragma mark - UIAlertViewDelegate implementation

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSParameterAssert(alertView == self.nativeAlertView);

    [self performActionAtIndex:buttonIndex];

    [self performDismissAction];

    self.nativeAlertView = nil;
}

- (void)performActionAtIndex:(NSInteger)buttonIndex {
    AIAButtonDescriptor *buttonDescriptor = nil;
    if (buttonIndex >= 0 && buttonIndex < [self.buttonDescriptors count]) {
        buttonDescriptor = self.buttonDescriptors[buttonIndex];
        NSParameterAssert(buttonIndex == buttonDescriptor.index);
    }
    else {
        NSParameterAssert((!self.cancelButtonDescriptor && buttonIndex < 0)
                          || (self.cancelButtonDescriptor && self.cancelButtonDescriptor.index == buttonIndex));
        buttonDescriptor = self.cancelButtonDescriptor;
    }
    [buttonDescriptor perform];
}

- (void)performDismissAction {
    if (self.dismissActionBlock) {
        self.dismissActionBlock();
    }
}

@end
