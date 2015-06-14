//
//  AITSettings.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//


/**
 * @brief Settings for AITTableView and AITSettingsTableView.
 * @details This class setup AITTableView appearance and behaviour.
 *      E.g. you can setup background color, border width and
 *      default navigation controller class.
 */
@interface AITSettings : NSObject<NSCopying>

/**
 * @brief Defines class for navigation in child controllers.
 */
@property (nonatomic, assign) Class navigationControllerClass;

/**
 * @brief Defines preffered size for child controllers if shown in popup.
 */
@property (nonatomic, assign) CGSize preferredPopupSize;

/**
 * @brief Tint color for AirTableView project.
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 * @brief Color for simple footer views text.
 */
@property (nonatomic, strong) UIColor *settingsFooterText;

/**
 * @brief Border color for cells in settings table view.
 * @see borderWidth
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 * @brief Color for cells separator in settings table view.
 */
@property (nonatomic, strong) UIColor *cellSeparatorColor;

/**
 * @brief Background color in empty settings view.
 */
@property (nonatomic, strong) UIColor *emptyBackgroundColor;

/**
 * @brief Text color for background in empty settings view.
 */
@property (nonatomic, strong) UIColor *emptyScreenTextColor;

/**
 * @brief Width for cells border.
 */
@property (nonatomic, assign) CGFloat borderWidth;

@end
