//
//  AITSettingsSubtitledActionCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//


#import <AirTableViewController/SettingsViewController/Values/Details/AITSettingsDetailsCell.h>


@class AITSettingsSubtitledActionValue;


/**
 * @brief Cell that used for choose option with title and subtitle text.
 */
@interface AITSettingsSubtitledActionCell : AITSettingsDetailsCell

/**
 * @brief Label that represent gray details text.
 */
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

/**
 * @brief Value
 */
@property (nonatomic, weak) AITSettingsSubtitledActionValue *subtitledValue;

@end
