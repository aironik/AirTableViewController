//
//  AITPendingOperationSection.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITTableViewSection.h>


/// @brief The table view section which can replace content while pending operation executing on activity indicator.
@interface AITPendingOperationSection : AITTableViewSection

/// @brief Determine if pending operation is executing now.
/// @details If YES activity indicator shown instead all cells in the section.
@property (nonatomic, assign, readonly) BOOL pendingOperationExecuting;

/// @brief Switch executing flag.
/// @details Replace cells in the table view.
- (void)tableView:(UITableView *)tableView setPendingOperationExecuting:(BOOL)executing currentSectionIndex:(NSInteger)index;

@end
