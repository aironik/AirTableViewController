//
//  AITTableViewCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 26.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewCell.h"
#import "AITTableViewCell+AITProtected.h"

#import "AITValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITTableViewCell ()
@end


#pragma mark - Implementation

@implementation AITTableViewCell

+ (void)setupTableView:(UITableView *)tableView {
    NSString *className = NSStringFromClass(self);
    UINib *nib = [UINib nibWithNibName:className bundle:[NSBundle bundleForClass:self]];
    [tableView registerNib:nib forCellReuseIdentifier:className];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSAssert(NO, @"Does not implemented. titleLabel and valueLabel didn't created.");
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setup];
}

- (void)dealloc {
    [self unsubscribeValueChanges];
}

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.deselectImmediately = YES;
}

- (void)setValue:(id<AITValue>)value {
    if (_value != value) {
        [self unsubscribeValueChanges];

        _value = value;

        [self updateSubviews];
        [self subscribeValueChanges];
    }
}

- (NSArray *)keyPathsForSubscribe {
    return @[ @"title", @"empty" ];
}

- (void)subscribeValueChanges {
    for (NSString *keyPath in [self keyPathsForSubscribe]) {
        [self.value addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unsubscribeValueChanges {
    for (NSString *keyPath in [self keyPathsForSubscribe]) {
        [self.value removeObserver:self forKeyPath:keyPath];
    }
}

- (void)updateSubviews {
    self.titleLabel.text = [self.value title];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.value) {
        // If editing mode on user changes data. Thus changes from us and predicted recursion.
        if (!self.editing) {
            [self updateSubviews];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}


@end
