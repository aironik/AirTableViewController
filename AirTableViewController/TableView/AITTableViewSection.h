//
//  AITTableViewSection.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponder.h>
#import <AirTableViewController/HeaderFooter/AITHeaderFooterView.h>


@class AITValue;
@class AITHeaderFooterView;

@protocol AITTableViewSectionDelegate;


@interface AITTableViewSection : NSObject<AITResponder>

/// @brief The array of objects AITValue class. This array defines cells and values contents.
/// @details You can create and set instances of values. Each instance define appropriate cell view and cell behaviour.
/// @see AITActionValue
/// @see AITBoolValue
/// @see AITChoiceValue
/// @see AITDateValue
/// @see AITPendingOperationValue
/// @see AITTextValue
@property (nonatomic, copy) NSArray *allObjects;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *footer;

@property (nonatomic, copy) NSString *headerViewIdentifier;
@property (nonatomic, copy) NSString *footerViewIdentifier;

/// @brief Code block that execute on tap in the header view.
@property (nonatomic, copy) AITHeaderFooterActionBlock headerActionBlock;

/// @brief Code block that execute on tap in the header view.
@property (nonatomic, copy) AITHeaderFooterActionBlock footerActionBlock;

/// @brief Change editing mode.
/// @details Set this value directly only if you are sure the table view doesn't shown.
///     Usually use -tableView:setEditing: instead.
@property (nonatomic, assign, getter=isEditing) BOOL editing;

/// @brief The next responder. The AITTableView setup this value next section.
@property (nonatomic, weak) id<AITResponder> nextAitResponder;

@property (nonatomic, weak) NSObject<AITTableViewSectionDelegate> *delegate;

/// @brief This value use for as default value for headerViewIdentifier if not defined.
+ (void)setDefaultHeaderViewIdentifier:(NSString *)defaultHeaderViewIdentifier;

/// @brief This value use for as default value for footerViewIdentifier if not defined.
+ (void)setDefaultFooterViewIdentifier:(NSString *)defaultFooterViewIdentifier;

- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing;

- (NSString *)tableViewTitleForHeader:(UITableView *)tableView;
- (AITHeaderFooterView *)tableViewHeaderView:(UITableView *)tableView;
- (CGFloat)tableViewHeightForHeader:(UITableView *)tableView;

- (NSString *)tableViewTitleForFooter:(UITableView *)tableView;
- (AITHeaderFooterView *)tableViewFooterView:(UITableView *)tableView;
- (CGFloat)tableViewHeightForFooter:(UITableView *)tableView;

- (NSInteger)tableViewNumberOfRows:(UITableView *)tableView;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row;
- (BOOL)tableView:(UITableView *)tableView canEditRow:(NSInteger)row;

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSInteger)row;
- (void)tableView:(UITableView *)tableView didSelectRow:(NSInteger)row;
- (void)tableView:(UITableView *)tableView willBeginEditingRow:(NSInteger)row;
- (void)tableView:(UITableView *)tableView didEndEditingRow:(NSInteger)row;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRow:(NSInteger)row;

/// @brief Show details cell for value.
/// @details Insert cell below main value cell with view from
///     [value.detailsViewControllerProvider detailsViewControllerForValue:value].
///     If other details cell shown it hides. If -detailsViewControllerForValue: return nil cell doesn't show.
- (void)showDetailsCellForValue:(AITValue *)value;

/// @brief Hide details cell for value if shown.
/// @details Delete details cell below main value cell if shown.
- (void)hideDetailsCellForValue:(AITValue *)value;

/// @brief Get index for value in the section.
- (NSInteger)rowForValue:(AITValue *)value;

/// @brief Tell the section that it will remove from table view controller.
/// @details Prepare for destroy. E.g. unsubscribe KVO and notify values. After this method data can be destroyed.
- (void)willRemove;

@end
