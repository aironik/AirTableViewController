//
//  AITTableViewSection.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewSection.h"
#import "AITTableViewSection+AITProtected.h"

#import "AITDetailsViewControllerProvider.h"
#import "AITHeaderFooterView.h"
#import "AITTableViewCell.h"
#import "AITTableViewSectionDelegate.h"
#import "AITTextCell.h"
#import "AITTextValue.h"
#import "AITValue.h"
#import "AITValueDelegate.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTableViewSection ()<AITValueDelegate>

@property (nonatomic, strong) NSArray *filledObjects;
@property (nonatomic, strong) AITHeaderFooterView *headerView;
@property (nonatomic, strong) AITHeaderFooterView *footerView;

// The value that is current first AITResponder in the section. If nil no first AIT responder now.
@property (nonatomic, weak) AITValue *valueWithDetails;
@property (nonatomic, strong, readonly) UIViewController *detailsViewController;
@property (nonatomic, assign, readonly) NSInteger valueWithDetailsIndex;

- (NSArray *)currentObjects;

@end


#pragma mark - Implementation

@implementation AITTableViewSection

@synthesize headerViewIdentifier = _headerViewIdentifier;
@synthesize footerViewIdentifier = _footerViewIdentifier;
@synthesize valueWithDetails = _valueWithDetails;
@synthesize detailsViewController = _detailsViewController;
@synthesize valueWithDetailsIndex = _valueWithDetailsIndex;


- (instancetype)init {
    if (self = [super init]) {
        _valueWithDetailsIndex = NSNotFound;
    }
    return self;
}

- (void)willRemove {
    for (AITValue *value in self.allObjects) {
        [value willRemove];
    }
}

- (void)setAllObjects:(NSArray *)allObjects {
    if (_allObjects != allObjects) {
        self.valueWithDetails = nil;

        _allObjects = [allObjects copy];

        [self updateFilledObjects];
    }
}

- (void)updateFilledObjects {
    NSMutableArray *filledObjects = [NSMutableArray array];

    [self.allObjects enumerateObjectsUsingBlock:^(AITValue *value, NSUInteger idx, BOOL *stop) {
        if (!value.empty) {
            [filledObjects addObject:value];
        }
    }];
    self.filledObjects = [filledObjects copy];

    [self updateValueWithDetailsIndex];
    [self updateObjectsResponderChain];
}

- (void)updateValueWithDetailsIndex {
    if (self.valueWithDetails) {
        _valueWithDetailsIndex = [[self currentObjects] indexOfObject:self.valueWithDetails];
    }
    else {
        _valueWithDetailsIndex = NSNotFound;
    }
}

- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing {
    BOOL didChange = ((editing && !self.editing) || (!editing && self.editing));
    self.editing = editing;
    [self updateFilledObjects];
    if (didChange) {
        [self.delegate reloadSection:self];
    }
}


#pragma mark - Header Footer

- (NSString *)tableViewTitleForHeader:(UITableView *)tableView {
    if ([self tableViewNumberOfRows:tableView]) {
        return self.header;
    }
    return nil;
}

- (void)setHeader:(NSString *)header {
    if (![_header isEqualToString:header]) {
        _header = [header copy];
        self.headerView = nil;
    }
}

static NSString *_defaultHeaderViewIdentifier = nil;
static NSString *_defaultFooterViewIdentifier = nil;

+ (void)setDefaultHeaderViewIdentifier:(NSString *)defaultHeaderViewIdentifier {
    _defaultHeaderViewIdentifier = [defaultHeaderViewIdentifier copy];
}

+ (NSString *)defaultHeaderViewIdentifier {
    if (_defaultHeaderViewIdentifier == nil) {
        _defaultHeaderViewIdentifier = [kAITHeaderFooterViewLeftAlignedHeaderIdentifier copy];
    }
    return _defaultHeaderViewIdentifier;
}

+ (void)setDefaultFooterViewIdentifier:(NSString *)defaultFooterViewIdentifier {
    _defaultFooterViewIdentifier = [defaultFooterViewIdentifier copy];
}

+ (NSString *)defaultFooterViewIdentifier {
    if (_defaultFooterViewIdentifier == nil) {
        _defaultFooterViewIdentifier = [kAITHeaderFooterViewCenterAlignedFooterIdentifier copy];
    }
    return _defaultFooterViewIdentifier;
}

- (void)setHeaderViewIdentifier:(NSString *)headerViewIdentifier {
    if (![_headerViewIdentifier isEqualToString:headerViewIdentifier]) {
        _headerViewIdentifier = [headerViewIdentifier copy];
        self.headerView = nil;
    }
}

- (NSString *)headerViewIdentifier {
    if (![_headerViewIdentifier length]) {
        _headerViewIdentifier = [[[self class] defaultHeaderViewIdentifier] copy];
    }
    return _headerViewIdentifier;
}

