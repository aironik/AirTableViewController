//
//  AITDetailsCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.07.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import <AirTableViewController/Values/Base/AITTableViewCell.h>


@class AITDetailsValue;


/// @brief The cell for present details view controller.
/// @details  The cell represents cell with details. User can tap on the cell for present details view.
@interface AITDetailsCell : AITTableViewCell

/// @brief The value represents details for present.
@property (nonatomic, weak) AITDetailsValue *detailsValue;

@end
