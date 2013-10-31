//
//  AITTableViewController.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//


/// @brief Animation by default in insert/delete sections/cells
extern const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation;


/// @brief The table view controller with declarative content definition
@interface AITTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, assign) CGFloat topSpace;
@property (nonatomic, assign) CGFloat bottomSpace;

/// @brief The array of AITTableViewSection objects.
/// @details This array defines content of the table view. Each section defines cells with values section content.
/// @see AITTableViewSection
@property (nonatomic, strong) NSArray *sections;

- (void)save;
- (void)rollback;

@end