- (void)setFooter:(NSString *)footer {
    if (![_footer isEqualToString:footer]) {
        _footer = [footer copy];
        self.footerView = nil;
    }
}

- (void)setFooterViewIdentifier:(NSString *)footerViewIdentifier {
    if (![_footerViewIdentifier isEqualToString:footerViewIdentifier]) {
        _footerViewIdentifier = [footerViewIdentifier copy];
        self.footerView = nil;
    }
}

- (NSString *)footerViewIdentifier {
    if (![_footerViewIdentifier length]) {
        _footerViewIdentifier = [[[self class] defaultFooterViewIdentifier] copy];
    }
    return _footerViewIdentifier;
}

- (NSString *)tableViewTitleForFooter:(UITableView *)tableView {
    if ([self tableViewNumberOfRows:tableView]) {
        return self.footer;
    }
    return nil;
}

- (AITHeaderFooterView *)tableViewHeaderView:(UITableView *)tableView {
    if (!self.headerView && [self.header length]) {
        self.headerView = [AITHeaderFooterView headerFooterViewWithIdentifier:self.headerViewIdentifier];
        self.headerView.label.text = self.header;
    }
    return self.headerView;
}

- (CGFloat)tableViewHeightForHeader:(UITableView *)tableView {
    return [[self tableViewHeaderView:tableView] heightForTableView:tableView];
}

- (AITHeaderFooterView *)tableViewFooterView:(UITableView *)tableView {
    if (!self.footerView && [self.footer length]) {
        self.footerView = [AITHeaderFooterView headerFooterViewWithIdentifier:self.footerViewIdentifier];
        self.footerView.label.text = self.footer;
    }
    return self.footerView;
}

- (CGFloat)tableViewHeightForFooter:(UITableView *)tableView {
    return [[self tableViewFooterView:tableView] heightForTableView:tableView];
}


#pragma mark - rows

- (NSInteger)rowForValue:(AITValue *)value {
    NSInteger result = [self.allObjects indexOfObject:value];
    NSInteger detailsIndex = [self valueWithDetailsIndex];
    if (result != NSNotFound && result > detailsIndex) {
        ++result;
    }
    return result;
}

// block invokes only if value found.
- (void)findValueIndexForRow:(NSInteger)row withFoundBlock:(void(^)(NSInteger valueIndex, BOOL isDetails))foundBlock {
    NSInteger valueIndex = row;
    BOOL isDetails = NO;

    NSInteger detailsIndex = [self valueWithDetailsIndex];
    if (detailsIndex != NSNotFound && detailsIndex < valueIndex) {
        NSParameterAssert(self.detailsViewController);
        --valueIndex;
        isDetails = (detailsIndex + 1 == row);
    }
    NSParameterAssert(valueIndex == NSNotFound || valueIndex < [[self currentObjects] count]);
    if (valueIndex != NSNotFound && valueIndex < [[self currentObjects] count] && foundBlock) {
        foundBlock(valueIndex, isDetails);
    }
}

- (NSArray *)currentObjects {
    return (self.editing ? self.allObjects : self.filledObjects);
}

- (NSInteger)tableViewNumberOfRows:(UITableView *)tableView {
    NSInteger numberOfDetailsRowsForFirstAitResponder = 0;
    if (self.detailsViewController) {
        numberOfDetailsRowsForFirstAitResponder = 1;
    }
    return [[self currentObjects] count] + numberOfDetailsRowsForFirstAitResponder;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row {
    __block UITableViewCell *result = nil;

    NSArray *currentObjects = [self currentObjects];

    __weak typeof(self) weakSelf = self;
    const BOOL isFirst = (row == 0);
    const BOOL isLast = (row >= [self tableViewNumberOfRows:tableView] - 1);
    NSUInteger cellPosition = ((isFirst ? AITTableViewCellPositionTop : 0)
                               | (isLast ? AITTableViewCellPositionBottom : 0));
    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isDetails) {
        AITValue *value = currentObjects[valueIndex];
        if (isDetails) {
            result = [weakSelf tableViewDetailsCell:tableView];
        }
        else {
            AITTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[value cellIdentifier]];
            cell.value = value;
            cell.editing = self.editing;
            cell.position = cellPosition;
            result = cell;
        }
    }];
    return result;
}

- (UITableViewCell *)tableViewDetailsCell:(UITableView *)tableView {
    static NSString *const detailsCellIdentifier = @"DetailsCellIdentifier";
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:detailsCellIdentifier];
    if (!result) {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailsCellIdentifier];
    }
    for (UIView *subview in [result.contentView subviews]) {
        [subview removeFromSuperview];
    }
    UIView *contentView = self.detailsViewController.view;
    UIView *containerView = result.contentView;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    contentView.frame = containerView.bounds;
    [containerView addSubview:contentView];

    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSInteger)row {
    __block CGFloat result = 0.;
    
    NSArray *currentObjects = [self currentObjects];

    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isDetails) {
        if (isDetails) {
            result = [self.detailsViewController.view sizeThatFits:tableView.frame.size].height;
        }
        else {
            AITValue *value = currentObjects[valueIndex];
            Class cellClass = NSClassFromString([value cellIdentifier]);
            result = [cellClass preferredHeightForValue:value];
        }
    }];
    return (result > 0. ? result : [tableView rowHeight]);
}

