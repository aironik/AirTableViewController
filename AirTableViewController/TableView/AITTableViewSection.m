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


const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation = UITableViewRowAnimationFade;


@interface AITTableViewSection ()<AITValueDelegate>

@property (nonatomic, strong) NSArray *filledObjects;
@property (nonatomic, strong) AITHeaderFooterView *headerView;
@property (nonatomic, strong) AITHeaderFooterView *footerView;

// The dictionary that contains cell identifiers for values that has requested additional cells for show additional data.
// key => index of value in the allObjects array
// value => cell identifier for additional data
@property (nonatomic, strong, readonly) NSMutableDictionary *additionalDataCellIdentifiers;
// The dictionary that contains cell identifiers for values that has requested additional cells for show additional data.
// key => index of value in the filledObjects array
// value => cell identifier for additional data
@property (nonatomic, strong, readonly) NSMutableDictionary *additionalDataFilledCellIdentifiers;

- (NSArray *)currentObjects;

@end


#pragma mark - Implementation

@implementation AITTableViewSection

@synthesize headerViewIdentifier = _headerViewIdentifier;
@synthesize footerViewIdentifier = _footerViewIdentifier;
@synthesize additionalDataCellIdentifiers = _additionalDataCellIdentifiers;
@synthesize additionalDataFilledCellIdentifiers = _additionalDataFilledCellIdentifiers;


- (NSMutableDictionary *)additionalDataCellIdentifiers {
    if (!_additionalDataCellIdentifiers) {
        _additionalDataCellIdentifiers = [NSMutableDictionary dictionary];
    }
    return _additionalDataCellIdentifiers;
}

- (NSMutableDictionary *)additionalDataFilledCellIdentifiers {
    if (!_additionalDataFilledCellIdentifiers) {
        _additionalDataFilledCellIdentifiers = [NSMutableDictionary dictionary];
    }
    return _additionalDataFilledCellIdentifiers;
}

- (void)setAllObjects:(NSArray *)allObjects {
    if (_allObjects != allObjects) {
        [self.additionalDataCellIdentifiers removeAllObjects];
        [self.additionalDataFilledCellIdentifiers removeAllObjects];

        _allObjects = [allObjects copy];

        [self updateObjectsResponderChain];
        [self updateFilledObjects];
    }
}

- (void)updateFilledObjects {
    NSMutableArray *filledObjects = [NSMutableArray array];
    [self.additionalDataFilledCellIdentifiers removeAllObjects];

    [self.allObjects enumerateObjectsUsingBlock:^(id<AITValue> value, NSUInteger idx, BOOL *stop) {
        if (![value isEmpty]) {
            NSInteger filledObjectIndex = [filledObjects count];
            NSString *cellIdentifier = self.additionalDataCellIdentifiers[@(idx)];
            if (cellIdentifier) {
                self.additionalDataFilledCellIdentifiers[@(filledObjectIndex)] = cellIdentifier;
            }
            [filledObjects addObject:value];
        }
    }];
    self.filledObjects = [filledObjects copy];
}

- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing currentSectionIndex:(NSInteger)index {
    [self tableView:tableView currentSectionIndex:index changes:^BOOL() {
        const BOOL changed = ((editing && !self.editing) || (!editing && self.editing));
        self.editing = editing;
        return changed;
    }];
}

- (void)tableView:(UITableView *)tableView currentSectionIndex:(NSInteger)sectionIndex changes:(AITTableViewSectionChanges)changes {
    NSParameterAssert(changes);

    BOOL didChange = NO;
    NSArray *previousObjects = [self currentObjects];
    if (changes) {
        didChange = changes();
        [self updateFilledObjects];
    }
    if (didChange) {
        [self tableView:tableView currentSectionIndex:sectionIndex mergeFromPreviousObjects:previousObjects];
    }
}

