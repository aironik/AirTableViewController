//
//  AITDetailsViewControllerProvider.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 31.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@class AITValue;


typedef NS_ENUM(NSUInteger, AITDetailsPresentationStyle) {

    /// @brief No presentation style. The details view controller should not show.
    AITDetailsPresentationStyleNone = 0,

    /// @brief The preferred presentation style in details cell
    AITDetailsPresentationStyleCell,

    /// @brief The preferred presentation style in popover
    AITDetailsPresentationStylePopover,

    /// @brief The preferred presentation style modal view controller
    AITDetailsPresentationStyleModal,

    /// @brief The preferred presentation style push into navigation controller.
    /// @details If impossible the controller shows as modal.
    AITDetailsPresentationStylePushNavigation,

    /// @brief The presentation implements by AITDetailsViewControllerProvider.
    /// @details AITDetailsViewControllerProvider have to implement -presentDetailsViewControllerForValue:.
    AITDetailsPresentationStyleCustom,
};

@protocol AITDetailsViewControllerProvider<NSObject>

@required

/// @brief Tells the preferred presentation style
/// @see AITChildViewControllerPresentationStyle;
- (AITDetailsPresentationStyle)presentationStyle;

/// @brief The factory that creates new details view controller for specified value.
/// @details The result this method shows as details view controller according presentationStyle.
/// @see -presentationStyle
- (UIViewController *)detailsViewControllerForValue:(AITValue *)value;

@optional

/// @brief Present details controller for presentation style AITDetailsPresentationStyleCustom.
/// @details You have to implement this method if you want to customise present
- (void)presentDetailsViewControllerForValue:(AITValue *)value;

@end
