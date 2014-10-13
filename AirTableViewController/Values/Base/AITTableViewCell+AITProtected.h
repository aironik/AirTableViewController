//
//  AITTableViewCell(AITProtected).m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 26.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//


#import "AITTableViewCell.h"


@interface AITTableViewCell (AITProtected)

/// @brief Setup cell after create (-awakeFromNib or -init).
/// @details Should invoke super.
- (void)setup;

/// @brief Array of strings propertyes names for KVO observing -value.
- (NSArray *)keyPathsForSubscribe;

@end
