//
//  AITHeaderFooterSection.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITTableViewSection.h>


@interface AITHeaderFooterSection : AITTableViewSection

+ (instancetype)sectionWithHeader:(NSString *)header footer:(NSString *)footer;

@end
