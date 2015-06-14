//
//  AITSettingsSubtitledActionValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/SettingsViewController/Values/Action/AITSettingsActionValue.h>


/**
 * @brief Choice value without accessory view with title and subtitle.
 */
@interface AITSettingsSubtitledActionValue : AITSettingsActionValue

/**
 * @brief String that represent subtitle.
 */
@property (nonatomic, copy, readonly) NSString *subtitle;

/**
 * @brief Create new subtitled value.
 */
+ (instancetype)valueWithTitle:(NSString *)title subtitle:(NSString *)subtitle action:(AITActionValueBlock)action;

/**
 * @brief Initialize new subtitled value.
 */
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle action:(AITActionValueBlock)action;


@end
