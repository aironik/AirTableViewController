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

/// @brief Tell the delegate show viewController in popover controller.
/// @return The popover controller that presents viewController.
- (UIPopoverController *)value:(id<AITValue>)value showPopoverWithController:(UIViewController *)viewController;

/// @brief Tell the delegate show details controller.
/// @details e.g. push into navigation stack or as details view controller in the split view controller.
- (void)value:(id<AITValue>)value showDetailsController:(UIViewController *)viewController;

@end