- (void)tableView:(UITableView *)tableView didSelectRow:(NSInteger)row {
    NSArray *currentObjects = [self currentObjects];
    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isDetails) {
        if (!isDetails) {
            id<AITResponder> value = currentObjects[valueIndex];
            if ([value canBecomeFirstAitResponder]) {
                [value becomeFirstAitResponder];
            }
        }
    }];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRow:(NSInteger)row {

}

- (void)tableView:(UITableView *)tableView didEndEditingRow:(NSInteger)row {

}

- (BOOL)tableView:(UITableView *)tableView canEditRow:(NSInteger)row {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRow:(NSInteger)row {
    return UITableViewCellEditingStyleNone;
}


#pragma mark - AIT responder chain and AITResponder protocol implementation

- (void)setNextAitResponder:(id<AITResponder>)nextAitResponder {
    _nextAitResponder = nextAitResponder;

    [self updateLastObjectResponderChain];
}

- (void)updateObjectsResponderChain {
    AITValue *previousResponder = nil;
    for (AITValue *responder in [self currentObjects]) {
        [previousResponder setNextAitResponder:responder];
        previousResponder = responder;

        responder.delegate = self;
    }
    [self updateLastObjectResponderChain];
}

- (void)updateLastObjectResponderChain {
    id<AITResponder> lastValue = self.allObjects.lastObject;
    [lastValue setNextAitResponder:self.nextAitResponder];
}

- (BOOL)canBecomeFirstAitResponder {
    for (id<AITResponder>value in self.allObjects) {
        if ([value canBecomeFirstAitResponder]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canResignFirstAitResponder {
    if (self.valueWithDetails) {
        return [self.valueWithDetails canResignFirstAitResponder];
    }
    return YES;
}

- (void)becomeFirstAitResponder {
    for (id<AITResponder>value in self.allObjects) {
        if ([value canBecomeFirstAitResponder]) {
            [value becomeFirstAitResponder];
            return;
        }
    }
    [self.nextAitResponder becomeFirstAitResponder];
}

- (void)resignFirstAitResponder {
    [self.valueWithDetails resignFirstAitResponder];
}

- (BOOL)isFirstAitResponder {
    NSParameterAssert((self.valueWithDetails == nil) == ![self.valueWithDetails isFirstAitResponder]);
    return [self.valueWithDetails isFirstAitResponder];
}

#pragma mark - AITValueDelegate protocol implementation


- (void)valueDidBecomeFirstAitResponder:(AITValue *)value {
    [self.delegate section:self valueDidBecomeFirstAitResponder:value];
}

- (void)valueDidResignFirstAitResponder:(AITValue *)value {
    [self.delegate section:self valueDidResignFirstAitResponder:value];
}

- (void)showDetailsCellForValue:(AITValue *)value {
    NSParameterAssert([value.detailsViewControllerProvider presentationStyle] != AITDetailsPresentationStyleNone);
    if ([value.detailsViewControllerProvider presentationStyle] != AITDetailsPresentationStyleNone) {
        self.valueWithDetails = value;
    }
    else {
        self.valueWithDetails = nil;
    }
}

- (void)hideDetailsCellForValue:(AITValue *)value {
    if (self.valueWithDetails == value) {
        // value can send resign message after new value become. So we check it.
        self.valueWithDetails = nil;
    }
}

- (void)setValueWithDetails:(AITValue *)valueWithDetails {
    if (_valueWithDetails != valueWithDetails) {
        if (self.valueWithDetailsIndex != NSNotFound) {
            _valueWithDetails = nil;
            NSInteger removingRow = self.valueWithDetailsIndex + 1;
            [self updateValueWithDetailsIndex];
            _detailsViewController = nil;
            [self.delegate section:self deleteCellAtRow:removingRow];
            if (removingRow > 0) {
                [self.delegate section:self reloadCellAtRow:removingRow - 1];
            }
        }
             
        _valueWithDetails = valueWithDetails;
        [self updateValueWithDetailsIndex];
        _detailsViewController = [valueWithDetails.detailsViewControllerProvider detailsViewControllerForValue:_valueWithDetails];

        if (_detailsViewController) {
            [self.delegate section:self insertCellAtRow:self.valueWithDetailsIndex + 1];
            [self.delegate section:self reloadCellAtRow:self.valueWithDetailsIndex];
        }
    }
}

- (void)valueNeedShow:(AITValue *)value {
    NSInteger valueIndex = [[self currentObjects] indexOfObject:value];
    [self.delegate section:self scrollToRow:valueIndex];
}

@end
