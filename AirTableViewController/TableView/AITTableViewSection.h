//
//  AITTableViewSection.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//


/// @brief Animation by default in insert/delete sections/cells
extern const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation;


@interface AITTableViewSection : NSObject

@property (nonatomic, copy) NSArray *allObjects;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *footer;

/// @brief Переключить режим редактирования.
/// @details Если нужно обновить UITableView, то нужно использовать -tableView:setEditing:currentSectionIndex:
@property (nonatomic, assign, getter=isEditing) BOOL editing;

- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing currentSectionIndex:(NSInteger)index;

- (NSString *)tableViewTitleForHeader:(UITableView *)tableView;
- (NSString *)tableViewTitleForFooter:(UITableView *)tableView;
- (NSInteger)tableViewNumberOfRows:(UITableView *)tableView;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row;
- (BOOL)tableView:(UITableView *)tableView canEditRow:(NSInteger)row;

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSInteger)row;
- (void)tableView:(UITableView *)tableView didDeselectRow:(NSInteger)row;
- (void)tableView:(UITableView *)tableView willBeginEditingRow:(NSInteger)row;
- (void)tableView:(UITableView *)tableView didEndEditingRow:(NSInteger)row;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRow:(NSInteger)row;

@end
