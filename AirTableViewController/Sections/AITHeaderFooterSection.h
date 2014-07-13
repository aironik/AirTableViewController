//
//  AITHeaderFooterSection.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITTableViewSection.h>


/// @brief Section that can contains header only or footer only.
/// @details If AITTableViewSection doesn't contains cell it hide header and foter.
///     Neverthless you can use AITHeaderFooterSection for show header only or footer only.
@interface AITHeaderFooterSection : AITTableViewSection

+ (instancetype)sectionWithHeader:(NSString *)header footer:(NSString *)footer;

@property (nonatomic, strong, readonly) AITHeaderFooterView *headerView;
@property (nonatomic, strong, readonly) AITHeaderFooterView *footerView;

@end
