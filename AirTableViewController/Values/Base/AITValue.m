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


@interface AITValue ()
@end


#pragma mark - Implementation

@implementation AITValue

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

@end
