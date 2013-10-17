//
//  AITDatePickerPopover.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@class AITDateValue;


@interface AITDatePickerPopover : UIViewController

/// @brief The value represents date.
@property (nonatomic, strong) AITDateValue *dateValue;

@property (nonatomic, weak) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *closeButton;

+ (instancetype)datePickerWithValue:(AITDateValue *)value;

@end
