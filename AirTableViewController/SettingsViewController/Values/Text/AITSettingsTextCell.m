//
//  AITSettingsTextCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsTextCell.h"

#import "AITCellEtchedView.h"
#import "AITTableViewCellOverride.h"
#import "AITSettingsTextValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsTextCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleWidthConstraint;

@end


#pragma mark - Implementation


@implementation AITSettingsTextCell

AIT_CELL_OVERRIDE_STATIC

- (void)setTitleWidth:(CGFloat)titleWidth {
    self.titleWidthConstraint.constant = titleWidth;
}

- (CGFloat)titleWidth {
    return self.titleWidthConstraint.constant;
}

- (void)updateSubviews {
    [super updateSubviews];
    
    AITSettingsTextValue *value = (AITSettingsTextValue *)self.value;
    self.valueTextField.textAlignment = value.valueTextAligment;
    
    if ([self.value title] && [self.value title].length != 0) {
        self.titleLabel.text = [self.value title];
        self.titleLabel.hidden = NO;
        
        if (value.titleLabelResizable) {
            self.titleWidthConstraint.constant = [[self.value title] sizeWithFont:self.titleLabel.font
                                                                constrainedToSize:CGSizeMake(INT_MAX, self.titleLabel.font.lineHeight)
                                                                    lineBreakMode:self.titleLabel.lineBreakMode].width + 1;
        }
        else {
            self.titleWidthConstraint.constant = 150;
        }
    }
    else {
        self.titleWidthConstraint.constant = 0;
        self.titleLabel.hidden = YES;
    }
}

@end
