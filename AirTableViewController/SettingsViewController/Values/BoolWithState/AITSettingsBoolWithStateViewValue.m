//
//  AITSettingsBoolWithStateViewValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsBoolWithStateViewValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif

@interface AITSettingsBoolWithStateViewValue()
@end


#pragma mark - Implementation


@implementation AITSettingsBoolWithStateViewValue


+ (instancetype)valueWithTitle:(NSString *)title
                   bottomTitle:(NSString *)bottomTitle
                         color:(UIColor *)color
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath {
    
    AITSettingsBoolWithStateViewValue *value = [self valueWithTitle:title sourceObject:sourceObject sourceKeyPath:sourceKeyPath];
    value.bottomTitle = bottomTitle;
    value.color = color;
    
    return value;
}


@end
