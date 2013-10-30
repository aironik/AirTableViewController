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

// TODO: remove method below

/// @brief Tells the delegate that a specified value needs additional cell for present additional data.
- (void)value:(AITValue *)value presentAdditionalaDataInCellWithIdentifier:(NSString *)cellIdentifier;

/// @brief Tells the delegate that a specified cell no more needs additional cell for present data.
- (void)value:(AITValue *)value dismissAdditionalaDataInCellWithIdentifier:(NSString *)cellIdentifier;

/// @brief Tells the delegate that value should be shown and table view should scroll to specified cell.
- (void)valueNeedShow:(AITValue *)value;

/// @brief Tell the delegate show viewController in popover controller.
/// @return The popover controller that presents viewController.
- (UIPopoverController *)value:(AITValue *)value showPopoverWithController:(UIViewController *)viewController;

/// @brief Tell the delegate show details controller.
/// @details e.g. push into navigation stack or as details view controller in the split view controller.
- (void)value:(AITValue *)value showDetailsController:(UIViewController *)viewController;

@end
