//
//  AITTableViewController.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewController.h"

#import "AITTableViewSection.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTableViewController ()
@end


#pragma mark - Implementation

@implementation AITTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    BOOL switchingFromEditing = (self.editing && !editing);

    [self updateSectionsForEditing:editing];

    [super setEditing:editing animated:animated];

    if (switchingFromEditing) {
        [self save];
    }
}

- (void)updateSectionsForEditing:(BOOL)editing {
    [self.tableView beginUpdates];
    [self.sections enumerateObjectsUsingBlock:^(AITTableViewSection *section, NSUInteger index, BOOL *stop) {
        [section tableView:self.tableView setEditing:editing currentSectionIndex:index];
    }];

    [self.tableView endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    AITTableViewSection *viewSection = self.sections[section];
    return [viewSection tableViewTitleForHeader:tableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    AITTableViewSection *viewSection = self.sections[section];
    return [viewSection tableViewTitleForFooter:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    AITTableViewSection *viewSection = self.sections[section];
    return [viewSection tableViewNumberOfRows:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AITTableViewSection *viewSection = self.sections[indexPath.section];
    return [viewSection tableView:tableView cellForRow:indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    AITTableViewSection *viewSection = self.sections[indexPath.section];
    return [viewSection tableView:tableView canEditRow:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AITTableViewSection *viewSection = self.sections[indexPath.section];
    return [viewSection tableView:tableView heightForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AITTableViewSection *viewSection = self.sections[indexPath.section];
    [viewSection tableView:tableView didDeselectRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    AITTableViewSection *viewSection = self.sections[indexPath.section];
    [viewSection tableView:tableView willBeginEditingRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    AITTableViewSection *viewSection = self.sections[indexPath.section];
    [viewSection tableView:tableView didEndEditingRow:indexPath.row];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    AITTableViewSection *viewSection = self.sections[indexPath.section];
    return [viewSection tableView:tableView editingStyleForRow:indexPath.row];
}

- (void)save {
    
}

- (void)rollback {
    
}


@end
