//
//  AITChoiceOptionSelectorViewController.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 21.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITChoiceOptionSelectorViewController.h"
#import "AITChoiceValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITChoiceOptionSelectorViewController ()
@end


#pragma mark - Implementation

@implementation AITChoiceOptionSelectorViewController


- (void)dealloc {
    [self unsubscribeValueChanges];
}

- (void)setValue:(AITChoiceValue *)value {
    if (_value != value) {
        [self unsubscribeValueChanges];
        _value = value;
        [self subscribeValueChanges];
    }
}

- (NSArray *)keyPathsForSubscribe {
    return @[ @"allOptions", @"value" ];
}

- (void)subscribeValueChanges {
    for (NSString *keyPath in [self keyPathsForSubscribe]) {
        [self.value addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unsubscribeValueChanges {
    for (NSString *keyPath in [self keyPathsForSubscribe]) {
        [self.value removeObserver:self forKeyPath:keyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.value && ([@"allOptions" isEqualToString:keyPath] || [@"value" isEqualToString:keyPath])) {
        [self.tableView reloadData];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.value.allOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
