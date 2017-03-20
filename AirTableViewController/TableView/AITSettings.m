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
@synthesize tintColor = _tintColor;
@synthesize settingsFooterText = _settingsFooterText;
@synthesize borderColor = _borderColor;
@synthesize cellSeparatorColor = _cellSeparatorColor;
@synthesize emptyBackgroundColor = _emptyBackgroundColor;
@synthesize emptyScreenTextColor = _emptyScreenTextColor;
@synthesize borderWidth = _borderWidth;


#define AIT_COLOR_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a) / 255.f]
#define AIT_COLOR_RGB(r, g, b) AIT_COLOR_RGBA(r, g, b, 255.f)


- (instancetype)init {
    if ((self = [super init])) {
        _navigationControllerClass = [UINavigationController class];
        _preferredPopupSize = CGSizeMake(560.f, 560.f);

        UIColor *settingsTextColor = AIT_COLOR_RGB(98.f, 98.f, 98.f);

        _tintColor = AIT_COLOR_RGB(248.f, 110.f, 53.f);
        _settingsFooterText = settingsTextColor;
        _borderColor = [UIColor clearColor];
        _cellSeparatorColor = AIT_COLOR_RGB(178.f, 178.f, 178.f);
        _emptyBackgroundColor = AIT_COLOR_RGB(240.f, 240.f, 240.f);
        _emptyScreenTextColor = settingsTextColor;

        _borderWidth = 0.5f;
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
