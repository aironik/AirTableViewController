//
//  AITTableViewController.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewController.h"

#import "AITActionCell.h"
#import "AITChoiceCell.h"
#import "AITDateCell.h"
#import "AITDetailsCell.h"
#import "AITDetailsViewControllerProvider.h"
#import "AITHeaderFooterView.h"
#import "AITPendingOperationCell.h"
#import "AITBoolCell.h"
#import "AITSettings.h"
#import "AITTableViewSection.h"
#import "AITTableViewSection+AITProtected.h"
#import "AITTableViewSectionDelegate.h"
#import "AITTextCell.h"
#import "AITValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation = UITableViewRowAnimationFade;


@interface AITTableViewController ()<AITTableViewSectionDelegate>

@property (nonatomic, assign) BOOL loadedFromNib;

// The popover that represent details view controller for current acctive value (first AitResponder value).
@property (nonatomic, strong) UIPopoverController *detailsPopover;

@property (nonatomic, strong, readonly) NSMutableArray *removedSections;
@property (nonatomic, strong) NSTimer *drainTimer;

@end


#pragma mark - Implementation

@implementation AITTableViewController


@synthesize removedSections = _removedSections;


static AITSettings *staticSettings = nil;


+ (AITSettings *)defaultSettings {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (staticSettings == nil) {
            staticSettings = [[AITSettings alloc] init];
        }
    });
    return staticSettings ;
}

+ (void)setDefaultSettings:(AITSettings *)defaultSettings {
    staticSettings = defaultSettings;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.loadedFromNib = YES;
}

- (void)dealloc {
    [_drainTimer invalidate];
    @autoreleasepool {
        for (AITTableViewCell *cell in [_tableView visibleCells]) {
            [cell willRemove];
        }
        for (AITTableViewSection *section in _sections) {
            [section didDisappear];
        }
    }
}

- (NSMutableArray *)removedSections {
    if (_removedSections == nil) {
        _removedSections = [@[ ] mutableCopy];
    }
    return _removedSections;
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
    [AITChoiceCell setupTableView:self.tableView];
    [AITDateCell setupTableView:self.tableView];
    [AITDetailsCell setupTableView:self.tableView];
    [AITPendingOperationCell setupTableView:self.tableView];
    [AITBoolCell setupTableView:self.tableView];
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

    [self.detailsPopover dismissPopoverAnimated:NO];
    self.detailsPopover = nil;
    
    NSArray *cells = [self.tableView visibleCells];
    for (AITTableViewCell *cell in cells) {
        [cell cellWillDisplay];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // iOS 7 fix. If go back from other view and other view opened while keyboard did shown.
    self.bottomConstraint.constant = self.bottomSpace;

    for (AITTableViewSection *section in self.sections) {
        [section willAppear];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self unsubscribeForValueBecomeFirstAitResponderNotification];
    [self unsubscribeForKeyboardNotifications];

    NSArray *cells = [self.tableView visibleCells];
    for (AITTableViewCell *cell in cells) {
        [cell cellDidEndDisplaying];
    }
    
    for (AITTableViewSection *section in self.sections) {
        [section didDisappear];
    }

    [self drain];
    
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
        for (AITTableViewSection *section in _sections) {
            if (![sections containsObject:section]) {
                [self addSectionForRemove:section];
            }
        }
        
        NSIndexSet *deletingIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_sections count])];
        [self.tableView deleteSections:deletingIndexSet withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
        NSIndexSet *insertingIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [sections count])];
        [self.tableView insertSections:insertingIndexSet withRowAnimation:kAILTableViewSectionDefaultRowAnimation];

        _sections = sections;
        [self updateSectionsResponderChain];
        [self updateSectionsForEditing:self.editing];
    }
}
    
- (void)addSectionForRemove:(AITTableViewSection *)section {
    [section didDisappear];
    [self.removedSections addObject:section];
}

- (void)updateSectionsResponderChain {
    AITTableViewSection *previousSection = nil;
    for (AITTableViewSection *section in self.sections) {
        section.delegate = self;

        [previousSection setNextAitResponder:section];
        previousSection = section;
    }
}

