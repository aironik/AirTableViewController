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


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation = UITableViewRowAnimationFade;


@interface AITTableViewSection ()

@property (nonatomic, strong) NSArray *filledObjects;

- (NSArray *)currentObjects;

@end


#pragma mark - Implementation

@implementation AITTableViewSection

- (void)setAllObjects:(NSArray *)allObjects {
    _allObjects = [allObjects copy];
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
        return self.title;
    }
    return nil;
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


@end
