//
//  UIView(AITUserInterfaceIdiom).m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.02.14.
//  Copyright © 2014 aironik. All rights reserved.
//


/// @brief Defines user interface idiom that used ad UI.
/// @details e.g. blue (tintColor) action values and date picker in popover or additional cell.
typedef enum {
    /// @brief The UI appropriate current device iOS version.
    /// @details This value using for set +setUserInterfaceIdiomVersion:
    ///     and never returns from +userInterfaceIdiomVersion
    /// @see +setUserInterfaceIdiomVersion:
    /// @see +userInterfaceIdiomVersion
    AITUserInterfaceIdiomVersionSystemDefined = 0,

    /// @brief The UI appropriate iOS6
    /// @details Date picker in popover and black action value cells.
    AITUserInterfaceIdiomVersion6,

    /// @brief The UI appropriate iOS7
    /// @details Date picker in additional cell and blue (tint color) action value cells.
    AITUserInterfaceIdiomVersion7,
} AITUserInterfaceIdiomVersion;


@interface UIView (AITUserInterfaceIdiom)

/// @brief Get current UI idiom
/// @details default value appropriate default system interface idiom. For force use interface idiom
/// @see +setUserInterfaceIdiomVersion:
+ (AITUserInterfaceIdiomVersion)ait_userInterfaceIdiomVersion;

/// @brief Set  force UI idiom
/// @details default value appropriate default system interface idiom. For force use interface idiom
/// @see +setUserInterfaceIdiomVersion:
+ (void)ait_setUserInterfaceIdiomVersion:(AITUserInterfaceIdiomVersion)idiom;

/// @brief Get tint color.
/// @details This selector emulate tint color. If +userInterfaceIdiomVersion returns iOS6 interface idiom
///     this selector returns blackColor.
///     If UI supports tintColor selector and +userInterfaceIdiomVersion appropriates to iOS7 this
///     method returns tintColor (or blueColor if UIView doesn't responds to -tintColor).
- (UIColor *)ait_tintColor;

/// @brief Set tint color if possible.
/// @details This selector emulate tint color. If +userInterfaceIdiomVersion returns iOS6 interface idiom
///     this selector do nothing.
///     If UI supports tintColor selector and +userInterfaceIdiomVersion appropriates to iOS7 this
///     method set system tintColor.
- (void)ait_setTintColor:(UIColor *)tintColor;


@end
