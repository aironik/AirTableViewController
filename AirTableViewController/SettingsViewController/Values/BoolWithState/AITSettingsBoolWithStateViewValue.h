//
//  AITSettingsBoolWithStateViewValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/SettingsViewController/Values/Bool/AITSettingsBoolValue.h>


@interface AITSettingsBoolWithStateViewValue : AITSettingsBoolValue

@property (nonatomic, copy) NSString *bottomTitle;

@property (nonatomic, copy) UIColor *color;

+ (instancetype)valueWithTitle:(NSString *)title
                   bottomTitle:(NSString *)bottomTitle
                         color:(UIColor *)color
                  sourceObject:(NSObject *)sourceObject
                 sourceKeyPath:(NSString *)sourceKeyPath;

@end
