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

// methods for rows in sections
- (void)section:(AITTableViewSection *)section insertCellAtRow:(NSInteger)row;
- (void)section:(AITTableViewSection *)section reloadCellAtRow:(NSInteger)row;
- (void)section:(AITTableViewSection *)section deleteCellAtRow:(NSInteger)row;
- (void)section:(AITTableViewSection *)section scrollToRow:(NSInteger)row;

// methods for sections
- (void)reloadSection:(AITTableViewSection *)section;


// TODO: remove method below
- (UIPopoverController *)section:(AITTableViewSection *)section showPopoverWithController:(UIViewController *)viewController fromRow:(NSInteger)row;
- (void)section:(AITTableViewSection *)section showDetailsController:(UIViewController *)viewController;

@end
