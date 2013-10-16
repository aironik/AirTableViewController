//
//  AITValueDelegate.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@protocol AITValue;


/// @brief The protocol that defines additional external action for value changes.
@protocol AITValueDelegate<NSObject>

@required

/// @brief Tells the delegate that a specified value needs additional cell for present additional data.
- (void)value:(id<AITValue>)value presentAdditionalaDataInCellWithIdentifier:(NSString *)cellIdentifier;

/// @brief Tells the delegate that a specified cell no more needs additional cell for present data.
- (void)value:(id<AITValue>)value dismissAdditionalaDataInCellWithIdentifier:(NSString *)cellIdentifier;

/// @brief Tells the delegate that value should be shown and table view should scroll to specified cell.
- (void)valueNeedShow:(id<AITValue>)value;

@end