- (void)updateSectionsForEditing:(BOOL)editing {
    const BOOL shown = ([self isViewLoaded] && self.view.superview != nil);
    if (shown) {
        [self.tableView beginUpdates];
    }
    [self.sections enumerateObjectsUsingBlock:^(AITTableViewSection *section, NSUInteger index, BOOL *stop) {
        [section tableView:self.tableView setEditing:editing];
    }];

    if (shown) {
        [self.tableView endUpdates];
    }
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
    [tableView beginUpdates];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AITTableViewSection *viewSection = self.sections[indexPath.section];
    [viewSection tableView:tableView didSelectRow:indexPath.row];
    
    [tableView endUpdates];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(AITTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: fix me
    if ([cell isKindOfClass:[AITTableViewCell class]]) {
        [cell cellWillDisplay];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(AITTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: fix me
    if ([cell isKindOfClass:[AITTableViewCell class]]) {
        [cell cellDidEndDisplaying];
    }
}

- (void)subscribeForKeyboardNotifications {
    if (!self.ignoreKeyboardShrink) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowOrHide:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowOrHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
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
    NSIndexPath *indexPath = [self visibleIndexPathForValue:[notification object]];
    if (indexPath) {
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

- (NSIndexPath *)visibleIndexPathForValue:(AITValue *)value {
    // FIXME: optimize if need. E.g. setup indexes and use delegate for selection.
    for (NSInteger sectionIndex = 0; sectionIndex < [self.sections count]; ++sectionIndex) {
        AITTableViewSection *section = self.sections[sectionIndex];
        NSInteger rowIndex = [section visibleRowForValue:value];
        if (rowIndex != NSNotFound) {
            return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
        }
    }
    return nil;
}

#pragma mark - AITTableViewSectionDelegate protocol implementation

- (void)section:(AITTableViewSection *)section insertCellAtRow:(NSInteger)row {
    NSInteger sectionIndex = [self.sections indexOfObject:section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
}

- (void)section:(AITTableViewSection *)section reloadCellAtRow:(NSInteger)row {
    NSInteger sectionIndex = [self.sections indexOfObject:section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
    [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
}

- (void)section:(AITTableViewSection *)section deleteCellAtRow:(NSInteger)row {
    NSInteger sectionIndex = [self.sections indexOfObject:section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
    [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
}

- (void)section:(AITTableViewSection *)section scrollToRow:(NSInteger)row {
    NSInteger sectionIndex = [self.sections indexOfObject:section];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionNone
                                  animated:YES];
}

- (void)reloadSection:(AITTableViewSection *)section {
    NSInteger sectionIndex = [self.sections indexOfObject:section];
    if (sectionIndex != NSNotFound) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
        
        NSArray *removedValues = [section valueForRemoved];
        for (int i = 0; i < removedValues.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:sectionIndex];
            AITTableViewCell *cell = (AITTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell cellDidEndDisplaying];
        }
        
        [self.tableView reloadSections:indexSet withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
        
        [self scheduleDrain];
    }
}

- (void)section:(AITTableViewSection *)section valueDidBecomeFirstAitResponder:(AITValue *)value {
    switch ([[value detailsViewControllerProvider] presentationStyle]) {
        case AITDetailsPresentationStyleCell:
            [section showDetailsCellForValue:value];
            break;

        case AITDetailsPresentationStylePopover:
            [self presentPopoverForSection:section value:value];
            break;

        case AITDetailsPresentationStyleModal:
            [self presentModalControllerForSection:section value:value];
            break;

        case AITDetailsPresentationStylePushNavigation:
            [self pushControllerForSection:section value:value];
            break;

        case AITDetailsPresentationStyleCustom:
            NSParameterAssert([[value detailsViewControllerProvider] respondsToSelector:
                                      @selector(presentDetailsViewControllerForValue:fromViewController:)]);
            [[value detailsViewControllerProvider] presentDetailsViewControllerForValue:value fromViewController:self];
            break;

        default:
            NSAssert(NO, @"Unknown Unknown details presentation style.");
        case AITDetailsPresentationStyleNone:
            break;
    }
}

- (void)section:(AITTableViewSection *)section valueDidResignFirstAitResponder:(AITValue *)value {
    [section hideDetailsCellForValue:value];
    [self.detailsPopover dismissPopoverAnimated:YES];
    self.detailsPopover = nil;
    // Should we dismiss modal/pushed details?
}

- (void)presentPopoverForSection:(AITTableViewSection *)section value:(AITValue *)value {
    NSInteger sectionIndex = [self.sections indexOfObject:section];
    NSInteger row = [section visibleRowForValue:value];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sectionIndex];

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        // FIXME:
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionNone
                                      animated:NO];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
    }
    CGRect cellRect = [self.view convertRect:cell.bounds fromView:cell];

    UIViewController *detailsViewController = [value.detailsViewControllerProvider detailsViewControllerForValue:value];
    self.detailsPopover = [[UIPopoverController alloc] initWithContentViewController:detailsViewController];
    [self.detailsPopover presentPopoverFromRect:cellRect
                                         inView:self.view
                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                       animated:YES];
}

- (void)presentModalControllerForSection:(AITTableViewSection *)section value:(AITValue *)value {
    UIViewController *detailsViewController = [value.detailsViewControllerProvider detailsViewControllerForValue:value];
    AITSettings *settings = [[self class] defaultSettings];
    Class navControllerClass = settings.navigationControllerClass;
    UINavigationController *navigationController = [[navControllerClass alloc] initWithRootViewController:detailsViewController];

    UIBarButtonItem *closeItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                          target:self
                                                          action:@selector(closeDetailsController:)];
    detailsViewController.navigationItem.leftBarButtonItem = closeItem;

    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)pushControllerForSection:(AITTableViewSection *)section value:(AITValue *)value {
    if (self.navigationController) {
        UIViewController *detailsViewController = [value.detailsViewControllerProvider detailsViewControllerForValue:value];
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
    else {
        [self presentModalControllerForSection:section value:value];
    }
}

- (IBAction)closeDetailsController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Drain removed values workflow

- (void)scheduleDrain {
    [self.drainTimer invalidate];
    self.drainTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                       target:self
                                                     selector:@selector(drain)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)drain {
    for (AITTableViewSection *section in self.sections) {
        [section drainRemovedValues];
    }
    [self.removedSections removeAllObjects];
}


#pragma mark -

- (void)save {
    
}

- (void)rollback {
    
}


@end

