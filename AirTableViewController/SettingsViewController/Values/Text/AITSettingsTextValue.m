//
//  AITSettingsTextValue.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsTextValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsTextValue ()
@end


#pragma mark - Implementation


@implementation AITSettingsTextValue

+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath
                       comment:(NSString *)comment
{
    AITSettingsTextValue *value = [super valueWithTitle:title
                                           sourceObject:sourceObject
                                          sourceKeyPath:(NSString *)sourceKeyPath
                                                comment:comment];
    
    value.titleLabelResizable = NO;
    value.valueTextAligment = NSTextAlignmentLeft;
    return value;
}

- (BOOL)isEmpty {
    return NO;
}


@end
