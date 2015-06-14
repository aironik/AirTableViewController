//
//  AITSettingsTextCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/Values/ValuesWithDataSource/Text/AITTextCell.h>


@class AITCellEtchedView;


/**
 * @brief The cell that override AITTextCell behaviour
 * @details Define narrow cell for iOS 7 and higher and usual width otherwise
 */
@interface AITSettingsTextCell : AITTextCell

@property (nonatomic, weak) IBOutlet AITCellEtchedView *etchedView;

/**
 * @brief Set width of titleLabel, if width is 0, titleLabel isn't showing.
 */
@property (nonatomic, assign) CGFloat titleWidth;

@end
