//
//  AITDateValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.10.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponderValue.h>
#import <AirTableViewController/TableView/AITValue.h>


/// @brief The value represents date value.
@interface AITDateValue : AITResponderValue<AITValue>

/// @brief The value name.
@property (nonatomic, copy) NSString *title;

/// @brief The date value from source.
@property (nonatomic, strong) NSDate *value;

/// @bierf The date that defines minimum possible date for pick. If not specified date picker have no minimum limit.
@property (nonatomic, strong) NSDate *minimumDate;

/// @bierf The date that defines maximum possible date for pick. If not specified date picker have no maximum limit.
@property (nonatomic, strong) NSDate *maximumDate;

/// @brief If YES user can change date.
@property (nonatomic, assign) BOOL dateEditable;

/// @brief The date formatter for convert date into string representation.
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong, readonly) NSDate *dateForPicker;

/// @brief Create new value represents string value with name.
/// @param title Human readable property name.
/// @param sourceObject the object having string property for present.
/// @param sourcePropertyName the property name (keypath) that needs represent.
/// @param comment the human readable value description.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName;

- (void)setupDatePicker:(UIDatePicker *)datePicker;

@end
