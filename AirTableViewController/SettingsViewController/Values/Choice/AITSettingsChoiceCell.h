//
//  AITSettingsChoiceCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//


#import <AirTableViewController/Values/ValuesWithDataSource/Choice/AITChoiceCell.h>


@class AITCellEtchedView;


/**
 * @brief The cell that override AITChoiceCell behaviour
 * @details Define narrow cell for iOS 7 and higher and usual width otherwise
 */
@interface AITSettingsChoiceCell : AITChoiceCell

@property (nonatomic, weak) IBOutlet AITCellEtchedView *etchedView;

@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;

@end
