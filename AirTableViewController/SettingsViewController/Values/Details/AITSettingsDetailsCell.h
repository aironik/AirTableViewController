//
//  AITSettingsDetailsCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/Values/ValuesWithState/Details/AITDetailsCell.h>


@class AITCellEtchedView;


/**
 * @brief The cell that override AITActionCell behaviour
 * @details Define narrow cell for iOS 7 and higher and usual width otherwise
 */
@interface AITSettingsDetailsCell : AITDetailsCell

@property (nonatomic, weak) IBOutlet AITCellEtchedView *etchedView;

@end