- (void)tableView:(UITableView *)tableView currentSectionIndex:(NSInteger)sectionIndex mergeFromPreviousObjects:(NSArray *)previousObjects {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    [tableView reloadSections:indexSet withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
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
- (void)findValueIndexForRow:(NSInteger)row withFoundBlock:(void(^)(NSInteger valueIndex, BOOL isAdditional))foundBlock {
    NSDictionary *currentAdditionalRows = [self currentAdditionalDataCellIdentifiers];

    NSInteger valueIdx = 0;
    NSInteger additionalCount = 0;
    BOOL lastAdditional = NO;
    for (valueIdx = 0; valueIdx + additionalCount <= row; ++valueIdx) {
        if (currentAdditionalRows[@(valueIdx)]) {
            ++additionalCount;
            lastAdditional = YES;
        }
        else {
            lastAdditional = NO;
        }
    }
    if (valueIdx > 0 && valueIdx <= [[self currentObjects] count]) {
        --valueIdx;
        BOOL isAdditional = (lastAdditional && valueIdx + additionalCount == row);
        foundBlock(valueIdx, isAdditional);
    }
}

- (void)findRowForValueIndex:(NSInteger)valueIndex withFoundBlock:(void(^)(NSInteger row))foundBlock {
    NSDictionary *currentAdditionalRows = [self currentAdditionalDataCellIdentifiers];

    NSInteger additionalCount = 0;
    for (NSInteger idx = 0; idx < valueIndex; ++idx) {
        if (currentAdditionalRows[@(idx)]) {
            ++additionalCount;
        }
    }
    foundBlock(additionalCount + valueIndex);
}

- (id<AITValue>)valueAtRow:(NSInteger)row {
    NSArray *currentObjects = [self currentObjects];
    __block id<AITValue> result = nil;
    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isAdditional) {
        result = currentObjects[valueIndex];
    }];
    return result;
}

- (NSArray *)currentObjects {
    return (self.editing ? self.allObjects : self.filledObjects);
}

- (NSDictionary *)currentAdditionalDataCellIdentifiers {
    return (self.editing ? self.additionalDataCellIdentifiers : self.additionalDataFilledCellIdentifiers);
}

- (NSInteger)tableViewNumberOfRows:(UITableView *)tableView {
    return [[self currentObjects] count] + [self.currentAdditionalDataCellIdentifiers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row {
    __block AITTableViewCell *result = nil;

    NSDictionary *currentAdditionalRows = [self currentAdditionalDataCellIdentifiers];
    NSArray *currentObjects = [self currentObjects];

    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isAdditional) {
        id<AITValue> value = currentObjects[valueIndex];
        NSString *cellIdentifier = (isAdditional ? currentAdditionalRows[@(valueIndex)] : [[value class] cellIdentifier]);
        result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        result.value = value;
    }];

    result.editing = self.editing;
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSInteger)row {
    __block CGFloat result = 0.;
    
    NSDictionary *currentAdditionalRows = [self currentAdditionalDataCellIdentifiers];
    NSArray *currentObjects = [self currentObjects];

    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isAdditional) {
        NSObject<AITValue> *value = currentObjects[valueIndex];
        NSString *cellIdentifier = (isAdditional ? currentAdditionalRows[@(valueIndex)] : [[value class] cellIdentifier]);
        Class cellClass = NSClassFromString(cellIdentifier);
        result = [cellClass prefferedHeightForValue:value];
    }];
    return (result > 0. ? result : [tableView rowHeight]);
}

