//
//  AITValueDelegate.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@class AITValue;


/// @brief The protocol that defines additional external action for value changes.
@protocol AITValueDelegate<NSObject>

@required

/// @brief Tells the delegate that a specified value has become first AIT responder
- (void)valueDidBecomeFirstAitResponder:(AITValue *)value;

/// @brief Tells the delegate that a specified value has resign first AIT responder
- (void)valueDidResignFirstAitResponder:(AITValue *)value;

/// @brief Tells the delegate that empty value has changed.
- (void)valueEmptyChanged:(AITValue *)value;

/// @brief Tells the delegate that value should be shown and table view should scroll to specified cell.
- (void)valueNeedShow:(AITValue *)value;

@end
