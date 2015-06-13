//
//  AITSettingsTableView.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.02.14.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsTableView.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsTableView ()
@end


#pragma mark - Implementation

@implementation AITSettingsTableView


- (void)tintColorDidChange {
    [super tintColorDidChange];

    NSArray *indexPaths = [self indexPathsForVisibleRows];
    [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
