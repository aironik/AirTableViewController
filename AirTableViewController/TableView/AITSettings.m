//
//  AITSettings.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettings.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettings ()
@end


#pragma mark - Implementation


@implementation AITSettings


@synthesize navigationControllerClass = _navigationControllerClass;
@synthesize preferredPopupSize = _preferredPopupSize;


- (instancetype)init {
    if ((self = [super init])) {
        _navigationControllerClass = [UINavigationController class];
        _preferredPopupSize = CGSizeMake(560.f, 560.f);
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    AITSettings *result = [[[self class] alloc] init];
    result.navigationControllerClass = self.navigationControllerClass;
    result.preferredPopupSize = self.preferredPopupSize;
    return result;
}


@end
