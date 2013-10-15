//
//  AITTableViewController.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewController.h"

#import "AITActionCell.h"
#import "AITHeaderFooterView.h"
#import "AITPendingOperationCell.h"
#import "AITResponderValue.h"
#import "AITSwitchCell.h"
#import "AITTableViewSection.h"
#import "AITTextCell.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTableViewController ()

@property (nonatomic, assign) BOOL loadedFromNib;

@end


#pragma mark - Implementation

@implementation AITTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    self.loadedFromNib = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.loadedFromNib) {
        self.topSpace = self.topConstraint.constant;
        self.bottomSpace = self.bottomConstraint.constant;
    }
    else {
        self.topConstraint.constant = self.topSpace;
        self.bottomConstraint.constant = self.bottomSpace;
    }
    
    [AITActionCell setupTableView:self.tableView];
    [AITPendingOperationCell setupTableView:self.tableView];
    [AITSwitchCell setupTableView:self.tableView];
    [AITTextCell setupTableView:self.tableView];

    [AITHeaderFooterView setupTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bottomConstraint.constant = self.bottomSpace;
    self.topConstraint.constant = self.topSpace;

    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedRows) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }

    [self subscribeForKeyboardNotifications];
    [self subscribeForValueBecomeFirstAitResponderNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // iOS 7 fix. If go back from other view and other view opened while keyboard did shown.
    self.bottomConstraint.constant = self.bottomSpace;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self unsubscribeForValueBecomeFirstAitResponderNotification];
    [self unsubscribeForKeyboardNotifications];

    [super viewDidDisappear:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    BOOL switchingFromEditing = (self.editing && !editing);

    [self updateSectionsForEditing:editing];

    [super setEditing:editing animated:animated];

    if (switchingFromEditing) {
        [self save];
    }
}

- (void)setSections:(NSArray *)sections {
    if (_sections != sections) {
        _sections = sections;
        [self updateSectionsResponderChain];
        [self updateSectionsForEditing:self.editing];
    }
}

- (void)updateSectionsResponderChain {
    id<AITResponder> previousResponder = nil;
    for (id<AITResponder> responder in self.sections) {
        [previousResponder setNextAitResponder:responder];
        previousResponder = responder;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AITTableViewSection *viewSection = self.sections[section];
    return [viewSection tableViewHeaderView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    AITTableViewSection *viewSection = self.sections[section];
    return [viewSection tableViewHeightForHeader:tableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    AITTableViewSection *viewSection = self.sections[section];
    return [viewSection tableViewTitleForFooter:tableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    AITTableViewSection *viewSection = self.sections[section];
    return [viewSection tableViewFooterView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    AITTableViewSection *viewSection = self.sections[section];
    return [viewSection tableViewHeightForFooter:tableView];
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

- (void)subscribeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowOrHide:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowOrHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unsubscribeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    CGRect keyboardFrame = CGRectZero;
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    keyboardFrame = [self.view convertRect:keyboardFrame fromView:nil];

    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    CGFloat bottomOffset = self.bottomSpace + (CGRectGetHeight(self.view.bounds) - CGRectGetMinY(keyboardFrame));
    NSAssert(self.bottomConstraint, @"Cannot move table view content without constrains.");

    NSIndexPath *activeIndexPath = [self indexPathForFirstAitResponder];
    UITableView *blockTableView = self.tableView;
    
    [UIView animateWithDuration:duration animations:^{
        self.bottomConstraint.constant = bottomOffset;
    }                completion:^(BOOL finished) {
        if (activeIndexPath) {
            [blockTableView scrollToRowAtIndexPath:activeIndexPath
                                  atScrollPosition:UITableViewScrollPositionMiddle
                                          animated:YES];
        }
    }];
}

- (NSIndexPath *)indexPathForFirstAitResponder {
    NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visibleRows) {
        AITTableViewCell *cell = (AITTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSParameterAssert(!cell || [cell isKindOfClass:[AITTableViewCell class]]);
        if ([cell isKindOfClass:[AITTableViewCell class]] && [cell isFirstAitResponder]) {
            return indexPath;
        }
    }
    return nil;
}

- (void)subscribeForValueBecomeFirstAitResponderNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(valueBecomeFirstAitResponderNotification:)
                                                 name:kAITValueBecomeFirstAitResponder
                                               object:nil];
}

- (void)unsubscribeForValueBecomeFirstAitResponderNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kAITValueBecomeFirstAitResponder
                                                  object:nil];
}

- (void)valueBecomeFirstAitResponderNotification:(NSNotification *)notification {
    NSIndexPath *indexPath = [self indexPathForValue:[notification object]];
    if (indexPath) {
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

- (NSIndexPath *)indexPathForValue:(AITResponderValue *)value {
    // FIXME: optimize if need. E.g. setup indexes and use delegate for selection.
    for (NSInteger sectionIndex = 0; sectionIndex < [self.sections count]; ++sectionIndex) {
        AITTableViewSection *section = self.sections[sectionIndex];
        NSArray *allObjects = section.allObjects;
        for (NSInteger rowIndex = 0; rowIndex < [allObjects count]; ++rowIndex) {
            if (allObjects[rowIndex] == value) {
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    return nil;
}

- (void)save {
    
}

- (void)rollback {
    
}


@end

