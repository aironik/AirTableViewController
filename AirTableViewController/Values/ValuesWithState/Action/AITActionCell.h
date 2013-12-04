//
//  AITActionCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 20.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewCell.h"


@class AITActionValue;


/// @brief The cell for perform any action.
/// @details  The cell represents cell with name of the action title . User can tap on the cell for perform action.
@interface AITActionCell : AITTableViewCell

/// @brief The value represents action for perform.
@property (nonatomic, weak) AITActionValue *actionValue;

@end
