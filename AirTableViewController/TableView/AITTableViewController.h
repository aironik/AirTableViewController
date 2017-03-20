//
//  AITTableViewController.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@class AITSettings;
@class AITTableViewSection;


/// @brief Animation by default in insert/delete sections/cells
extern const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation;


/// @brief The table view controller with declarative content definition
@interface AITTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, assign) CGFloat topSpace;
@property (nonatomic, assign) CGFloat bottomSpace;

/// @brief Don't change size on keyboard show/hide.
/// @details On show keyboard view try shrink and return previous size on keyboard hidding.
///     If this behaviour is undesirable you can set ignoreKeyboardShrink property.
///     For example if you show table view as inner view in other view change size
///     can be unpredicted or undesired.
///     Default value if NO.
@property (nonatomic, assign) BOOL ignoreKeyboardShrink;

/// @brief The array of AITTableViewSection objects.
/// @details This array defines content of the table view. Each section defines cells with values section content.
/// @see AITTableViewSection
@property (nonatomic, strong) NSArray *sections;

/// @brief Default settings for all AITTableViewController instances.
/// @see +defaultSettings
/// @see +setDefaultSettings:
+ (AITSettings *)defaultSettings;

/// @brief Set default settings for all AITTableViewController instances.
/// @see +defaultSettings
/// @see +setDefaultSettings:
+ (void)setDefaultSettings:(AITSettings *)defaultSettings;

/// @brief Reload section in table view
- (void)reloadSection:(AITTableViewSection *)section;

- (void)save;
- (void)rollback;


@end
