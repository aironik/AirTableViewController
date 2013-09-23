//
//  AITHeaderFooterSection.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITHeaderFooterSection.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITHeaderFooterSection ()
@end


#pragma mark - Implementation

@implementation AITHeaderFooterSection

+ (instancetype)sectionWithTitle:(NSString *)header footer:(NSString *)footer {
    return [[self alloc] initWithTitle:header footer:footer];
}

- (id)initWithTitle:(NSString *)title footer:(NSString *)footer {
    if (self = [super init]) {
        self.title = title;
        self.footer = footer;
    }
    return self;
}

- (NSString *)tableViewTitleForHeader:(UITableView *)tableView {
    return self.title;
}

- (NSString *)tableViewTitleForFooter:(UITableView *)tableView {
    return self.footer;
}

@end
