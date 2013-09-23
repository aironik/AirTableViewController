//
//  AITHeaderFooterSection.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITTableViewSection.h>


@interface AITHeaderFooterSection : AITTableViewSection

+ (instancetype)sectionWithTitle:(NSString *)header footer:(NSString *)footer;
- (id)initWithTitle:(NSString *)string footer:(NSString *)footer;

@end
