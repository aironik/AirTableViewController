//
//  AITSettingsSubtitledActionCell.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsSubtitledActionCell.h"

#import "AITSettingsSubtitledActionValue.h"


#if !(__has_feature(objc_arc))
#error ARC required. Add -fobjc-arc compiler flag for this file.
#endif


@interface AITSettingsSubtitledActionCell ()
@end


#pragma mark - Implementation


@implementation AITSettingsSubtitledActionCell


+ (CGFloat)preferredHeightForValue:(AITValue *)value {
    return 64.f;
}

- (AITSettingsSubtitledActionValue *)subtitledValue {
    NSParameterAssert(self.value == nil || [self.value isKindOfClass:[AITSettingsSubtitledActionValue class]]);
    return (AITSettingsSubtitledActionValue *)self.value;
}

- (void)setSubtitledValue:(AITSettingsSubtitledActionValue *)subtitledValue {
    NSParameterAssert(subtitledValue == nil || [subtitledValue isKindOfClass:[AITSettingsSubtitledActionValue class]]);
    self.value = subtitledValue;
}

- (void)updateSubviews {
    [super updateSubviews];

    self.subtitleLabel.text = self.subtitledValue.subtitle;
}


@end
