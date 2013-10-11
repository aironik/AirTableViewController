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

/// @brief Значение, с которым работаем. Из него обновляются UI-элементы
@property (nonatomic, strong) NSObject<AITValue> *value;

/// @brief Title label. This text value represent property name e.g. "Name", "Title", "Description".
/// @details Text set form value.
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/// @brief Deselect cell immediately after select.
/// @details If YES the cell will deselect immediagtely after user tap over the cell.
///     If NO the cell will deselect on table view will appear.
@property (nonatomic, assign) BOOL deselectImmediately;

/// @brief Setup the TableView for work with cell class.
/// @details Register cell xib for class
+ (void)setupTableView:(UITableView *)tableView;

@end
