//
//  AITChoiceValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 24.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponderValue.h>
#import <AirTableViewController/TableView/AITValue.h>


@protocol AITChoiceOption;


/// @brief The block for generate human readable title for value.
typedef NSString *(^AITChoiceOptionTitleValueString)(NSObject *value);


/// @brief The value represent select one choice from possible set.
@interface AITChoiceValue : AITResponderValue<AITValue>

/// @brief The value name.
@property (nonatomic, copy) NSString *title;

/// @brief The selected option.
@property (nonatomic, strong) NSObject *value;

/// @brief The human readable string that represent value.
/// @details This value get from sourceObject[sourcePropertyName][valueStringPropertyName]
@property (nonatomic, copy, readonly) NSString *valueString;

/// @brief The value represents whether value is empty and should not be interactable.
/// @details If NO cell hides.
@property (nonatomic, assign, getter=isEmpty) BOOL empty;

/// @brief The array with all possible options for choice value.
/// @details All objects must conforms to AITChoiceOption protocol.
/// @see AITChoiceOption
@property (nonatomic, strong) NSArray *allOptions;

/// @brief Create new value represents choice value with name.
/// @details The value should conform to AITChoiceOption protocol.
///     all values should be NSString objects.
/// @param title Human readable property name.
/// @param sourceObject the object having property for present.
/// @param sourcePropertyName the keypath with choice that needs represent.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName;

/// @brief Create new value represents choice value with name.
/// @details The value should conform to AITChoiceOption protocol.
/// @param title Human readable property name.
/// @param sourceObject the object having property for present.
/// @param sourcePropertyName the keypath with choice that needs represent.
/// @param titleValueString block for generate human readable title for value.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName
              titleValueString:(AITChoiceOptionTitleValueString)titleValueString;

@end
