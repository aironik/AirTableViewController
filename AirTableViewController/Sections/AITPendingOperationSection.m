//
//  AITPendingOperationSection.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITPendingOperationSection.h"

#import "AITTableViewSection+AITProtected.h"
#import "AITPendingOperationValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITPendingOperationSection ()

@property (nonatomic, assign, readwrite) BOOL pendingOperationExecuting;
@property (nonatomic, strong, readonly) AITPendingOperationValue *pendingOperationValue;
@property (nonatomic, strong, readonly) NSArray *pendingOperationObjects;

@end


#pragma mark - Implementation

@implementation AITPendingOperationSection

@synthesize pendingOperationValue = _pendingOperationValue;
@synthesize pendingOperationObjects = _pendingOperationObjects;


- (void)updateFilledObjects {
    self.filledObjects = [self currentObjects];
}

- (NSArray *)pendingOperationObjects {
    if (!_pendingOperationObjects) {
        _pendingOperationObjects = @[ self.pendingOperationValue ];
    }
    return _pendingOperationObjects;
}

- (NSArray *)currentObjects {
    return (self.pendingOperationExecuting ? self.pendingOperationObjects : self.allObjects);
}

- (AITPendingOperationValue *)pendingOperationValue {
    if (!_pendingOperationValue) {
        _pendingOperationValue = [AITPendingOperationValue valueWithTitle:nil];
    }
    return _pendingOperationValue;
}

- (void)tableView:(UITableView *)tableView setPendingOperationExecuting:(BOOL)executing currentSectionIndex:(NSInteger)index {
    [self tableView:tableView currentSectionIndex:index changes:^BOOL() {
        const BOOL changed = ((executing && !self.pendingOperationExecuting) || (!executing && self.pendingOperationExecuting));
        self.pendingOperationExecuting = executing;
        return changed;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRow:(NSInteger)row {
    CGFloat result = 0.0;
    if (self.pendingOperationExecuting) {
        result = [tableView rowHeight] * [self.allObjects count];
    }
    else {
        result = [super tableView:tableView heightForRow:row];
    }
    return result;
}


@end
