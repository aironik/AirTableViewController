//
//  AITTextValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITResponderValue.h>
#import <AirTableViewController/TableView/AITValue.h>


/// @brief The value represents string value.
@interface AITTextValue : AITResponderValue<AITValue>

/// @brief The value name.
@property (nonatomic, copy) NSString *title;

/// @brief The string value from source.
@property (nonatomic, copy) NSString *value;

/// @brief The human readable value description.
/// @details Used for placeholder.
@property (nonatomic, copy, readonly) NSString *comment;

/// @brief If YES user can edit text.
@property (nonatomic, assign) BOOL textEditable;

// Text input field properties
@property (nonatomic, assign) UITextAutocapitalizationType textInputAutocapitalizationType;
@property (nonatomic, assign) UIKeyboardType textInputKeyboardType;
@property (nonatomic, assign) UIReturnKeyType textInputReturnKeyType;
@property (nonatomic, assign) BOOL textInputSecureTextEntry;
@property (nonatomic, assign) BOOL textInputClearsOnBeginEditing;

/// @brief Create new value represents string value with name.
/// @param title Human readable property name.
/// @param sourceObject the object having string property for present.
/// @param sourcePropertyName the property name (keypath) that needs represent.
/// @param comment the human readable value description.
+ (instancetype)valueWithTitle:(NSString *)title
                  sourceObject:(NSObject *)sourceObject
            sourcePropertyName:(NSString *)sourcePropertyName
                       comment:(NSString *)comment;

@end
