//
//  AITBoolValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITBoolValue.h"
#import "AITValueWithSource+AITProtected.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITBoolValue ()
@end


#pragma mark - Implementation

@implementation AITBoolValue

- (BOOL)value {
    NSNumber *numberValue = self.sourceValue;
    NSParameterAssert(!numberValue || [numberValue isKindOfClass:[NSNumber class]]);
    return [numberValue boolValue];
}

- (void)setValue:(BOOL)value {
    self.sourceValue = @(value);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ value == \"%@\">",
                     [super description],
                     (self.value ? @"YES" : @"NO")];
}


#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return NO;
}

- (BOOL)canResignFirstAitResponder {
    return YES;
}


@end
