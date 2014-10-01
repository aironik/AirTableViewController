//
//  AITTableViewSection(AITProtected).m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//


#import "AITTableViewSection.h"


typedef BOOL (^AITTableViewSectionChanges)(void);


@interface AITTableViewSection (AITProtected)

@property (nonatomic, strong) NSArray *filledObjects;

- (void)tableView:(UITableView *)tableView currentSectionIndex:(NSInteger)index changes:(AITTableViewSectionChanges)changes;
- (void)updateFilledObjects;
- (NSArray *)currentObjects;
- (void)drainRemovedValues;

@end
