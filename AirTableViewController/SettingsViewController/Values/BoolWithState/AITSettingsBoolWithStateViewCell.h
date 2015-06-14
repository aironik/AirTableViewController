//
//  AITSettingsBoolWithStateViewCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 13.06.15.
//  Copyright © 2015 aironik. All rights reserved.
//

#import <AirTableViewController/SettingsViewController/Values/Bool/AITSettingsBoolCell.h>


@class AITSettingsBoolWithStateViewValue;


@interface AITSettingsBoolWithStateViewCell : AITSettingsBoolCell

@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;

@property (nonatomic, weak) IBOutlet UIView *stateView;

@property (nonatomic, weak) AITSettingsBoolWithStateViewValue *boolWithStateValue;

@end
