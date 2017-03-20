//
//  AITHeaderFooterView.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITHeaderFooterView.h"

#import "UIView+AITUserInterfaceIdiom.h"
#import "NSBundle+AITLoader.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


NSString *const kAITHeaderFooterViewLeftAlignedHeaderIdentifier = @"AITLeftAlignedHeaderView";
NSString *const kAITHeaderFooterViewCenterAlignedHeaderIdentifier = @"AITCenterAlignedHeaderView";
NSString *const kAITHeaderFooterViewLeftAlignedFooterIdentifier = @"AITLeftAlignedFooterView";
NSString *const kAITHeaderFooterViewCenterAlignedFooterIdentifier = @"AITCenterAlignedFooterView";


@interface AITHeaderFooterView ()

@property (nonatomic, weak, readwrite) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@end


#pragma mark - Implementation

@implementation AITHeaderFooterView

+ (NSMutableDictionary *)registeredNibs {
    static NSMutableDictionary *registeredNibs = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        registeredNibs = [[NSMutableDictionary alloc] init];
        UINib *nib = nil;

        nib = [UINib nibWithNibName:@"AITLeftAlignedHeaderView" bundle:[NSBundle ait_bundle]];
        registeredNibs[kAITHeaderFooterViewLeftAlignedHeaderIdentifier] = nib;

        nib = [UINib nibWithNibName:@"AITCenterAlignedHeaderView" bundle:[NSBundle ait_bundle]];
        registeredNibs[kAITHeaderFooterViewCenterAlignedHeaderIdentifier] = nib;

        nib = [UINib nibWithNibName:@"AITLeftAlignedFooterView" bundle:[NSBundle ait_bundle]];
        registeredNibs[kAITHeaderFooterViewLeftAlignedFooterIdentifier] = nib;

        nib = [UINib nibWithNibName:@"AITCenterAlignedFooterView" bundle:[NSBundle ait_bundle]];
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

+ (AITHeaderFooterView *)leftAlignedHeaderView {
    return [self headerFooterViewWithIdentifier:kAITHeaderFooterViewLeftAlignedHeaderIdentifier];
}

+ (AITHeaderFooterView *)centerAlignedHeaderView {
    return [self headerFooterViewWithIdentifier:kAITHeaderFooterViewCenterAlignedHeaderIdentifier];
}

+ (AITHeaderFooterView *)centerAlignedFooterView {
    return [self headerFooterViewWithIdentifier:kAITHeaderFooterViewCenterAlignedFooterIdentifier];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    if (self.tapGestureRecognizer == nil) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(executeAction:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRecognizer];
        self.tapGestureRecognizer = tapRecognizer;
    }
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self updateTintColorSelector:[newSuperview ait_tintColor]];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    [self updateTintColorSelector:[self ait_tintColor]];
}


- (void)updateTintColorSelector:(UIColor *)newColor {
    if (self.actionBlock != NULL) {
        self.label.textColor = newColor;
    }
}

- (IBAction)executeAction:(UIGestureRecognizer *)gestureRecognizer {
    if (self.actionBlock != NULL) {
        self.actionBlock();
    }
}


@end
