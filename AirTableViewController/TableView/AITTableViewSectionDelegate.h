//
//  AITTableViewSectionDelegate.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@class AITTableViewSection;


@protocol AITTableViewSectionDelegate<NSObject>

@required

- (void)section:(AITTableViewSection *)section insertCellAtRow:(NSInteger)row;
- (void)section:(AITTableViewSection *)section updateCellAtRow:(NSInteger)row;
- (void)section:(AITTableViewSection *)section deleteCellAtRow:(NSInteger)row;

@end