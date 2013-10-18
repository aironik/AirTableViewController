//
//  AITTableViewSection.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponder.h>


/// @brief Animation by default in insert/delete sections/cells
extern const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation;


@class AITHeaderFooterView;

@protocol AITTableViewSectionDelegate;


@interface AITTableViewSection : NSObject<AITResponder>

/// @brief The array of objects conforms to AITValue protocol. This array defines cells and values contents.
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


/// @brief Переключить режим редактирования.
/// @details Если нужно обновить UITableView, то нужно использовать -tableView:setEditing:currentSectionIndex:
@property (nonatomic, assign, getter=isEditing) BOOL editing;

/// @brief The next responder. The AITTableView setup this value next section.
@property (nonatomic, weak) id<AITResponder> nextAitResponder;

@property (nonatomic, weak) NSObject<AITTableViewSectionDelegate> *delegate;

- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing currentSectionIndex:(NSInteger)index;

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
- (void)tableView:(UITableView *)tableView didDeselectRow:(NSInteger)row;
- (void)tableView:(UITableView *)tableView willBeginEditingRow:(NSInteger)row;
- (void)tableView:(UITableView *)tableView didEndEditingRow:(NSInteger)row;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRow:(NSInteger)row;

@end
