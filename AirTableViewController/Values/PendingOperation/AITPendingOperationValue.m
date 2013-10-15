//
//  AITPendingOperationValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITPendingOperationValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITPendingOperationValue ()
@end


#pragma mark - Implementation

@implementation AITPendingOperationValue

+ (instancetype)valueWithTitle:title {
    return [[self alloc] initWithTitle:title];
}

- (id)initWithTitle:(id)title {
    if (self = [super init]) {
        _title = [title copy];
        _empty = NO;
    }
    return self;
}

+ (NSString *)cellIdentifier {
    return @"AITPendingOperationCell";
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

@end
