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

// methods AitResponders
/// @brief Tells the delegate that a specified value has become first AIT responder
- (void)section:(AITTableViewSection *)section valueDidBecomeFirstAitResponder:(AITValue *)value;

/// @brief Tells the delegate that a specified value has resign first AIT responder
- (void)section:(AITTableViewSection *)section valueDidResignFirstAitResponder:(AITValue *)value;

@end
