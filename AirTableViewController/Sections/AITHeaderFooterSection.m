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


+ (instancetype)sectionWithHeader:(NSString *)header footer:(NSString *)footer {
    return [[self alloc] initWithHeader:header footer:footer];
}

- (id)initWithHeader:(NSString *)header footer:(NSString *)footer {
    if (self = [super init]) {
        self.header = header;
        self.footer = footer;
    }
    return self;
}

- (NSString *)tableViewTitleForHeader:(UITableView *)tableView {
    return self.header;
}

- (NSString *)tableViewTitleForFooter:(UITableView *)tableView {
    return self.footer;
}


@end
