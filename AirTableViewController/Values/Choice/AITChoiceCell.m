//
//  AITChoiceCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITChoiceCell.h"

#import "AITTableViewCell.h"
#import "AITChoiceOption.h"
#import "AITChoiceValue.h"
#import "AITTableViewCell+AITProtected.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITChoiceCell ()
@end


#pragma mark - Implementation

@implementation AITChoiceCell

- (AITChoiceValue *)choiceValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITChoiceValue class]]);
    return (AITChoiceValue *)self.value;

}

- (void)setChoiceValue:(AITChoiceValue *)choiceValue {
    NSParameterAssert(!choiceValue || [choiceValue isKindOfClass:[AITChoiceValue class]]);
    self.value = choiceValue;
}

- (void)setup {
    [super setup];

    self.valueLabel.text = [self.choiceValue.value stringRepresentation];
}

- (NSArray *)keyPathsForSubscribe {
    return [@[ @"value" ] arrayByAddingObjectsFromArray:[super keyPathsForSubscribe]];
}

- (void)updateSubviews {
    [super updateSubviews];

    self.valueLabel.text = [self.choiceValue.value stringRepresentation];

}

@end
