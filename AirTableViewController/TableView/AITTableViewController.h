//
//  AITTableViewController.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//



@interface AITTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *sections;

- (void)save;
- (void)rollback;

@end
