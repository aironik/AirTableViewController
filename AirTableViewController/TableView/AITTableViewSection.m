//
//  AITTableViewSection.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewSection.h"
#import "AITTableViewSection+AITProtected.h"

#import "AITTextCell.h"
#import "AITTextValue.h"
#import "AITTableViewCell.h"
#import "AITValue.h"
#import "AITHeaderFooterView.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation = UITableViewRowAnimationFade;


@interface AITTableViewSection ()

@property (nonatomic, strong) NSArray *filledObjects;
@property (nonatomic, strong) AITHeaderFooterView *headerView;
@property (nonatomic, strong) AITHeaderFooterView *footerView;

- (NSArray *)currentObjects;

@end


#pragma mark - Implementation

@implementation AITTableViewSection

@synthesize headerViewIdentifier = _headerViewIdentifier;
@synthesize footerViewIdentifier = _footerViewIdentifier;

- (void)setAllObjects:(NSArray *)allObjects {
    _allObjects = [allObjects copy];
    [self updateObjectsResponderChain];
    [self updateFilledObjects];
}

- (void)updateFilledObjects {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id<AITValue> value, NSDictionary *bindings) {
        return !value.isEmpty;
    }];
    self.filledObjects = [self.allObjects filteredArrayUsingPredicate:predicate];
}

- (void)tableView:(UITableView *)tableView setEditing:(BOOL)editing currentSectionIndex:(NSInteger)index {
    [self tableView:tableView currentSectionIndex:index changes:^BOOL() {
        const BOOL changed = ((editing && !self.editing) || (!editing && self.editing));
        self.editing = editing;
        return changed;
    }];
}

- (void)tableView:(UITableView *)tableView currentSectionIndex:(NSInteger)index changes:(AITTableViewSectionChanges)changes {
    NSParameterAssert(changes);

    BOOL changed = NO;
    NSArray *previousObjects = self.currentObjects;
    if (changes) {
        changed = changes();
        [self updateFilledObjects];
    }
    if (changed) {
        [self tableView:tableView currentSectionIndex:index mergeFromPreviousObjects:previousObjects];
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

- (id<AITValue>)valueAtRow:(NSInteger)row {
    return [[self currentObjects] objectAtIndex:row];
}

- (NSArray *)currentObjects {
    return (self.editing ? self.allObjects : self.filledObjects);
}

- (NSInteger)tableViewNumberOfRows:(UITableView *)tableView {
    return (self.editing ? [self.allObjects count] : [self.filledObjects count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row {
    NSObject<AITValue> *value = [self valueAtRow:row];
    NSString *cellIdentifier = [[value class] cellIdentifier];
    AITTableViewCell *result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    result.value = value;
    result.editing = self.editing;
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSInteger)row {
    return [tableView rowHeight];
}

- (void)tableView:(UITableView *)tableView didDeselectRow:(NSInteger)row {
    NSObject<AITValue> *value = [self valueAtRow:row];
    [value perform];
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
    id<AITResponder> previousResponder = nil;
    for (id<AITResponder> responder in self.allObjects) {
        [previousResponder setNextAitResponder:responder];
        previousResponder = responder;
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

- (BOOL)becomeFirstAitResponder {
    for (id<AITValue>value in self.allObjects) {
        if ([value canBecomeFirstAitResponder] && [value becomeFirstAitResponder]) {
            return YES;
        }
    }
    [self.nextAitResponder becomeFirstAitResponder];
    return NO;
}

- (BOOL)resignFirstAitResponder {
    for (id<AITValue>value in self.allObjects) {
        if ([value isFirstAitResponder]) {
            return [value resignFirstAitResponder];
        }
    }
    return YES;
}

- (BOOL)isFirstAitResponder {
    for (id<AITValue>value in self.allObjects) {
        if ([value isFirstAitResponder]) {
            return [value isFirstAitResponder];
        }
    }
    return NO;
}

@end
