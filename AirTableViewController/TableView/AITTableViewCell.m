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
    [self unsubscribeTextValueChanges];
}

- (void)setup {
}

- (void)setValue:(id<AITValue>)value {
    if (_value != value) {
        [self unsubscribeTextValueChanges];

        _value = value;

        [self updateSubviews];
        [self subscribeTextValueChanges];
    }
}

- (NSArray *)keyPathsForSubscribe {
    return @[ @"value", @"placeholder" ];
}

- (void)subscribeTextValueChanges {
    for (NSString *keyPath in [self keyPathsForSubscribe]) {
        [(NSObject *)self.value addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unsubscribeTextValueChanges {
    for (NSString *keyPath in [self keyPathsForSubscribe]) {
        [(NSObject *)self.value removeObserver:self forKeyPath:keyPath];
    }
}

- (void)updateSubviews {
    self.titleLabel.text = [self.value title];
    self.valueLabel.text = [self.value value];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.value) {
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

- (void)perform {
    // do nothing
}


@end
