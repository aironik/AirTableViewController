//
//  AITTableViewCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 26.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponder.h>


@protocol AITValue;
@class AITTableViewCell;


/// @brief TableViewCell represents value. Base class for other cells.
@interface AITTableViewCell : UITableViewCell<AITResponder>

/// @brief The data source value. This value defines UI elements contents.
@property (nonatomic, strong) NSObject<AITValue> *value;

/// @brief Title label. This text value represent property name e.g. "Name", "Title", "Description".
/// @details Text set form value.
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/// @brief Setup the TableView for work with cell class.
/// @details Register cell xib for class
+ (void)setupTableView:(UITableView *)tableView;

/// @brief Defines cell height for value. If 0 table view should use default -rowHeight value.
- (CGFloat)prefferedHeight;

@end
