//
//  AITTextValue.h
//  AirTableViewController
//
//  Created by Oleg Lobachev aironik@gmail.com on 18.08.13.
//  Copyright © 2013 aironik. All rights reserved.
//

#import <AirTableViewController/TableView/AITValue.h>


/// @brief The value represents string value.
@interface AITTextValue : NSObject<AITValue>

/// @brief The value name.
@property (nonatomic, copy) NSString *title;

/// @brief The boolean value from source.
@property (nonatomic, copy) NSString *value;

/// @brief The human readable value description.
/// @details Used for placeholder.
@property (nonatomic, copy, readonly) NSString *comment;

/// @brief The value represents whether value is empty and should not be interactable.
/// @details If NO cell hides.
@property (nonatomic, assign, getter=isEmpty) BOOL empty;

/// @brief If YES user can edit text.
@property (nonatomic, assign) BOOL textEditable;

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
