//
//  AITDetailsCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 11.07.14.
//  Copyright © 2014 aironik. All rights reserved.
//

#import "AITDetailsCell.h"
#import "AITTableViewCell+AITProtected.h"

#import "AITDetailsValue.h"
#import "UIView+AITUserInterfaceIdiom.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITDetailsCell ()
@end


#pragma mark - Implementation

@implementation AITDetailsCell

- (AITDetailsValue *)detailsValue {
    NSParameterAssert(!self.value || [self.value isKindOfClass:[AITDetailsValue class]]);
    return (AITDetailsValue *)self.value;
}

- (void)setDetailsValue:(AITDetailsValue *)detailsValue {
    NSParameterAssert(!detailsValue || [detailsValue isKindOfClass:[AITDetailsValue class]]);
    self.value = detailsValue;
}

- (UITableViewCellSelectionStyle)defaultSelectionStyle {
    return UITableViewCellSelectionStyleBlue;
}


#pragma mark - AITResponder protocol implementation

- (void)becomeFirstAitResponder {
    [self setHighlighted:YES animated:NO];
    [super becomeFirstAitResponder];
}

- (void)resignFirstAitResponder {
    [self setHighlighted:NO animated:YES];
    [super resignFirstAitResponder];
}


@end
