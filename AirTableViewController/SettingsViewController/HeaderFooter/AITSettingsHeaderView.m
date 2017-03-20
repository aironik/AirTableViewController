//
//  AITSettingsHeaderView.m
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import "AITSettingsHeaderView.h"

#import "AITSettings.h"
#import "AITTableViewController.h"


@implementation AITSettingsHeaderView

- (void)updateTintColorSelector:(UIColor *)newColor {
    AITSettings *settings = [AITTableViewController defaultSettings];
    if (self.actionBlock != NULL) {
        self.label.textColor = settings.tintColor;
    }
    else {
        self.label.textColor = settings.settingsFooterText;
    }
}

@end
