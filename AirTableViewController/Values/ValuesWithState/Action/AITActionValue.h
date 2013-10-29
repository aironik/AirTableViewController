//
//  AITActionValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 20.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITValue.h>


@class AITActionValue;


typedef void (^AITActionValueBlock)(AITActionValue *value);


/// @brief The action with title and action block code.
@interface AITActionValue : AITValue

/// @brief The code block for perform action.
@property (nonatomic, copy) AITActionValueBlock action;

/// @brief Perform possibility flag.
/// @details If YES action execution possible and cell title text is black (enabled).
///     Otherwise no way to execute action and cell text gray (disabled).
@property (nonatomic, assign) BOOL enabled;

/// @brief Create new action value instance.
+ (instancetype)valueWithTitle:(NSString *)title action:(AITActionValueBlock)action;

/// @brief Returns a boolean value that indicates whether the value an perform action.
/// @details The value can perform action if it enabled and has action.
- (BOOL)canPerform;

@end
