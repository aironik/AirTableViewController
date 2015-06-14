//
//  AITSettingsHeaderView.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsHeaderView.h"


@implementation AITSettingsHeaderView

- (void)updateTintColorSelector:(UIColor *)newColor {
    if (self.actionBlock != NULL) {
        self.label.textColor = AIT_COLOR_TINT;
    }
    else {
        self.label.textColor = AIT_COLOR_SETTINGS_FOOTER_TEXT;
    }
}

@end
