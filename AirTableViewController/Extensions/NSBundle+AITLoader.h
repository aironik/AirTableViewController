//
//  NSBundle+AITLoader.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//


@interface NSBundle(AITLoader)

+ (instancetype)ait_bundle;
- (id)ait_loadNibNamed:(NSString *)name class:(Class)class owner:(id)owner;

@end
