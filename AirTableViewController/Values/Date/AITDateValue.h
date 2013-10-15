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
@property (nonatomic, copy) NSDate *value;

/// @brief The value represents whether value is empty.
@property (nonatomic, assign, getter=isEmpty) BOOL empty;

/// @brief Create new value represents string value with name.
/// @param title Human readable property name.
/// @param sourceObject the object having string property for present.
/// @param sourcePropertyName the property name (keypath) that needs represent.
/// @param comment the human readable value description.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName;

@end
