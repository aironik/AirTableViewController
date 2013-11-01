//
//  AITDatePickerViewController.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 16.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//


@class AITDateValue;


@interface AITDatePickerViewController : UIViewController

/// @brief The value represents date.
@property (nonatomic, strong) AITDateValue *dateValue;

@property (nonatomic, weak) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

+ (instancetype)datePickerWithValue:(AITDateValue *)value;

- (IBAction)dateValueDidChanged:(UIDatePicker *)sender;

@end
