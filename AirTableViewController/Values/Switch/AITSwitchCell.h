//
//  AITSwitchCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 23.09.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewCell.h"


@class AITSwitchValue;


/// @brief The cell represent boolean value.
@interface AITSwitchCell : AITTableViewCell

/// @brief The UISwitch control that represents value
@property (nonatomic, weak) IBOutlet UISwitch *switchControl;

/// @brief The value represents boolean.
@property (nonatomic, strong) AITSwitchValue *switchValue;

@end
