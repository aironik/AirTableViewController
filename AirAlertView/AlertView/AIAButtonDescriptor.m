//
//  AIAButtonDescriptor.m
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.01.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "AIAButtonDescriptor.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AIAButtonDescriptor ()
@end


#pragma mark - Implementation

@implementation AIAButtonDescriptor

+ (instancetype)buttonDescriptorWithTitle:(NSString *)title actionBlock:(AIAAlertViewActionBlock)actionBlock {
    return [[self alloc] initWithTitle:title actionBlock:actionBlock];
}

- (instancetype)initWithTitle:(NSString *)title actionBlock:(AIAAlertViewActionBlock)actionBlock {
    if (self = [super init]) {
        _title = [title copy];
        _actionBlock = [actionBlock copy];
        _index = -1;
    }
    return self;
}

- (void)perform {
    if (self.actionBlock) {
        self.actionBlock();
    }
}


@end
