//
//  AITDatePickerCell.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import "AITTableViewCell.h"


@class AITDateValue;


@interface AITDatePickerCell : AITTableViewCell

/// @brief The text label for show date value.
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

/// @brief The value represents date.
@property (nonatomic, strong) AITDateValue *dateValue;

@end
