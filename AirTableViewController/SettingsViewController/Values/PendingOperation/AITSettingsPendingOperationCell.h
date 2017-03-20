//
//  AITSettingsPendingOperationCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/Values/ValuesWithState/PendingOperation/AITPendingOperationCell.h>


@class AITCellEtchedView;


/**
 * @brief The cell that override AITPendingOperationCell behaviour
 * @details Define narrow cell for iOS 7 and higher and usual width otherwise
 */
@interface AITSettingsPendingOperationCell : AITPendingOperationCell

@property (nonatomic, weak) IBOutlet AITCellEtchedView *etchedView;

@end
