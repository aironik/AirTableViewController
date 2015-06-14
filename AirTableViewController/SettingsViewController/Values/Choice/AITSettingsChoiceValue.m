//
//  AITSettingsChoiceValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsChoiceValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsChoiceValue ()
@end


#pragma mark - Implementation


@implementation AITSettingsChoiceValue

+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
          titleStringFromValue:(AITChoiceOptionTitleValueString)titleStringFromValue
{
    AITSettingsChoiceValue *value = [super valueWithTitle:title
                                             sourceObject:sourceObject
                                            sourceKeyPath:sourceKeyPath
                                     titleStringFromValue:titleStringFromValue];
    value.enabled = YES;
    return value;
}

#pragma mark - AITResponder protocol implementation

- (BOOL)canBecomeFirstAitResponder {
    return self.enabled;
}

@end
