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

@property (nonatomic, assign, getter=isFirstAitResponder) BOOL firstAitResponder;

// Cell can disappear but do not removed or reuse. For previous AITValue can dequeued other cell.
// Therefore we neew unsubscribe changes in disappear. But we can unsubscribe on change value.
// So we can unsubscribe twice and get exception.
@property (nonatomic, assign) BOOL subscribedValueChanges;

@end


#pragma mark - Implementation

@implementation AITTableViewCell

+ (void)setupTableView:(UITableView *)tableView {
    NSString *className = NSStringFromClass(self);
    UINib *nib = [UINib nibWithNibName:className bundle:[NSBundle bundleForClass:self]];
    [tableView registerNib:nib forCellReuseIdentifier:className];
}

+ (CGFloat)preferredHeightForValue:(AITValue *)value {
    return 0.;
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
    NSAssert(!_subscribedValueChanges, @"-willRemove should invokes");
}

- (void)willRemove {
    [self unsubscribeValueChanges];
}

- (void)setup {
    self.selectionStyle = self.defaultSelectionStyle;
    
}

- (UITableViewCellSelectionStyle)defaultSelectionStyle {
    return UITableViewCellSelectionStyleBlue;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.firstAitResponder = NO;
}

- (void)setValue:(AITValue *)value {
    if (_value != value) {
        [self unsubscribeValueChanges];
        
        _value = value;

        [self updateSubviews];
        [self updateAitResponderState];
        [self subscribeValueChanges];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    [self updateSubviews];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (!hidden) {
        [self updateAitResponderState];
    }
}

- (void)cellWillDisplay {
    [self subscribeValueChanges];
    [self updateAitResponderState];
    [self updateSubviews];
}

- (void)cellDidEndDisplaying {
    [self unsubscribeValueChanges];
}

- (void)updateAitResponderState {
    if ([self.value isFirstAitResponder]) {
        [self becomeFirstAitResponder];
    }
}

- (NSArray *)keyPathsForSubscribe {
    return @[ @"title", @"empty" ];
}

- (void)subscribeValueChanges {
    if (!self.subscribedValueChanges) {
        self.subscribedValueChanges = YES;
        
        for (NSString *keyPath in [self keyPathsForSubscribe]) {
            [self.value addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
        }
        [self subscribeAitResponderValueChanges];
    }
}

- (void)unsubscribeValueChanges {
    if (self.subscribedValueChanges) {
        self.subscribedValueChanges = NO;
        
        [self unsubscribeAitResponderValueChanges];
        for (NSString *keyPath in [self keyPathsForSubscribe]) {
            [self.value removeObserver:self forKeyPath:keyPath];
        }
    }
}

- (void)subscribeAitResponderValueChanges {
    [self.value addObserver:self forKeyPath:@"firstAitResponder" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)unsubscribeAitResponderValueChanges {
    [self.value removeObserver:self forKeyPath:@"firstAitResponder"];
}

- (void)updateSubviews {
    self.titleLabel.text = [self.value title];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.value) {
        if ([@"firstAitResponder" isEqualToString:keyPath]) {
            [self valueDidChangeFirstAitResponder:change];
        } else if (!self.editing) {
        // If editing mode on user changes data. Thus changes from us and predicted recursion.
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

- (void)valueDidChangeFirstAitResponder:(NSDictionary *)change {
    BOOL isFirstAitResponder = [change[NSKeyValueChangeNewKey] boolValue];
    if ([self isFirstAitResponder] != isFirstAitResponder) {
        if (isFirstAitResponder) {
            [self becomeFirstAitResponder];
        }
        else {
            [self resignFirstAitResponder];
        }
    }
}

#pragma mark - AITResponder protocol implementation

- (id<AITResponder>)nextAitResponder {
    return [self.value nextAitResponder];
}

- (void)setNextAitResponder:(id<AITResponder>)nextAitResponder {
    NSAssert(NO, @"cell should not changes aitResponder. Use value instead.");
    [self.value setNextAitResponder:nextAitResponder];
}

- (BOOL)canBecomeFirstAitResponder {
    return [self.value canBecomeFirstAitResponder];
}

- (BOOL)canResignFirstAitResponder {
    return [self.value canResignFirstAitResponder];
}

- (void)becomeFirstAitResponder {
    self.firstAitResponder = YES;
    if (![self.value isFirstAitResponder]) {
        [self.value becomeFirstAitResponder];
    }
}

- (void)resignFirstAitResponder {
    self.firstAitResponder = NO;
    if ([self.value isFirstAitResponder]) {
        [self.value resignFirstAitResponder];
    }
}

- (BOOL)isFirstAitResponder {
    return _firstAitResponder;
}

@end
