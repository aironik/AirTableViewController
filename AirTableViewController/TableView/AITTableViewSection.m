//
//  AITTableViewSection.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewSection.h"
#import "AITTableViewSection+AITProtected.h"

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
@property (nonatomic, weak) AITValue *valueFirstAitResponder;
@property (nonatomic, assign, readonly) NSInteger valueFirstAitResponderIndex;
@property (nonatomic, copy, readonly) NSString *valueFirstAitResponderDetailsCellIdentifier;

- (NSArray *)currentObjects;

@end


#pragma mark - Implementation

@implementation AITTableViewSection

@synthesize headerViewIdentifier = _headerViewIdentifier;
@synthesize footerViewIdentifier = _footerViewIdentifier;
@synthesize valueFirstAitResponder = _valueFirstAitResponder;
@synthesize valueFirstAitResponderIndex = _valueFirstAitResponderIndex;


- (void)setAllObjects:(NSArray *)allObjects {
    if (_allObjects != allObjects) {
        self.valueFirstAitResponder = nil;

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

    [self updateValueFirstAitResponderIndex];
    [self updateObjectsResponderChain];
}

- (void)updateValueFirstAitResponderIndex {
    if (self.valueFirstAitResponder && [[self valueFirstAitResponderDetailsCellIdentifier] length]) {
        _valueFirstAitResponderIndex = [[self currentObjects] indexOfObject:self.valueFirstAitResponder];
    }
    else {
        _valueFirstAitResponderIndex = NSNotFound;
    }
}

- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing {
    [self tableView:tableView changes:^BOOL() {
        const BOOL changed = ((editing && !self.editing) || (!editing && self.editing));
        self.editing = editing;
        return changed;
    }];
}

- (void)tableView:(UITableView *)tableView changes:(AITTableViewSectionChanges)changes {
    NSParameterAssert(changes);

    BOOL didChange = NO;
    NSArray *previousObjects = [self currentObjects];
    if (changes) {
        didChange = changes();
        [self updateFilledObjects];
    }
    if (didChange) {
        [self tableView:tableView mergeFromPreviousObjects:previousObjects];
    }
}

- (void)tableView:(UITableView *)tableView mergeFromPreviousObjects:(NSArray *)previousObjects {
    [self.delegate reloadSection:self];
}

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

- (void)setHeaderViewIdentifier:(NSString *)headerViewIdentifier {
    if (![_headerViewIdentifier isEqualToString:headerViewIdentifier]) {
        _headerViewIdentifier = [headerViewIdentifier copy];
        self.headerView = nil;
    }
}

- (NSString *)headerViewIdentifier {
    if (![_headerViewIdentifier length]) {
        _headerViewIdentifier = [kAITHeaderFooterViewLeftAlignedHeaderIdentifier copy];
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
        _footerViewIdentifier = [kAITHeaderFooterViewCenterAlignedFooterIdentifier copy];
    }
    return _footerViewIdentifier;
}

- (NSString *)tableViewTitleForFooter:(UITableView *)tableView {
    if ([self tableViewNumberOfRows:tableView]) {
        return self.footer;
    }
    return nil;
}

// block invokes only if value found.
- (void)findValueIndexForRow:(NSInteger)row withFoundBlock:(void(^)(NSInteger valueIndex, BOOL isDetails))foundBlock {
    NSInteger valueIndex = row;
    BOOL isDetails = NO;

    NSInteger detailsIndex = [self valueFirstAitResponderIndex];
    if (detailsIndex != NSNotFound && detailsIndex < valueIndex) {
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
    if ([self.valueFirstAitResponderDetailsCellIdentifier length]) {
        numberOfDetailsRowsForFirstAitResponder = 1;
    }
    return [[self currentObjects] count] + numberOfDetailsRowsForFirstAitResponder;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row {
    __block AITTableViewCell *result = nil;

    NSArray *currentObjects = [self currentObjects];

    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isDetails) {
        AITValue *value = currentObjects[valueIndex];
        NSString *cellIdentifier = (isDetails
                                    ? [value detailsCellIdentifier]
                                    : [value cellIdentifier]);
        result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        result.value = value;
    }];

    result.editing = self.editing;
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSInteger)row {
    __block CGFloat result = 0.;
    
    NSArray *currentObjects = [self currentObjects];

    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isDetails) {
        AITValue *value = currentObjects[valueIndex];
        NSString *cellIdentifier = (isDetails
                                    ? [value detailsCellIdentifier]
                                    : [value cellIdentifier]);
        Class cellClass = NSClassFromString(cellIdentifier);
        result = [cellClass prefferedHeightForValue:value];
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
    if (self.valueFirstAitResponder) {
        return [self.valueFirstAitResponder canResignFirstAitResponder];
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
    [self.valueFirstAitResponder resignFirstAitResponder];
}

- (BOOL)isFirstAitResponder {
    NSParameterAssert((self.valueFirstAitResponder == nil) == ![self.valueFirstAitResponder isFirstAitResponder]);
    return [self.valueFirstAitResponder isFirstAitResponder];
}

#pragma mark - AITValueDelegate protocol implementation


- (void)valueDidBecomeFirstAitResponder:(AITValue *)value {
    self.valueFirstAitResponder = value;
}

- (void)valueDidResignFirstAitResponder:(AITValue *)value {
    if (self.valueFirstAitResponder == value) {
        // value can send resign message after new value become. So we check it.
        self.valueFirstAitResponder = nil;
    }
}

- (void)setValueFirstAitResponder:(AITValue *)valueFirstAitResponder {
    if (_valueFirstAitResponder != valueFirstAitResponder) {
        if ([self.valueFirstAitResponderDetailsCellIdentifier length]) {
            NSParameterAssert(self.valueFirstAitResponderIndex != NSNotFound);
            _valueFirstAitResponder = nil;
            NSInteger removingRow = self.valueFirstAitResponderIndex + 1;
            [self updateValueFirstAitResponderIndex];
            [self.delegate section:self deleteCellAtRow:removingRow];
        }
             
        _valueFirstAitResponder = valueFirstAitResponder;
        [self updateValueFirstAitResponderIndex];

        if ([self.valueFirstAitResponderDetailsCellIdentifier length]) {
            [self.delegate section:self insertCellAtRow:self.valueFirstAitResponderIndex + 1];
        }
    }
}

- (NSString *)valueFirstAitResponderDetailsCellIdentifier {
    return [self.valueFirstAitResponder detailsCellIdentifier];
}


// TODO: methods for remove (below).

- (void)value:(AITValue *)value presentAdditionalaDataInCellWithIdentifier:(NSString *)cellIdentifier {
//    NSInteger valueIndex = [self.allObjects indexOfObject:value];
//    if (cellIdentifier && valueIndex != NSNotFound) {
//        NSNumber *valueIndexNumber = @(valueIndex);
//        BOOL addingCell = (self.additionalDataCellIdentifiers[valueIndexNumber] == nil);
//        self.additionalDataCellIdentifiers[valueIndexNumber] = cellIdentifier;
//        NSInteger valueFilledIndex = [self.filledObjects indexOfObject:value];
//        if (valueFilledIndex != NSNotFound) {
//            self.additionalDataFilledCellIdentifiers[@(valueFilledIndex)] = cellIdentifier;
//        }
//
//        [self findRowForValueIndex:valueIndex withFoundBlock:^(NSInteger row) {
//            if (addingCell) {
//                [self.delegate section:self insertCellAtRow:row + 1];
//            }
//            else {
//                [self.delegate section:self reloadCellAtRow:row + 1];
//            }
//        }];
//    }
}

- (void)value:(AITValue *)value dismissAdditionalaDataInCellWithIdentifier:(NSString *)cellIdentifier {
//    NSInteger valueIndex = [self.allObjects indexOfObject:value];
//    if (cellIdentifier && valueIndex != NSNotFound) {
//        NSNumber *valueIndexNumber = @(valueIndex);
//        NSAssert([cellIdentifier isEqualToString:self.additionalDataCellIdentifiers[valueIndexNumber]], @"Impropper additional cell identifier for dismiss.");
//        BOOL removingCell = (self.additionalDataCellIdentifiers[valueIndexNumber] != nil);
//        if (removingCell) {
//            NSInteger valueFilledIndex = [self.filledObjects indexOfObject:value];
//
//            [self findRowForValueIndex:valueIndex withFoundBlock:^(NSInteger row) {
//                [self.additionalDataCellIdentifiers removeObjectForKey:valueIndexNumber];
//                if (valueFilledIndex != NSNotFound) {
//                    [self.additionalDataFilledCellIdentifiers removeObjectForKey:@(valueFilledIndex)];
//                }
//                [self.delegate section:self deleteCellAtRow:row + 1];
//            }];
//        }
//    }
}

- (void)valueNeedShow:(AITValue *)value {
//    NSInteger valueIndex = [[self currentObjects] indexOfObject:value];
//    [self.delegate section:self scrollToRow:valueIndex];
}

- (UIPopoverController *)value:(AITValue *)value showPopoverWithController:(UIViewController *)viewController {
//    NSInteger valueIndex = [[self currentObjects] indexOfObject:value];
//    return [self.delegate section:self showPopoverWithController:viewController fromRow:valueIndex];
    return nil;
}

- (void)value:(AITValue *)value showDetailsController:(UIViewController *)viewController {
//    return [self.delegate section:self showDetailsController:viewController];
}

@end