- (void)tableView:(UITableView *)tableView didDeselectRow:(NSInteger)row {
    NSArray *currentObjects = [self currentObjects];
    [self findValueIndexForRow:row withFoundBlock:^(NSInteger valueIndex, BOOL isAdditional) {
        if (!isAdditional) {
            id<AITValue> value = currentObjects[valueIndex];
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
    AITResponderValue *previousResponder = nil;
    for (AITResponderValue *responder in self.allObjects) {
        [previousResponder setNextAitResponder:responder];
        previousResponder = responder;

        responder.delegate = self;
    }
    [self updateLastObjectResponderChain];
}

- (void)updateLastObjectResponderChain {
    id<AITValue> lastValue = self.allObjects.lastObject;
    [lastValue setNextAitResponder:self.nextAitResponder];
}

- (BOOL)canBecomeFirstAitResponder {
    for (id<AITValue>value in self.allObjects) {
        if ([value canBecomeFirstAitResponder]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canResignFirstAitResponder {
    for (id<AITValue>value in self.allObjects) {
        if ([value isFirstAitResponder]) {
            return [value canResignFirstAitResponder];
        }
    }
    return YES;
}

- (void)becomeFirstAitResponder {
    for (id<AITValue>value in self.allObjects) {
        if ([value canBecomeFirstAitResponder]) {
            [value becomeFirstAitResponder];
            return;
        }
    }
    [self.nextAitResponder becomeFirstAitResponder];
}

- (void)resignFirstAitResponder {
    for (id<AITValue>value in self.allObjects) {
        if ([value isFirstAitResponder]) {
            [value resignFirstAitResponder];
            return;
        }
    }
}

- (BOOL)isFirstAitResponder {
    for (id<AITValue>value in self.allObjects) {
        if ([value isFirstAitResponder]) {
            return [value isFirstAitResponder];
        }
    }
    return NO;
}

#pragma mark - AITValueDelegate protocol implementation

- (void)value:(id<AITValue>)value presentAdditionalaDataInCellWithIdentifier:(NSString *)cellIdentifier {
    NSInteger valueIndex = [self.allObjects indexOfObject:value];
    if (cellIdentifier && valueIndex != NSNotFound) {
        NSNumber *valueIndexNumber = @(valueIndex);
        BOOL addingCell = (self.additionalDataCellIdentifiers[valueIndexNumber] == nil);
        self.additionalDataCellIdentifiers[valueIndexNumber] = cellIdentifier;
        NSInteger valueFilledIndex = [self.filledObjects indexOfObject:value];
        if (valueFilledIndex != NSNotFound) {
            self.additionalDataFilledCellIdentifiers[@(valueFilledIndex)] = cellIdentifier;
        }

        [self findRowForValueIndex:valueIndex withFoundBlock:^(NSInteger row) {
            if (addingCell) {
                [self.delegate section:self insertCellAtRow:row + 1];
            }
            else {
                [self.delegate section:self reloadCellAtRow:row + 1];
            }
        }];
    }
}

- (void)value:(id<AITValue>)value dismissAdditionalaDataInCellWithIdentifier:(NSString *)cellIdentifier {
    NSInteger valueIndex = [self.allObjects indexOfObject:value];
    if (cellIdentifier && valueIndex != NSNotFound) {
        NSNumber *valueIndexNumber = @(valueIndex);
        NSAssert([cellIdentifier isEqualToString:self.additionalDataCellIdentifiers[valueIndexNumber]], @"Impropper additional cell identifier for dismiss.");
        BOOL removingCell = (self.additionalDataCellIdentifiers[valueIndexNumber] != nil);
        if (removingCell) {
            NSInteger valueFilledIndex = [self.filledObjects indexOfObject:value];

            [self findRowForValueIndex:valueIndex withFoundBlock:^(NSInteger row) {
                [self.additionalDataCellIdentifiers removeObjectForKey:valueIndexNumber];
                if (valueFilledIndex != NSNotFound) {
                    [self.additionalDataFilledCellIdentifiers removeObjectForKey:@(valueFilledIndex)];
                }
                [self.delegate section:self deleteCellAtRow:row + 1];
            }];
        }
    }
}

- (void)valueNeedShow:(id<AITValue>)value {
    NSInteger valueIndex = [[self currentObjects] indexOfObject:value];
    [self.delegate section:self scrollToRow:valueIndex];
}

- (UIPopoverController *)value:(id<AITValue>)value showPopoverWithController:(UIViewController *)viewController {
    NSInteger valueIndex = [[self currentObjects] indexOfObject:value];
    return [self.delegate section:self showPopoverWithController:viewController fromRow:valueIndex];
}

- (void)value:(id<AITValue>)value showDetailsController:(UIViewController *)viewController {
    return [self.delegate section:self showDetailsController:viewController];
}

@end
