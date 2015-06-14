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


@end
