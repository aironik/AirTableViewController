//
//  AITTableViewController.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//


/// @brief Animation by default in insert/delete sections/cells
extern const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation;

/// @brief Defines user interface idiom that used ad UI.
/// @details e.g. blue (tintColor) action values and date picker in popover or additional cell.
typedef enum {
    /// @brief The UI appropriate current device iOS version.
    /// @details This value using for set +setUserInterfaceIdiomVersion:
    ///     and never returns from +userInterfaceIdiomVersion
    /// @see +setUserInterfaceIdiomVersion:
    /// @see +userInterfaceIdiomVersion
    AITUserInterfaceIdiomVersionSystemDefined = 0,

    /// @brief The UI appropriate iOS6
    /// @details Date picker in popover and black action value cells.
    AITUserInterfaceIdiomVersion6,

    /// @brief The UI appropriate iOS7
    /// @details Date picker in additional cell and blue (tint color) action value cells.
    AITUserInterfaceIdiomVersion7,
} AITUserInterfaceIdiomVersion;


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

/// @brief Get current UI idiom
/// @details default value appropriate default system interface idiom. For force use interface idiom
/// @see +setUserInterfaceIdiomVersion:
+ (AITUserInterfaceIdiomVersion)userInterfaceIdiomVersion;

/// @brief Set  force UI idiom
/// @details default value appropriate default system interface idiom. For force use interface idiom
/// @see +setUserInterfaceIdiomVersion:
+ (void)setUserInterfaceIdiomVersion:(AITUserInterfaceIdiomVersion)idiom;

- (void)save;
- (void)rollback;

@end
