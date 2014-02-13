//
//  UIView(AITUserInterfaceIdiom).m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.02.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "UIView+AITUserInterfaceIdiom.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


#pragma mark - Implementation

@implementation UIView (AITUserInterfaceIdiom)


static AITUserInterfaceIdiomVersion userInterfaceIdiomVersion = AITUserInterfaceIdiomVersionSystemDefined;

+ (AITUserInterfaceIdiomVersion)userInterfaceIdiomVersion {
    if (userInterfaceIdiomVersion == AITUserInterfaceIdiomVersionSystemDefined) {
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        NSInteger majorVersion = [systemVersion integerValue];
        if (majorVersion > 0 && majorVersion < 7) {
            userInterfaceIdiomVersion = AITUserInterfaceIdiomVersion6;
        }
        else {
            userInterfaceIdiomVersion = AITUserInterfaceIdiomVersion7;
        }
    }
    return userInterfaceIdiomVersion;
}

+ (void)setUserInterfaceIdiomVersion:(AITUserInterfaceIdiomVersion)idiom {
    userInterfaceIdiomVersion = idiom;
}

- (UIColor *)ait_tintColor {
    UIColor *result = nil;
    if ([[self class] userInterfaceIdiomVersion] == AITUserInterfaceIdiomVersion6) {
        result = [UIColor blackColor];
    }
    else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        if ([self respondsToSelector:@selector(tintColor)]) {
            result = [self tintColor];
        }
        else
#endif // __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        {
            result = [UIColor blueColor];
        }
    }
    return result;
}


@end
