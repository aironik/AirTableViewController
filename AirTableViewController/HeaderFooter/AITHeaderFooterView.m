//
//  AITHeaderFooterView.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITHeaderFooterView.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


NSString *const kAITHeaderFooterViewLeftAlignedHeaderIdentifier = @"AITLeftAlignedHeaderView";
NSString *const kAITHeaderFooterViewCenterAlignedFooterIdentifier = @"AITCenterAlignedFooterView";


@interface AITHeaderFooterView ()
@end


#pragma mark - Implementation

@implementation AITHeaderFooterView

+ (NSMutableDictionary *)registeredNibs {
    static NSMutableDictionary *registeredNibs = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        registeredNibs = [[NSMutableDictionary alloc] init];

        UINib *nib = [UINib nibWithNibName:@"AITLeftAlignedHeaderView" bundle:[NSBundle bundleForClass:self]];
        registeredNibs[kAITHeaderFooterViewLeftAlignedHeaderIdentifier] = nib;

        nib = [UINib nibWithNibName:@"AITCenterAlignedFooterView" bundle:[NSBundle bundleForClass:self]];
        registeredNibs[kAITHeaderFooterViewCenterAlignedFooterIdentifier] = nib;
    });
    return registeredNibs;
}

+ (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)reuseIdentifier {
    NSParameterAssert([reuseIdentifier length]);
    if (nib) {
        [self registeredNibs][reuseIdentifier] = nib;
    }
    else {
        [[self registeredNibs] removeObjectForKey:reuseIdentifier];
    }
}

+ (void)setupTableView:(UITableView *)tableView {
    NSDictionary *registeredNibs = [[self class] registeredNibs];
    for (NSString *identifier in registeredNibs) {
        [tableView registerNib:registeredNibs[identifier] forHeaderFooterViewReuseIdentifier:identifier];
    }
}

+ (AITHeaderFooterView *)headerFooterViewWithIdentifier:(NSString *)identifier {
    UINib *nib = [self registeredNibs][identifier];
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    AITHeaderFooterView *result;
    for (NSObject *object in nibObjects) {
        if ([object isKindOfClass:[AITHeaderFooterView class]]) {
            result = (AITHeaderFooterView *)object;
            break;
        }
    }
    NSParameterAssert([result isKindOfClass:[AITHeaderFooterView class]]);
    return result;
}

+ (AITHeaderFooterView *)leftAlignedHeaderViewForTableView {
    return [self headerFooterViewWithIdentifier:kAITHeaderFooterViewLeftAlignedHeaderIdentifier];
}

+ (AITHeaderFooterView *)centerAlignedFooterView {
    return [self headerFooterViewWithIdentifier:kAITHeaderFooterViewCenterAlignedFooterIdentifier];
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
    const CGFloat width = CGRectGetWidth(tableView.bounds);
    const CGFloat labelWidthMargins = CGRectGetWidth(self.bounds) - CGRectGetWidth(self.label.frame);
    const CGFloat labelHeightMargins = CGRectGetHeight(self.bounds) - CGRectGetHeight(self.label.frame);
    const CGFloat labelWidth = width - labelWidthMargins;
    CGSize labelSize = [self.label.text sizeWithFont:self.label.font
                                   constrainedToSize:CGSizeMake(labelWidth, 1000.)
                                       lineBreakMode:self.label.lineBreakMode];
    return labelSize.height + labelHeightMargins;
}


@end
