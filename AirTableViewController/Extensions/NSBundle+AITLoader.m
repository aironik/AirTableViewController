//
//  NSBundle+AITLoader.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "NSBundle+AITLoader.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@implementation NSBundle(AITLoader)


static NSString *bundlePath = nil;
static NSBundle *bundle = nil;


+ (NSString *)ait_bundlePath {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (bundlePath == nil) {
            bundlePath = [[NSBundle mainBundle] pathForResource:@"AirTableViewController" ofType:@"bundle"];
        }
    });
    return bundlePath;
}

+ (instancetype)ait_bundle {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (bundle == nil) {
            // TODO: WRITE ME
            bundle = [NSBundle mainBundle];
//            bundle = [NSBundle bundleWithPath:[self ait_bundlePath]];
        }
    });
    return bundle;
}

- (id)ait_loadNibNamed:(NSString *)name class:(Class)class owner:(id)owner {
    NSArray *content = [[[self class] ait_bundle] loadNibNamed:name owner:owner options:nil];
    for (id obj in content) {
        if ([obj isKindOfClass:class]) {
            return obj;
        }
    }
    return nil;
}


@end
