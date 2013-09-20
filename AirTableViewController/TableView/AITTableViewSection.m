//
//  AITTableViewSection.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewSection.h"

#import "AITTableViewTextCell.h"
#import "AITTextValue.h"
#import "AITTableViewCell.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


const UITableViewRowAnimation kAILTableViewSectionDefaultRowAnimation = UITableViewRowAnimationFade;


@interface AITTableViewSection ()

@property (nonatomic, strong) NSArray *filledObjects;

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
    [self updateFilledObjects];
//    const BOOL changed = ((editing && !self.editing) || (!editing && self.editing));
    self.editing = editing;
//    if (changed) {
//        const BOOL insert = editing;
//        NSUInteger filledIndex = 0;
//        const NSUInteger filledCount = [self.filledObjects count];
//        for (NSUInteger i = 0; i < [self.allObjects count]; ++i) {
//            id<AITValue> value = self.allObjects[i];
//            id<AITValue> filledValue = filledCount > filledIndex ? self.filledObjects[filledIndex] : nil;
//            if (value == filledValue) {
//                NSArray *indexPaths = nil;
//                if (insert) {
//                    indexPaths = @[ [NSIndexPath indexPathForRow:filledIndex inSection:index] ];
//                }
//                else {
//                    indexPaths = @[ [NSIndexPath indexPathForRow:i inSection:index] ];
//                }
//                [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
//                ++filledIndex;
//            }
//            else {
//                NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:i inSection:index] ];
//                if (insert) {
//                    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
//                }
//                else {
//                    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:kAILTableViewSectionDefaultRowAnimation];
//                }
//            }
//        }
//    }

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
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
    return (self.editing ? [self.allObjects objectAtIndex:row] : [self.filledObjects objectAtIndex:row]);
}

- (NSInteger)tableViewNumberOfRows:(UITableView *)tableView {
    return (self.editing ? [self.allObjects count] : [self.filledObjects count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRow:(NSInteger)row {
    id<AITValue> value = [self valueAtRow:row];
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
