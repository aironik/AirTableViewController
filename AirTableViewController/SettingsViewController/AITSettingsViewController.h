//
//  AITSettingsViewController.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//


#import <AirTableViewController/TableView/AITTableViewController.h>


typedef void(^AITSettingsCloseBlock)();

extern NSString *const kAITSettingsActionFooterIdentifier;
extern NSString *const kAITSettingsErrorFooterIdentifier;
extern NSString *const kAITSettingsFooterIdentifier;
extern NSString *const kAITSettingsHeaderIdentifier;


/**
 * @brief Base view controller for all settings screens.
 * @details The view controller loads view from AITSettingsTableView.nib.
 *      So you can initiate it using [[AITClass alloc] initWithNibNamed:nil bundle: nil]
 *      but it loads from the same nib and ignore other nibs.
 */
@interface AITSettingsViewController : AITTableViewController<UISearchBarDelegate>

/**
 * @brief Modal view that contains view controller.
 */
@property (nonatomic, copy) AITSettingsCloseBlock closeBlock;

/**
 * @brief If YES search bar shown on the top of view.
 */
@property (nonatomic, assign, getter=isSearchBarShown) BOOL searchBarShown;

/**
 * @brief Search bar that can be shown on the top of view.
 */
@property (nonatomic, weak, readonly) IBOutlet UISearchBar *searchBar;

/**
 * @brief Search bar prompt text.
 */
@property (nonatomic, copy) NSString *searchPrompt;

/**
 * @brief Text that shows on empty view.
 */
@property (nonatomic, copy) NSString *emptyViewText;

/**
 * @briefView that shown if data set is empty.
 */
@property (nonatomic, weak) IBOutlet UIView *emptyView;

/**
 * @brief Hide table view and show activity indicator for show pending process.
 * @see stopActivityIndicator
 */
- (void)startActivityIndicator;

/**
 * @brief Hide activity indicator for show pending process and show table view.
 * @see startActivityIndicator
 */
- (void)stopActivityIndicator;

/**
 * @brief Show empty view instead table view content
 */
- (void)showEmptyView;

/**
 * @brief Hide empty view that has been shown by -showEmptyView
 */
- (void)hideEmptyView;

/**
 * @brief Close view controller.
 * @detail call closeBlock.
 */
- (IBAction)close:(id)sender;

/**
 * @brief Update content frame for reloaded content.
 * @details This selector for child usage.
 */
- (void)updateContentHeight;

@end
