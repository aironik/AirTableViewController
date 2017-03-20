//
//  AITSettingsChoiceValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/Values/ValuesWithDataSource/Choice/AITChoiceValue.h>


/**
 * @brief The cell that override AITChoiceValue behaviour
 * @details Define narrow cell for iOS 7 and higher and usual width otherwise
 */
@interface AITSettingsChoiceValue : AITChoiceValue

/// @brief Perform possibility flag.
/// @details If YES action execution possible.
///     Otherwise no way to execute action.
@property (nonatomic, assign) BOOL enabled;

/// @brief Array that contains titles for all possible values as NSString value.
@property (nonatomic, strong) NSArray *allOptions;

@end
